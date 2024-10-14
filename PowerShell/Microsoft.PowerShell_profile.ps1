############################################
## THE ORDER OF THESE SETTINGS IS SUPPOSED TO BE:
## ALIAS then FUNCTION then CMDLET
## AT LEAST SEE ABOUT FOLLOWING BEST PRACTICES
#############################################


############################################
## THIS SECTION RELIES UPON BITWARDEN CLI ##
## ALSO THERE IS NO SYNC BUILT IN (YET)   ##
############################################

####################################
## BW CONVENIENCE FUNCTIONS
## USED IN OTHER SCRIPTS
####################################

function conditional-unlock {
    if ((bw status | convertfrom-json).status -eq "locked") {
      $credential = bw unlock
      $token = $credential[4]
      $bw = $token.trimstart('> $env:BW_SESSION=').trim('"')
      $env:BW_SESSION=$bw
      bw sync
    }
}
##############################################################
function clean-pycache {
    [cmdletbinding()]
    param(
    [parameter(mandatory=$true)]
    [string] $path
    )
    get-childitem -path $path -filter *__pycache__* -recurse | remove-item -force -recurse
}
###############################################################
### python script/app wrapper using venv basic example invoke:
###############################################################
function pyfire {
	$python_int = "C:\users\kdellinger\.virtualenvs\pyurl3-meRjFCHJ\Scripts\python.exe"
	$script = "C:\users\kdellinger\kypy\pyurl3\pyfire.py"
	& $python_int $script $args
}
################################################################

