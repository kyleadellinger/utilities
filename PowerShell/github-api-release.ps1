
##################################################################################
#### CONFIG:
$TARGET_DIRECTORY = "\\wp.clarkinc.io\wss\se\Install Files & ISOs\PowerShell7"
#$TARGET_DIRECTORY = "C:\Users\kdellinger\kypo\downloaded-powershell-scratch-dir"

<#
.SYNOPSIS
A couple of functions that, collectively:
1. Query the GitHub API for the latest PowerShell 7 win-x-64.msi release
2. Check the target directory to see if latest version is downloaded
3. If not downloaded, download it into target directory and validate hash.

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
This is pretty hard-coded to check and do really only one thing.
Any future expansion will most likely just expand the functions to make them more 

#>
function getLatestPowerShellCoreReleaseInfo {
    # query github api to return the latest powershell core (winx64)
    # returns hashtable with keys "latest_filename", "latest_download_link", "SHA"
    [outputtype([hashtable])]
    
    $GITHUB_getTheLatestReleaseEP = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"

    $powershell_releases = invoke-restmethod -uri $GITHUB_getTheLatestReleaseEP -Headers @{ "Accept" = "application/json"}
    
    $latest_win64_assets = $powershell_releases.assets | where-object -property name -like "*win-x64.msi"
    $hashes_assets = $powershell_releases.assets | Where-Object -property name -like "hashes.sha256"

    $latest_win64_downloadurl = $latest_win64_assets.browser_download_url

    $latest_win64_name = $latest_win64_assets.name

    $hashes_download_link = $hashes_assets.browser_download_url


    return @{
        "Latest_filename" = $latest_win64_name
        "Latest_download_link" = $latest_win64_downloadurl
        "SHAdownload" = $hashes_download_link
    }

} # function

function checkDirLatestPowerShell {
    [cmdletbinding()]
    [outputtype([bool])]

    param(
        [Parameter(Mandatory= $true)]
        [string] $path,
        [parameter(mandatory = $true)]
        [string] $name
    )

    $dir_contents = get-childitem -path $path

    if ($name -in $dir_contents.name) {
        $new_download_needed = $false
    } elseif ($name -in $dir_contents.basename) {
        $new_download_needed = $false
    } else {
        $new_download_needed = $true
    }
    return $new_download_needed
} # function

function downloadLatestPowerShell_win64_msi {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [string] $download_url,

        [Parameter(Mandatory=$true, Position=2)]
        [string] $save_location
    )
    # massively increases download speed by not providing constant update
    $ProgressPreference = 'SilentlyContinue'
    
    $headers = @{
        "Accept" = "application/json"
    }

    if (test-path $save_location) {
        write-host "$save_location already exists. Please specify new location."
        exit
    } else {
        Invoke-WebRequest -method Get -uri $download_url -headers $headers -outfile $save_location
    }
}

function validateTheHash {
    # currently this will only validate the expected downloaded version,
    # which would be whatever the latest powershell core win x64 msi download is
    # this will also overrwite any file with similar name!!! (in the interest of time)
    [cmdletbinding()]
    [outputtype([bool])]

    param(
        [Parameter(Mandatory=$true)]
        [hashtable] $info,
        [Parameter(Mandatory=$true)]
        [string] $save_location
    )
    $latest_name = $info.latest_filename
    $sha_download_url = $info.shadownload

    # HASH operations
    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -uri $sha_download_url -outfile "$save_location\sha256s"
    $relevant_hash_start = (select-string -path "$save_location\sha256s" -pattern $latest_name).line
    $relevant_hash = $relevant_hash_start.split(" ")[0]

    $check_file = get-childitem -path $save_location | Where-Object -Property name -eq $latest_name
    $hash_check_file = (get-filehash -Algorithm sha256 -path "$save_location\$check_file").hash

    if ($relevant_hash -eq $hash_check_file) {
        write-host "Hash validated!"
        write-host "Removing hash file. . . "
        remove-item -path "$save_location\sha256s"
    } else {
        write-host "HASH NOT VALIDATED! THAT IS BAD NEWS."
        return $false
    }
    
} # function


$latest_version_dict = getLatestPowerShellCoreReleaseInfo

$outfile_name = $latest_version_dict.latest_filename
$download_url = $latest_version_dict.latest_download_link

$is_new_version_needed = checkDirLatestPowerShell -path $TARGET_DIRECTORY -name $outfile_name

if ($is_new_version_needed) {
    write-host "Most recent version not present in specified directory."
    write-host "Downloading latest version: $outfile_name to $TARGET_DIRECTORY\$outfile_name"
    downloadLatestPowerShell_win64_msi -download_url $download_url -save_location $TARGET_DIRECTORY\$outfile_name
} else {
    write-host "Most recent version $outfile_name found in specified directory: $TARGET_DIRECTORY"
    write-host "Skipping download. Nothing to do!"
    exit
}

if (-not (test-path -Path $TARGET_DIRECTORY\$outfile_name)) {
    write-host "Attempting to check hash of downloaded file, but file wasn't found. Please check specified directory."
    Exit
} else {
    $hash_check = validateTheHash -info $latest_version_dict -save_location $TARGET_DIRECTORY
    $hash_check
}
