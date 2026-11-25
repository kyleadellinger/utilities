
function InfoPrinter {
    <#
    .SYNOPSIS
        Helper/convenience function to write to various output streams.
    #>

    param(
        [PSCustomObject] $InputObject,
        [switch] $debug,
        [switch] $verbose,
        [switch] $err,
        [switch] $errstop
    )

    switch ($true) {
        $debug { Write-Debug $InputObject }
        $verbose { Write-Verbose $InputObject }
        $err { Write-Error -Message $InputObject }
        $errstop { Write-Error -Message $InputObject -ErrorAction 'stop' }
        default { Write-Information $InputObject }
    }
# note: this originally include 'write-output' as an option, however,
# the problem with that is if/when this is used in a function,
# anything written to the output stream is also returned from the function.
# so if the 'output' stream is used, it can cause unexpected results.

}
