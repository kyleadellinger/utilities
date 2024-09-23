param(
[string]$target
)

$result = invoke-command -computername $target -scriptblock {get-content -path $update_path}

if ($result) {
    write-host "output: $result"
} else {
    write-host "no result retrieved for $update_path"
    write-host "Checking if file exists"
    $exists = invoke-command -computername $target -scriptblock {test-path $update_path}
    write-host $exists
}
