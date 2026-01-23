# throwaway function for script validation

function kVerification {
    param(
        [parameter(mandatory=$false)]
        [string] $info
    )
    if ($info) {
        Add-Content -Value "$(get-date) - Tasks Completed | $info" -path "c:\users\kdellinger\desktop\kverifyLog"
        return
    } else {
        Add-Content -Value "$(get-date) - Tasks Completed | No info provided"
        Return
    }
} # function
