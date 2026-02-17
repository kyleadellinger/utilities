
# example, notes, etc.

param(
        [CmdletBinding()]
        [Parameter(Mandatory=$false, Position=0)]
        [string] $message,

        [Parameter(Mandatory=$false, Position=1)]
        [string] $FilePath,

        [Parameter(Mandatory=$false)]
        [switch] $ResetLog
        )

<#
NOTE:
the 'write-verbose' directives inside the function DO appear to repect the -verbose param,
even when provided at the script scope.

- also note that 'cmdletbinding' is not present within the function itself:

- also note splatting params
#>

function klog {
        param(
        [Parameter(Mandatory=$false, Position=0)]
        [string] $info,

        [Parameter(Mandatory=$false, Position=1)]
        [string] $LogFile,

        [Parameter(Mandatory=$false)]
        [Alias('reset')]
        [switch] $ResetLog
        )

        if (-not($LogFile)) {
                $LogFile = 'C:\tmp\klog.log'
        }

        if ($ResetLog) {
                Remove-Item -LiteralPath $LogFile -Force
        }

        $logline = "$(Get-Date -Format 'HH:mm MM-dd-yyyy') - Info:"

        if (-not (Test-Path -LiteralPath $LogFile)) {
                [void](New-Item -Path $LogFile -ItemType File -Force)
                Write-Verbose -Message "$logline Created $LogFile"
        }

        if ($ResetLog) {
                Add-Content -Value "$logline | Log Reset" -LiteralPath $LogFile
        }

        if ($info) {
                Add-Content -Value "$logline | $info" -LiteralPath $LogFile
        } else {
                Add-Content -Value "$logline | No info provided" -LiteralPath $LogFile
        }

        Write-Verbose -Message "$logline | $info"
}

$params = @{
        info = $message
        LogFile = $FilePath
        ResetLog = $ResetLog
}

klog @params
