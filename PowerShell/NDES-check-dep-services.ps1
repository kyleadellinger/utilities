
# there are a few services that could impact NDES availability;
# known names of services are:
# 'w3svc' (world wide web publishing service (or something))
# 'was' (windows activation service)
# 'iisadmin' (iis admin service, which could indeed potentially not be running even though iis and the site(s) in question ARE running, which doesn't really make a whole lot of sense)
#
# basic function to check and start services:

# but first, a goofy utility type of function
function isit-service {
    param(
        [string] $name,
        [switch] $wild
    )
    $exists = get-service -name $svc_name
    if (($wild) -and ($null -eq $exists)) {
        $exists = get-service -name "*${svc_name}*"
        if ($exists) { 
            return $true }
        else {
            $return $false }
    else if ($null -eq $svc_name) {
        return $false }
    else {
        return $true }
}
} # function


function Run-CheckNDESServices {
    [cmdletbinding()]
    param(
        [string[]] $name,
        [switch] $checkmode
    )
    $known_svcs = @('w3svc', 'was', 'iisadmin')

    if ($null -eq $name) {
        $check_services = $known_svcs
    } else {
        $check_services = $null
        foreach ($n in $name) {
            if (isit-service -name $n -wild) { 
                $check_services += $n
                continue 
            }
        }
    if ($null -eq $check_services) { 
        "Service `'${name}`' not found"
        return
    }
    foreach ($service in $check_services) {
        $state = get-service -name $service
        if ($($state.status -ne 'Running')) {
            Write-Verbose -Message "Starting service $($state.Name) - $($state.DisplayName)"
            Start-Service $state
        } else {
            Write-Verbose -Message "Service already running: $($state.Name) - $($state.DisplayName)"
            continue
            }
        }
    }
}
