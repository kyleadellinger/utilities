#Requires -RunAsAdministrator

function check-ssh {
    param(
    [switch]$client,
    [switch]$server
    )
    if ($client) {
        $check = Get-WindowsCapability -Online | Where-Object -Property Name -like 'OpenSSH.client*'
    } elseif ($server) {
        $check = Get-WindowsCapability -Online | Where-Object -Property Name -like 'OpenSSH.server*'
    } else {
        Write-Output "'client' or 'server' switch expected"
        exit 0
    }
    $check
} # function

Add-WindowsCapability -Online -Name (check-ssh -server).name
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue)) {
    Write-Output "Creating firewall rule"
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule exists"
}

if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

#Add-Content $PROFILE '$ProgressPreference = "SilentyContinue"'
# that is not working as expected for some idiotic reason

<# 
OTHER NOTES for ssh:

# Standard User:
$authkey = Get-Content -Path $env:USERPROFILE\.ssh\${keyfile}
New-Item -Force -ItemType Directory -Path $env:USERPROFILE\.ssh
Add-Content -Force -Path $env:USERPROFILE\.ssh\authorized_keys -Value $authkey
# ssh username@domain@server.com

# Administrative User:
# same first steps
$authkey = Get-Content -Path $env:USERPROFILE\.ssh\${keyfile}
Add-Content -Force -Path $env:ProgramData\ssh\administrators_authorized_keys -Value $authkey
# ACLs:
icacls.exe $env:ProgramData\ssh\administrators_authorized_keys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"

#>

######
## additional notes that have been validated/tested:
<#
# obtain "the object"
$GetSSHServer = Get-WindowsCapability -Online | Where-Object -Property 'name' -like 'OpenSSH.server*'

# add/install it
Add-WindowsCapability -Online -Name $GetSSHServer.name

# ensure service started/running
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# firewall
New-NetFirewallRule -DisplayName 'OpenSSH Server' `
    -Name 'OpenSSH-Server-In-TCP' `
    -Direction Inbound `
    -Protocol TCP `
    -Action Allow `
    -LocalPort 22 `
    -RemoteAddress Any

# set default ssh login shell to powershell instead of cmd
# (because why the fuck would cmd be the default.... tracks tho.... clownassshit)
$SSHPropertyParams = @{
  Path = 'HKLM:\SOFTWARE\OpenSSH'
  Name = 'DefaultShell'
  Value = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
  PropertyType = 'String'
  Force = $true
}

New-ItemProperty @SSHPropertyParams