function set-envapp {
    if ((bw status | convertfrom-json).status -eq "locked") {
        $credential = bw unlock
        $token = $credential[4]
        $bw = $token.trimstart('> $env:BW_SESSION=').trim('"')
        $env:BW_SESSION=$bw
    }
    $env:MEND_EMAIL = ((bw get item mend_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item app_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item app_userkey | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
    $env:ORG_TOKEN = ((bw get item app_orgtoken | convertfrom-json).login.password) # not needed for scan, but convenience
}
function set-envappeu {
    if ((bw status | convertfrom-json).status -eq "locked") {
        $credential = bw unlock
        $token = $credential[4]
        $bw = $token.trimstart('> $env:BW_SESSION=').trim('"')
        $env:BW_SESSION=$bw
    }
    $env:MEND_EMAIL = ((bw get item mend_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item app_eu_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item app_eu_userkey | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
    $env:ORG_TOKEN = ((bw get item app_eu_orgtoken | convertfrom-json).login.password) # not needed for scan, but convenience
}
function set-envsaas {
    if ((bw status | convertfrom-json).status -eq "locked") {
        $credential = bw unlock
        $token = $credential[4]
        $bw = $token.trimstart('> $env:BW_SESSION=').trim('"')
        $env:BW_SESSION=$bw
    }
    $env:MEND_EMAIL = ((bw get item mend_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_userkey | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
    $env:ORG_TOKEN = ((bw get item saas_orgtoken | convertfrom-json).login.password) # not needed for scan, but convenience
}

function set-envsaaseu {
    if ((bw status | convertfrom-json).status -eq "locked") {
        $credential = bw unlock
        $token = $credential[4]
        $bw = $token.trimstart('> $env:BW_SESSION=').trim('"')
        $env:BW_SESSION=$bw
    }
    $env:MEND_EMAIL = ((bw get item mend_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_eu_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_eu_userkey | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
    $env:ORG_TOKEN = ((bw get item "448d569c-54c8-4dad-b771-b02201157ef8" | convertfrom-json).login.password) # not needed for scan, but convenience
}

function set-envmendsaas {
    if ((bw status | convertfrom-json).status -eq "locked") {
        $credential = bw unlock
        $token = $credential[4]
        $bw = $token.trimstart('> $env:BW_SESSION=').trim('"')
        $env:BW_SESSION=$bw
    }
    $env:MEND_EMAIL = ((bw get item mend_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_mend_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_mend_userkey | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
    $env:ORG_TOKEN = ((bw get item saas_mend_orgtoken | convertfrom-json).login.password) # not needed for scan, but convenience
}

function set-envmendsaaseu {
    conditional-unlock
    $env:MEND_EMAIL = ((bw get item mend_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_eu_mend_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_eu_mend_userkey | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
    $env:ORG_TOKEN = ((bw get item "f7e06d30-d981-422d-b166-b08100e2dab5" | convertfrom-json).login.password) # not needed for scan, but convenience
}

function set-servapp {
    conditional-unlock
    $env:MEND_EMAIL = ((bw get item service_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item app_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item app_s_key | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
}

function set-servappeu {
    conditional-unlock
    $env:MEND_EMAIL = ((bw get item service_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item app_eu_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item app_eu_s_key | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
}

function set-servsaas {
    conditional-unlock
    $env:MEND_EMAIL = ((bw get item service_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_s_key | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
}

function set-servsaaseu {
    conditional-unlock
    $env:MEND_EMAIL = ((bw get item service_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_eu_mend_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_eu_s_key | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
}

function set-servmendsaas {
    conditional-unlock
    $env:MEND_EMAIL = ((bw get item service_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_mend_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_mend_s_key | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
}

function set-servmendsaaseu {
    conditional-unlock
    $env:MEND_EMAIL = ((bw get item service_email | convertfrom-json).login.password)
    $env:MEND_URL = ((bw get item saas_eu_mend_url | convertfrom-json).login.password)
    $env:MEND_USER_KEY = ((bw get item saas_eu_mend_s_key | convertfrom-json).login.password)
    $env:MEND_LOG_LEVEL="DEBUG"
}

function clear-env {
    if ($env:MEND_USER_KEY -ne $null)
    {
        $env:MEND_USER_KEY=$null
    }
    if ($env:MEND_URL -ne $null)
    {
        $env:MEND_URL=$null
    }
    if ($env:MEND_EMAIL -ne $null)
    {
        $env:MEND_EMAIL=$null
    }
    if ($env:MEND_LOG_LEVEL -ne $null)
    {
        $env:MEND_LOG_LEVEL=$null
    }
    if ($env:ORG_TOKEN -ne $null)
    {
        $env:ORG_TOKEN=$null
    }
}

function kill-bw {
    if ($env:BW_SESSION -ne $null)
    {
        $env:BW_SESSION=$null
        bw lock
    }
}

function downCLI {
    $ProgressPreference = 'SilentlyContinue'
    invoke-webrequest -uri "https://downloads.mend.io/cli/windows_amd64/mend.exe" -OutFile "mend.exe"
}
####################################
## END BLOCK FOR SET ENV FOR CLI
####################################
# docker token
function docker-token {
    conditional-unlock
    $env:DOCK = ((bw get item kydelldock | convertfrom-json).login.password)
}
######################################
## UA SCAN FUNCTIONS
## SYNTAX: COMMAND - > PATH - > PRODUCT - > PROJECT 
######################################

### APP ENVIRONMENT
function scan-app {
    [cmdletbinding(defaultparametersetname='path')] #info in parantheses doesn't seem to do anything one way or another
    param(
      [Parameter()]
      [string] $path = (get-location).path,
      #[Parameter(mandatory, parametersetname='product', position=1)]
      [string] $product,
      #[Parameter(parametersetname='project', position=2)]
      [string] $project
    )
    conditional-unlock # relies on function directly above
    $UAlocation = "C:\UAgent\wss-unified-agent.jar"
    $UAconfig = "C:\UAgent\wss-unified-agent.config"
    $env:WS_USERKEY = ((bw get item app_userkey | convertfrom-json).login.password)
    $env:WS_APIKEY = ((bw get item app_orgtoken | convertfrom-json).login.password)
    $env:WS_WSS_URL = "https://app.whitesourcesoftware.com/agent"
    java -jar $UAlocation -c $UAconfig -d $path -product $product -project $project
    $env:WS_USERKEY = $null
    $env:WS_APIKEY = $null
    $env:WS_WSS_URL = $null
}

### APP-EU

function scan-appEU {
    [cmdletbinding(defaultparametersetname='path')] #info in parantheses doesn't seem to do anything one way or another
    param(
      [Parameter()]
      [string] $path = (get-location).path,
      #[Parameter(mandatory, parametersetname='product', position=1)]
      [string] $product,
      #[Parameter(parametersetname='project', position=2)]
      [string] $project
    )
    conditional-unlock # relies on function directly above
    $UAlocation = "C:\UAgent\wss-unified-agent.jar"
    $UAconfig = "C:\UAgent\wss-unified-agent.config"
    $env:WS_USERKEY = ((bw get item app_eu_userkey | convertfrom-json).login.password)
    $env:WS_APIKEY = ((bw get item app_eu_orgtoken | convertfrom-json).login.password)
    $env:WS_WSS_URL = "https://app-eu.whitesourcesoftware.com/agent"
    java -jar $UAlocation -c $UAconfig -d $path -product $product -project $project
    $env:WS_USERKEY = $null
    $env:WS_APIKEY = $null
    $env:WS_WSS_URL = $null
}

### SAAS 

function scan-saas {
    [cmdletbinding(defaultparametersetname='path')] #info in parantheses doesn't seem to do anything one way or another
    param(
      [Parameter()]
      [string] $path = (get-location).path,
      #[Parameter(mandatory, parametersetname='product', position=1)]
      [string] $product,
      #[Parameter(parametersetname='project', position=2)]
      [string] $project
    )
    conditional-unlock # relies on function directly above
    $UAlocation = "C:\UAgent\wss-unified-agent.jar"
    $UAconfig = "C:\UAgent\wss-unified-agent.config"
    $env:WS_USERKEY = ((bw get item saas_userkey | convertfrom-json).login.password)
    $env:WS_APIKEY = ((bw get item saas_orgtoken | convertfrom-json).login.password)
    $env:WS_WSS_URL = "https://saas.whitesourcesoftware.com/agent"
    java -jar $UAlocation -c $UAconfig -d $path -product $product -project $project
    $env:WS_USERKEY = $null
    $env:WS_APIKEY = $null
    $env:WS_WSS_URL = $null
}

### SAAS-EU

function scan-saasEU {
    [cmdletbinding(defaultparametersetname='path')] #info in parantheses doesn't seem to do anything one way or another
    param(
      [Parameter()]
      [string] $path = (get-location).path,
      #[Parameter(mandatory, parametersetname='product', position=1)]
      [string] $product,
      #[Parameter(parametersetname='project', position=2)]
      [string] $project
    )
    conditional-unlock # relies on function directly above
    $UAlocation = "C:\UAgent\wss-unified-agent.jar"
    $UAconfig = "C:\UAgent\wss-unified-agent.config"
    $env:WS_USERKEY = ((bw get item saas_eu_userkey | convertfrom-json).login.password)
    $env:WS_APIKEY = ((bw get item saas_eu_orgtoken | convertfrom-json).login.password)
    $env:WS_WSS_URL = "https://saas-eu.whitesourcesoftware.com/agent"
    java -jar $UAlocation -c $UAconfig -d $path -product $product -project $project
    $env:WS_USERKEY = $null
    $env:WS_APIKEY = $null
    $env:WS_WSS_URL = $null
}

function scan-saasmend {
    [cmdletbinding(defaultparametersetname='path')] #info in parantheses doesn't seem to do anything one way or another
    param(
      [Parameter()]
      [string] $path = (get-location).path,
      #[Parameter(mandatory, parametersetname='product', position=1)]
      [string] $product,
      #[Parameter(parametersetname='project', position=2)]
      [string] $project
    )
    conditional-unlock # relies on function directly above
    $UAlocation = "C:\UAgent\wss-unified-agent.jar"
    $UAconfig = "C:\UAgent\wss-unified-agent.config"
    $env:WS_USERKEY = ((bw get item saas_mend_userkey | convertfrom-json).login.password)
    $env:WS_APIKEY = ((bw get item saas_mend_token | convertfrom-json).login.password)
    $env:WS_WSS_URL = "https://saas.mend.io/agent"
    java -jar $UAlocation -c $UAconfig -d $path -product $product -project $project
    $env:WS_USERKEY = $null
    $env:WS_APIKEY = $null
    $env:WS_WSS_URL = $null
}

function scan-saasmendeu {
    [cmdletbinding(defaultparametersetname='path')] #info in parantheses doesn't seem to do anything one way or another
    param(
      [Parameter()]
      [string] $path = (get-location).path,
      #[Parameter(mandatory, parametersetname='product', position=1)]
      [string] $product,
      #[Parameter(parametersetname='project', position=2)]
      [string] $project
    )
    conditional-unlock # relies on function directly above
    $UAlocation = "C:\UAgent\wss-unified-agent.jar"
    $UAconfig = "C:\UAgent\wss-unified-agent.config"
    $env:WS_USERKEY = ((bw get item saas_eu_mend_userkey | convertfrom-json).login.password)
    $env:WS_APIKEY = ((bw get item saas_eu_mend_token | convertfrom-json).login.password)
    $env:WS_WSS_URL = "https://saas-eu.mend.io/agent"
    java -jar $UAlocation -c $UAconfig -d $path -product $product -project $project
    $env:WS_USERKEY = $null
    $env:WS_APIKEY = $null
    $env:WS_WSS_URL = $null
}


####################################
## python tomfoolery
####################################

function login {
    python "C:\_PYTH\login.py"
}

function vuln {
    python "C:\_PYTH\vulnsearch.py"
}
