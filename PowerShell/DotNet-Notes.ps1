# determine dotnet CLR version that powershell is using
# Pwsh version 7.6.4 uses 10.0.10
[Environment]::Version.ToString()

# validate non-null strings
$emptyString = ""
$whiteSpace = " "
$nullVar = $null
$validString = 'this is real string'

[String]::IsNullOrEmpty($x)
[String]::IsNullOrWhiteSpace($x)

# note: pwsh core has these validators as attributes.
# eg:
# [ValidateNotNullOrEmpty()]$Str = ""       # works in powershell 5.1+
# [ValidateNotNullOrWhiteSpace()]$Str = " " # works in powershell 7+

# ip addresses
# [IPAddress]"10.0.0.1"
# $ip -eq ([IPAddress]$ip).IPAddressToString

# mac addresses
# [PhysicalAddress]::Parse("mac-string")
# note: dotnet version discrepances; use uppercase and '-' delimited format

# TCP Client
$site = 'google.com'
$port = 443
$timeoutMS = 100
$client = [System.Net.Sockets.TcpClient]::New()
$client.ConnectAsync($site,$port).Wait($timeoutMS)
# returns $true if success, else $false
$client.Dispose() # clean up resources

# generate passwords
[System.Web.Security.Membership]::GeneratePassword(20, 1)
# GeneratePassword(int length, int minimumNumberOfNonAlphanumericCharacters)

