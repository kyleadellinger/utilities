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

# List types
# powershell arrays "@()"
# two ways:
# first:
$List = [System.Collections.Generic.List[string]]::New()

# second:
using namespace System.Collections.Generic
$List = [List[string]]::New()

# LINQ linq (Language Integrated Query)
# a dotnet component that allows for data querying and filtering.
# typically a lot faster than pwsh native cmdlets such as where-object, measure-object, select-object, etc.
#
# compare lists:
[Linq.Enumerable]::SequenceEqual($List1, $List2)
# # True / False
# note: contents of lists are compared, and the order of the contents matters.
#
# sort method:
$List1.Sort()
$List2.Sort()
[Linq.Enumerable]::SequenceEqual($List1, $List2)
#
# min, max, average, sum:
[Linq.Enumerable]::Min($List)
[Linq.Enumerable]::Max($List)
[Linq.Enumerable]::Average($List)
[Linq.Enumerable]::Sum($List)
[Linq.Enumerable]::Except($diffHashSet, $refHashSet)
#
# General "static extension method syntax":
# [Linq.Enumerable]::MethodName($collection, $delegate)
#
# Provides significant performance improvements over native pwsh loops, especially on large data sets.

# GetInterfaces
# q: how to find what classes implement a given interface?
# a: GetInterfaces method
[System.Collections.Generic.List[int]].GetInterfaces()
[System.Collections.Generic.Dictionary[int,string]].GetInterfaces()
[Array].GetInterfaces()
#
# IsAssignableFrom
# first, define type, then interface, then call IsAssignableFrom method:
$Type = [List[string]]
$Interface = [IEnumerable[string]]
$Interface.IsAssignableFrom($Type)
# # True / False
#
$Type = [Array]
$Interface = [IEnumerable[string]]
$Interface.IsAssignableFrom($Type)
# (False)
# 
