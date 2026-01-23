################################################################################
# IIS Log Rotate script
################################################################################

# compress-archive cmdlet uses an API that is restricted to 2GB file size
# so that won't work for our purpose
# need this:
Add-Type -AssemblyName System.IO.Compression.FileSystem

################################################################################
### CONFIGURATION
$ARCHIVE_LOG_NAME = get-date -format "MM-dd-yyyy"
$DAYS = -30
$LOG_PATH = "C:\users\kdellinger\kypo\loggers\w3svc1"
$ARCHIVE_LOG_PATH = "C:\temp"

##################################################################################

function createTempBackupDir {
    # check and create temporary backup directory
    [cmdletbinding()]

    param(
        [Parameter(Mandatory=$true)]
        [string] $tempdir
    )
    if (-not (test-path -path $tempdir)) {
        new-item -type directory -path $tempdir
    } else {
        throw "ERROR: Provided directory already exists."
    }
} # function

function getFilesToBeArchived {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $path,

        [Parameter(Mandatory=$true)]
        [int32] $age
    )
    if (-not ($age -lt 0)) {
        throw "ERROR: $age is not negative. We are looking only for negative integers."
    }

    $target_files_at_path = (get-childitem -path $path | where-object -FilterScript {$_.lastwritetime -le (get-date).adddays($age)}).FullName

    return $target_files_at_path
} # function

# move the files

function archiveTheDirectory {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $path,

        [Parameter(Mandatory=$true)]
        [string] $destination
    )

    [IO.Compression.ZipFile]::CreateFromDirectory($path, $destination)
    return
} # function

#########################################################################

createTempBackupDir -tempdir "$ARCHIVE_LOG_PATH\temp_backup_folder"

$target_files = getFilesToBeArchived -path $LOG_PATH -age $DAYS

if ($target_files) {

    $target_files | move-item -Destination "$ARCHIVE_LOG_PATH\temp_backup_folder"

    archiveTheDirectory -path "$ARCHIVE_LOG_PATH\temp_backup_folder" -destination "$ARCHIVE_LOG_PATH\$ARCHIVE_LOG_NAME.zip"
}

archiveTheDirectory -path "$ARCHIVE_LOG_PATH\temp_backup_folder" -destination "$ARCHIVE_LOG_PATH\$ARCHIVE_LOG_NAME.zip"
