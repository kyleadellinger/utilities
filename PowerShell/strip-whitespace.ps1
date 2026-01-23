$filename = Read-Host -Prompt "Input source file: "

$output_path = "C:\UAgent\whitestripped\powershellout"

(get-content -raw -path $filename) -replace "\s","" | set-content -NoNewline -path "$output_path\$filename"

write-host "Stripped; saved at $output_path\$filename"

$sha = Get-FileHash -Algorithm sha1 -Path "$output_path\$filename" 

write-host "$sha"
