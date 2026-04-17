
Write-Host "Am I Admin?: "

(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole.]::Administrator)
# naturally, the above example command, which is taken from microsoft's own website as an example, verbatim, doesn't work. 
# output error is: 
# InvalidOperation: C:\Users\kdellinger\utilities\PowerShell\AmIAdmin.ps1:4
#Line |
#   4 |  … Current())).IsInRole([Security.Principal.WindowsBuiltInRole.]::Admini …
#     |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     | Unable to find type [Security.Principal.WindowsBuiltInRole.].

