##########################################################################
# Intention is to check the latest version of PowerShell 7 / Core,
# and download a new x64 MSI, if available.
# Also, validate sha256
###########################################################################

$ProgressPreference = 'SilentlyContinue'

$GITHUB_getTheLatestReleaseEP = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
$save_location = "C:\users\kdellinger\kypo\downloaded-powershell-scratch-dir"

$headers = @{
    "Accept" = "application/json"
}

$powershell_releases = invoke-restmethod -uri $GITHUB_getTheLatestReleaseEP -Headers $headers

$assets_from_releases = $powershell_releases.assets
#hashes may also be able to be extracted from body attribute in this response
#$hashes_download = $assets_from_releases | Where-Object
#$assets_from_releases

$win64_downloadurl = $assets_from_releases | Where-Object -Property browser_download_url -like "*win-x64.msi"

$latest_win64_download_url = $win64_downloadurl.browser_download_url
$outfile_name = $latest_win64_download_url.split("/")[-1]

Invoke-WebRequest -Uri $latest_win64_download_url -OutFile $save_location\$outfile_name
## this works.

## still need to:
# check directory to see what version is there
# compare that againt API to add logic to determine if want to download
# validate sha
