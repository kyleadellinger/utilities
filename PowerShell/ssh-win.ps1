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
