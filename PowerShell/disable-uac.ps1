# obviously hack
#Requires -RunAsAdministrator

# HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System
# EnableLUA
# value = 0
# does require reboot

# base command would be like:
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name "EnableLUA" -Value 0
