<#
.SYNOPSIS
Enables PowerShell remoting on a remote computer. Relies upon WMI requests.

.EXAMPLE
Enable-RemotePSRemoting <TargetComputer>
#>

param(
	## computer on which to enable remoting
	$ComputerName,

	[Switch] $SkipNetworkProfileCheck,

	## credential to use when connecting
	[PSCredential] $Credential
)

Set-StrictMode -Version 3
$VerbosePreference = "Continue"

Write-Verbose "Configuring $computername"
$skipNetworkProfileCheckFlag = '$' + $SkipNetworkProfileCheck.IsPresent
$command = "powershell -NoProfile -Command" +
	"Enable-PSRemoting -SkipNetworkProfileCheck:$skipNetworkProfileCheckFlag -Force"

if ($Credential) {
	$null = Invoke-WmiMethod -Computer $computername -Credential $credential Win32_Process Create -Args $command
	Start-Sleep -Seconds 10

	Write-Verbose "Testing Connection"
	Invoke-Command $computername {
		Get-WmiObject Win32_ComputerSystem } -Credential $credential
} else {
	$null = Invoke-WmiMethod -Computer $computername Win32_Process Create -Args $command
	Start-Sleep -Seconds 10

	Write-Verbose "Testing Connection"
	Invoke-Command $computername { Get-WmiObject Win32_ComputerSystem }
}
