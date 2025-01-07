#Requires -RunAsAdministrator

#########
## NOTES
#########
## known event IDs are 404, 407, 408
# Message should start with something like:
# The DNS server could not bind a Transmission Control Protocol ... (404)
# The DNS server could not bind a User Datagram Protocol ... (407)
# The DNS server could not open socket for address $ip ... (408)

## The Things To Do:
# 0. task scheduled to run upon boot up -> script invocation
# 1. Script checks for the relevant errors in event log
# 2a. if no errors, schedule reboot -> loop
# 2b. if errors, send email notification -> fun / convenience

######
######

function klog {
    param(
        [parameter(mandatory=$false)]
        [string] $info
    )
    if ($info) {
        Add-Content -Value "$(get-date) - Logger | $info" -path ""
        return
    } else {
        Add-Content -Value "$(get-date) - Logger | No info provided"
        Return
    }
} # function

function scheduleReboot {
    # schedules a reboot when invoked
    # this script should be invoked upon start up, then this will schedule the reboot
    # .01 of a day is approx 24 min
    # .004 of a day is approx 5 min
    $sched_time = (get-date).AddDays(.01)
    klog -info "Scheduling reboot - Schedule time $sched_time"
    $trigger = New-ScheduledTaskTrigger -Once -At $sched_time
    $executioner = "powershell.exe"
    # path to powershell exe
    $argumentation = '-command ' +
       "& {Restart-Computer -Force}"
       # '"and any args to it, though I think there will probably not be"' +
       # ' but if so they look like this' +
       # '-ZipPrefix "logarchive-"'
    
    $scheduledTaskAction = @{
        Execute = $executioner
        Argument = $argumentation
    }
    $Action = New-ScheduledTaskAction @scheduledTaskAction
    # combine trigger and action to create task
    $scheduledtask = @{
        TaskName = "Troubleshooting Windows Server DNS Errors"
        Trigger = $trigger
        Action = $Action
        User = 'NT AUTHORITY\SYSTEM'
    }
    Register-ScheduledTask @scheduledtask -Force #note Force
}

function check-DNSerror {
    #if no events found, throws a 'non-terminating' error, so script still completes
    # provider name is "Microsoft-Windows-DNS-Server-Service"
    # logname is "DNS Server"
    [cmdletbinding()]
    
    $relevant_events = get-winevent -filterhashtable @{
        ProviderName="Microsoft-Windows-DNS-Server-Service";
        Level=2;
    } #-MaxEvents 20

    if ($null -eq $relevant_events) {
        $relevant_events = "Script ran: No events"
    } else {
        if (Test-Path -Path "") {
            $known_events = Get-Content -Path ""
        }
        
        foreach ($answer in $relevant_events) {
            klog -info "Event: $($answer.id)  Record ID: $($answer.recordId) Time: $($answer.timecreated)"

            if ($answer.recordId -notin $known_events) {
                klog -info "Event $($answer.recordId) not in known events"
                Add-Content -Path "" -Value $answer.recordId
                set-variable -name "sendmailnotification" -value $true -scope script
            }   
        }
    }
    $relevant_events
} # function

function checkForNonTerminatingErrorAndClearIt {
    if ($Error) {
        klog -info "checkForNonTerminatingError - $($Error[0])"
        $Error.Clear()
    }
} # function

function send-mail {
    [cmdletbinding(DefaultParameterSetName='content')]
    param(
        [Parameter(Mandatory = $true)]
        [string] $content,

        [Parameter(Mandatory = $false)]
        [string] $dest = ""
    )

    $mail_parameters = @{
        smtpserver = ""
        subject = $(get-date -Format "HH:mm_MM-dd-yyyy")
        from = ""
        to = $dest
        body = $content
    }

    Send-MailMessage @mail_parameters
} # function

####################
### main process ###
####################

$sendmailnotification = $false
$events = check-DNSerror
checkForNonTerminatingErrorAndClearIt

if ($sendmailnotification) {
    # log
    klog -info "Sending mail notification $(get-date)"
    # mail
    $message_body = Get-Content -Path "" -Tail 10
    send-mail -content "$message_body" # quotes are needed for some [powershell] reason

} else {
    klog -info "Script Ran - notify mail not triggered"
    # schedule task to do it again
    klog -info "Scheduling reboot"
    scheduleReboot
}

