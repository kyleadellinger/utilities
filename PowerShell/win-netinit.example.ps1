#Requires -RunAsAdministrator

<#
    .SYNOPSIS
        This script configures the network adapter of a Windows machine.
        (Putting here for memory, will likely be harvested for parts or whatever.)

    .DESCRIPTION
        Intended for use as network initialization against a new Windows Server OS installation,
        in conjunction with automated Packer workflow, in order to facilitate further machine
        configuration via remote control.

        Assigns: IPv4 address, gateway, DNS server(s), subnet mask.
        Basic validation in place for IPv4 address, gateway, and nameservers.

        Currently, this assumes that one net adapter exists on the target host, and it will remove
        any existing IP address/routes/DNS from this net adapter.

    .PARAMETER ipaddress
        A valid IPv4 address. This will be assigned as the IPv4 address of the target Windows host.

    .PARAMETER gateway
        If not provided, will be derived based on provided IPv4 address. If this is not ideal, provide it here.

    .PARAMETER subnet
        Defaults to 255.255.255.0. Parameter provided for future flexibility, however, very limited validation is performed:
        only subnets '255.255.255.0', '255.255.0.0', and '255.0.0.0' will be accepted.

        Overriding this parameter does not affect any other parameters herein, and adjusting this parameter more or less
        assumes you know what you're doing, and why you're doing it. Even then, it may still fail.

    .PARAMETER nameservers
        Attempts to parse provided IP addresses as a string containing either a single IP, or multiple IPs that are comma-separated.
        If parameter is empty, or is otherwise unable to be properly parsed, this will fall back to '10.248.48.31' and '10.248.48.32', 
        which are --, respectively.

    .PARAMETER logfile
        Defaults to "C:\tmp\win-net-init.log". Records log output from script results.
        Logging is enabled by default. To disable, set this to an emptry string, eg `-logfile ""`

        This option is mutually exclusive with `dryrun`.

    .PARAMETER dryrun
        Defaults to $false. Perhaps useful for debugging, or testing; if provided, print out the values that would be assigned,
        without actually changing anything.

    .EXAMPLE
        PS> Win-NetInit -ipaddress 192.168.1.2

    .EXAMPLE
        PS> Win-NetInit -ipaddress 10.248.53.62 -gateway 10.248.53.6 -nameservers @("10.248.48.51")

    .EXAMPLE
        PS> Win-NetInit 10.248.53.62 -nameservers 10.248.48.53

    .EXAMPLE
        PS> Win-NetInit -ipaddress 10.248.53.62 -nameservers 10.248.48.53 -dryrun
            prints:
                Provided IPv4: 10.248.53.62
                Derived gateway: 10.248.53.1
                Assigned DNS: 10.248.48.53
                Subnet Mask:  255.255.255.0

    #>

param(
[Parameter(Mandatory=$true)]
[ipaddress] $ipaddress,

[Parameter(Mandatory=$false)]
[string] $gateway = "",

[Parameter(Mandatory=$false)]
[ValidateSet('255.0.0.0', '255.255.0.0', '255.255.255.0')]
[string] $subnet = "255.255.255.0",

[Parameter(Mandatory=$false)]
[string] $nameservers = "",

[Parameter(Mandatory=$false)]
[string] $log = "C:\tmp\win-net-init.log",

[Parameter(Mandatory=$false)]
[switch] $dryrun = $false
)

function klog {
    <#
    .SYNOPSIS
        (Script Helper Function)
        This function adds timestamps to arbitrary string content and writes it to a provided text file.
        It's a sort of an elementary logging mechanism.

    .PARAMETER logfile
        The file to write log messages to.

    .PARAMETER info
        The message to write to the log file.

    #>
    param(
        [parameter(mandatory=$false)]
        [string] $info,

        [parameter(Mandatory=$false)]
        [string] $logfile = "C:\tmp\klogger.txt"

        )
        if (-not $logfile) {
            if ($info) {
                write-output $info
            }
            return
        }

        if (-not (Test-Path -Path $logfile)) {
            New-Item -Path $logfile -ItemType File -Force
        }

        if ($info) {
            Add-Content -Value "$(get-date) - Debug | $info" -path $logfile
            return
        } else {
            Add-Content -Value "$(get-date) - Debug | No info provided"
            Return
        }
    } # function

