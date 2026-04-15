#Requires -RunAsAdministrator

# enable rdp
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

# require nla
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1

# enable firewall rule
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# test
#Test-NetConnection -ComputerName $TARGET-SERVER -Port 3389
