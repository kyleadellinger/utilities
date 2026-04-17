#Requires -RunAsAdministrator

# allow incoming ping reply
$pingparams = @{
     DisplayName = "ICMP Allow Incoming v4 Echo Request"
     Direction = "Inbound"
     Protocol = "ICMPv4"
     Action = "Allow"
}
New-NetFirewallRule @pingparams