function Derive-IPv4GatewayAddr{
    <#
    .SYNOPSIS
        (Script Helper Function)
        Validate a provided IPv4 address and return its gateway address.

    .PARAMETER ipaddress
        An IPv4 address, without prefix, in dotted decimal notation.
        eg: 192.168.1.2

    .PARAMETER lastoctect
        Override the last octect value. This defaults to 1.

    .EXAMPLE
        PS> Derive-IPv4GatewayAddr -ipaddress 192.168.1.2
            would return: 192.168.1.1

    .EXAMPLE
        PS> Derive-IPv4GatewayAddr -ipaddress 10.255.255.255 -lastoctet 5
            would return: 10.255.255.5

    #>
    [cmdletbinding()]
    [outputtype([ipaddress])]
    param(
        [Parameter(Mandatory=$true)]
        [ipaddress] $ipaddress,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1, 255)]
        [int32] $lastoctet = 1
    )

    $figure_octets = $ipaddress.tostring().split(".")
    $figure_octets[-1] = $lastoctet
    [ipaddress]$newipaddress = $figure_octets -join '.'
    Write-Output $newipaddress
} # function


function Win-NetInit {
    <#
    Main Function
    #>

    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true)]
    [ipaddress] $ipaddress,

    [Parameter(Mandatory=$false)]
    [string] $gateway = "",

    [Parameter(Mandatory=$false)]
    [ValidateSet('255.0.0.0', '255.255.0.0', '255.255.255.0')]
    [string] $subnet = "255.255.255.0",

    [Parameter(Mandatory=$false)]
    [string[]] $nameservers = "",

    [Parameter(Mandatory=$false)]
    [string] $log = "C:\tmp\win-net-init.log",

    [Parameter(Mandatory=$false)]
    [switch] $dryrun = $false

    # TODO: accommodate ipv6
    #[Parameter(Mandatory=$false)]
    #[bool] $is_ipv6 = $false
    )
    $fallback_dns = @("10.248.48.31", "10.248.48.32")

    if ($subnet -eq '255.255.255.0') {
        $maskbits = "24"
    } elseif ($subnet -eq '255.0.0.0') {
        $maskbits = "8"
    } elseif ($subnet -eq '255.255.0.0') {
        $maskbits = "16"
    }
    
    try {
        [ipaddress[]]$parsed_dns = $nameservers.split(",")
    } catch {
        [ipaddress[]]$parsed_dns = $fallback_dns
    }

    if (-not ($gateway)) {
        $gateway = Derive-IPv4GatewayAddr -ipaddress $ipaddress
    }

    if ($dryrun -eq $true) {
        write-output "Provided IPv4:   $($ipaddress.tostring())"
        write-output "Derived Gateway: $($gateway.tostring())"
        write-output "Assigned DNS:    $parsed_dns"
        write-output "Subnet Mask:     $subnet"
        return
    }

    $adapter = Get-NetAdapter | Where-Object -Property status -eq "up"
    klog -info "Using $adapter" -logfile $log

    $adapter | Remove-NetIPAddress -addressfamily IPv4 -confirm:$false
    klog -info "Removed previous IP address from $adapter" -logfile $log

    $adapter | Remove-NetRoute -AddressFamily IPv4 -confirm:$false
    klog -info "Removed previous net route from $adapter" -logfile $log

    $adapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $ipaddress -PrefixLength $maskbits -DefaultGateway $($gateway.tostring())
    klog -info "Set IPv4: $ipaddress | Prefix: $maskbits | Default Gateway: $($gateway.tostring())" -logfile $log

    $adapter | Set-DnsClientServerAddress -ServerAddresses $parsed_dns
    klog -info "Nameservers $parsed_dns" -logfile $log

} # function

# MAIN
Win-NetInit -ipaddress $ipaddress -gateway $gateway -subnet $subnet -nameservers $nameservers
