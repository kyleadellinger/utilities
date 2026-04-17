## these are rought notes to:
## - generate a self-signed certificate
## - enable ps remoting
## - create relevant firewall rule (HTTPS-In)

## note: in testing this has worked with supplying IP address in place of DNS/computer hostname

$certificate = New-SelfSignedCertificate `
    -CertStoreLocation 'Cert:\LocalMachine\My' `
    -DnsName 'ipaddress'

Enable-PSRemoting -SkipNetworkProfileCheck -Force

New-Item -Path WSMan:\LocalHost\Listener `
    -Transport HTTPS `
    -Address * `
    -CertificateThumbprint $($certificate.thumbprint) `
    -Force

New-NetFirewallRule -DisplayName 'Windows Remote Management (HTTPS-In)' `
    -Name 'Windows Remote Management (HTTPS-In)' `
    -Profile Any `
    -LocalPort 5986 `
    -Protocol TCP

## connect example for notes. didn't seem to be required, at least from ansible connection
# Enter-PSSession -ComputerName '' `
#   -Credential (Get-Credential) `
#   -SessionOption (New-PSSessionOption -SkipCACheck -SnipCNCheck) `
#   -UseSsl

