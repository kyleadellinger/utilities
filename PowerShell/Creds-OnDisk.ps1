
<#

  .SYNOPSIS
    Helper function to obtain a password/secret and store it encrypted on disk.
    
    This will prompt for username and password by default.

    To store one or the other, provide the `PasswordOnly` switch at runtime.

    Will store credential in a file in $cwd/secret by default.

    To override filename/location, provide `FilePath` parameter.

#>

param(
  [CmdletBinding()]
  [Parameter(Mandatory=$false)]
  [switch] $PasswordOnly,

  [Parameter(Mandatory=$false)]
  [string] $FilePath,

  [Parameter(Mandatory=$false)]
  [switch] $Force
)

function Assert-File {
  <#

    .SYNOPSIS
      Helper function to determine if a file (or directory) exists (or doesn't exist).
            
      Even though only the 'FileName' param is mandaotory, all other proper parameters should be provided
      in order to effectively ensure the expected outcome.

    .PARAMETER FileName
      [Mandatory] The file or directory name to check.

    .PARAMETER NotExist
      [Optional] [Defaults False] Default behavior is to check if a file/directory exists.
      If this switch is provided, this checks to ensure the file (or directory) DOES NOT exist.

    .PARAMETER CheckDir
      [Optional] [Defaults False] Default behavior is to check if a file exists.
      If this switch is provided, this checks instead for a directory.

    .EXAMPLE
      Assert-File -FileName ExistentFile.txt                # returns $true
      Assert-File -Path ExistentPath -CheckDir              # returns $true
      Assert-File -Path NonExistentPath -CheckDir -NotExist # returns $true
      Assert-File -FileName NonExistentFile.txt             # returns $false
      Assert-File -FileName NonExistentFile.txt -NotExist   # returns $true

  #>
  param(
    [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
    [Alias('file','path')]
    [string] $FileName,

    [Parameter(Mandatory=$false)]
    [Alias('not')]
    [switch] $NotExist,

    [Parameter(Mandatory=$false)]
    [Alias('dir')]
    [switch] $CheckDir
    )

    process {
      if ($CheckDir)
      {
        $check_result = Test-Path -LiteralPath $FileName -PathType Container
      
      } else {
        $check_result = Test-Path -LiteralPath $FileName -PathType Leaf
      
      }

      if ($NotExist) 
      {
        if ($check_result) { return $false }
        else { return $true }
      } 
      
      else
      {
        if ($check_result) { return $true }
        else { return $false }
      }
    }
} # function

function Write-Secret {
  param(
    [Parameter(Mandatory=$false)]
    [Alias('pass')]
    [switch] $PasswordOnly,

    [Parameter(Mandatory=$false)]
    [Alias('path')]
    [string] $FilePath,

    [Parameter(Mandatory=$false)]
    [switch] $Force
  )

  if (-not($FilePath)) {
    $working_path = (Get-Location).path
    $FilePath = Join-Path -Path $working_path -ChildPath 'secret'
  }

  if (Assert-File -FileName $Filepath) {
    if (-not($Force)) {
      Write-Error -Message "`nWarning: secret file exists: $FilePath. Quitting" -ErrorAction Stop
    }
  }

  if ($PasswordOnly) {
    $secret_input = Read-Host -AsSecureString "Enter secret: "
  } else {
    $secret_input = Get-Credential
  }
  
  $secret_input | Export-CliXml -LiteralPath $FilePath -Force

} # function

Write-Secret -PasswordOnly:$PasswordOnly -FilePath $FilePath -Force:$Force

Write-Verbose "$FilePath written."

function Read-Secret {
  param(
    [Parameter(Mandatory=$true, Position=0)]
    [string] $FilePath
  )

  if (-not(Assert-File $FilePath)) {
    Write-Error -Message "`nWarning: could not find file: $FilePath" -ErrorAction Stop
  }

  $cred = Import-CliXml -LiteralPath $FilePath
  return $cred

}