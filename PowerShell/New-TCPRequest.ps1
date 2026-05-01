
<#

	.SYNOPSIS
	Test TCP connection.
	**

	This is also interesting to review the script blocks and function(s),
	then also dot sourcing main at the bottom.
	
	**

	.EXAMPLE
	PS > $http = @"
	  GET / HTTP/1.1
	  Host:cloudflare.com
	  `n`n
	"@

	$http | Send-TcpRequest cloudflare.com -Port 80
	###

	.PARAMETER ComputerName
	  Target host

	.PARAMETER Test
	  [switch] Initate TCP connection and return.
	
	.PARAMETER Port
	  Target port

	.PARAMTER UseSSL
	  Use transport layer security

	.PARAMETER eh

	.PARAMETER Delay
	  Pause in milliseconds between remote commands

#>
# largely from a book, serves as an example
#
[CmdletBinding()]
param(
[Parameter(Mandatory=$false, Position=0)]
[string] $ComputerName = "localhost",

[Parameter(Mandatory=$false)]
[switch] $Test,

[Parameter(Mandatory=$false)]
[int] $Port = 80,

[Parameter(Mandatory=$false)]
[switch] $UseSSL,

# value to send to remote host
[Parameter(Mandatory=$false)]
[string] $InputObject,

# delay in milliseconds to wait between commands
[Parameter(Mandatory=$false)]
[int] $Delay = 100
)

Set-StrictMode -Version 3
Write-Verbose -Message @"

Target Computer: $ComputerName
Target Port    : $Port
Test           : $Test
UsingSSL       : $UseSSL
Input          : $InputObject
Delay          : $Delay

"@

[string] $SCRIPT:output = ""

# input into array to scan over. If no input, interactive mode.
$currentInput = $inputObject

if (-not($currentInput))
{
	$currentInput = @($input)
}
$scriptedMode = ([bool] $currentInput) -or $test

function Main
{
	## open socket, connect to computer on specified port
	if (-not($scriptedMode))
	{
		Write-Verbose -Message "Connecting to $ComputerName on port $Port"
	}
	try
	{
		$tcpClient = New-Object Net.Sockets.TcpClient($ComputerName, $Port)
	}
	catch
	{
		if ($test) { $false }
		else { Write-Error -Message "Could not connect to remote computer: $_" }
		return
	}

## if just testing, and connection successful, return $true
if ($test) { return $true }

## if interactive, supply prompt
if (-not ($scriptedMode))
{
	Write-Host -Message "Connected: Press ^D then [enter] to exit.`n"
}

$stream = $tcpClient.GetStream()

## if ssl, do ssl things
if ($useSSL)
{
	try
	{
		$sslStream = New-Object System.Net.Security.SslStream $stream,$false
		$sslStream.AuthenticateAsClient($ComputerName)
		$stream = $sslStream
	}
	catch [System.IO.Exception]
	{
		## try again with tls
		$tcpClient = New-Object System.Net.Sockets.TcpClient($ComputerName, $Port)
		$stream = $tcpClient.GetStream()

		$writer = New-Object System.IO.StreamWriter $stream

		$writer.WriteLine("EHLO")
		$writer.Flush()

		$writer.WriteLine("STARTTLS")
		$writer.Flush()
		$null = GetOutput

		$sslStream = New-Object System.Net.Security.SslStream $stream,$false
		$sslStream.AuthenticateAsClient($ComputerName)
		$stream = $sslStream
	}
}

$writer = New-Object System.IO.StreamWriter $stream

while ($true)
{
	## receive output so far
	$SCRIPT:output += GetOutput

	## if scripted mode, send commands, receive output, exit
	if ($scriptedMode)
	{
		foreach($line in $currentInput)
		{
			$writer.WriteLine($line)
			$writer.Flush()
			Start-Sleep -m $Delay
			$SCRIPT:output += GetOutput
		}
		break
	}

	## if interactive mode, writer buffered output and respond to input
	else
	{
		if ($output)
		{
			foreach($line in $output.Split("`n"))
			{
				Write-Host -Message $line
			}
			$SCRIPT:output = ""
		}

		# read user command, check for user prompte quit
		$command = Read-Host
		if ($command -eq ([char] 4)) { break }

        # 
		$writer.WriteLine($command)
		$writer.Flush()
	}
}
# close streams
$writer.Close()
$stream.Close()

# if scripted mode, return output
if ($scriptedMode)
{
	return $output
}
}

function GetOutput
{
	## create buffer to receive response
	$buffer = New-Object System.Byte[] 1024
	$encoding = New-Object System.Text.AsciiEncoding

	$outputBuffer = ""
	$foundMore = $false

	## read all data from stream, then write to output buffer
	do
	{
		## allow data to buffer
		Start-Sleep -m 1000

		## read available buffer
		$foundMore = $false
		$stream.ReadTimeout = 1000

		do
			{
				try
				{
					$read = $stream.Read($buffer, 0, 1024)

					if ($read -gt 0)
					{
						$foundMore = $true
						$outputBuffer += ($encoding.GetString($buffer, 0, $read))
					}
				}
				catch { $foundMore = $false; $read = 0 }
			}
			while ($read -gt 0)
	} while ($foundMore)

	$outputBuffer
}

. Main

