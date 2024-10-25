
# check SQL server drives formatted methods

## configuration #############################
##############################################
$filename = Get-Date -format "M-d_hh-mm"
$results_path = "C:\users\"
$computer_name_like = ""
$ad_source = ""

$results_file = "$results_path\$filename.txt"
###############################################

$the_computers = get-adcomputer -filter {name -like $computer_name_like} -server $ad_source

foreach ($computer in $the_computers.dnshostname) {

    Add-Content -value "`nServer name: $computer" -path $results_file
    $one_session = new-pssession -ComputerName $computer

    $get_drives = invoke-command -Session $one_session -ScriptBlock {
        Get-PSDrive -PSProvider FileSystem
    }

    foreach($drive in $get_drives.root) {
        $fs_util = invoke-command -Session $one_session -ScriptBlock {
            fsutil fsinfo ntfsinfo $using:drive | select-string -Pattern "NTFS Volume Serial Number", "Bytes per Cluster", "Bytes per FileRecord Segment"
        }

        Add-Content -value "Drive: $drive" -path $results_file       

        foreach ($line in $fs_util) {
            Add-Content -value "`t$line" -path $results_file
        }
    }
}
