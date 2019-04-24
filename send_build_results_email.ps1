function generate_heat_alert {
  param(
    [Parameter(Position=0) ]
    [string] $remotecomputer
)


$automated_heal_alert_email = 'heat@carnival.com'
$human_alert_email = 'skouzmine@carnival.com' 
$recipients = [String]::Join(',', @(
  # suppress sending to  unless approved by 
  # $automated_heal_alert_email ,
   'ericksond@carnival.com', 
   'HMudireddy@carnival.com', 
   'SKouzmine@carnival.com'
   )
)

$subject_template = 'Drive Low Free Space on {0}' 
$subject = ($subject_template -f $remotecomputer) 
$caller_build_url =  $env:CALLER_BUILD_URL
write-output ( 'Formatting "{0}"' -f  $caller_build_url ) 
# Dollar ???
# write-output "$caller_build_url_formatted = $caller_build_url  -replace '/(Build)$?', '/console'"

$caller_build_url_formatted = $caller_build_url  -replace '/(Build)$?', '/console'
$caller_build_url_formatted = $caller_build_url  -replace '/(Build)\$?', '/console'

$caller_build_url_formatted = $caller_build_url_formatted  -replace '.carnival.com', ''
$caller_build_url_formatted  = ( "{0}console" -f $caller_build_url_formatted )
$sender_address = 'serviceaccount@carnival.com'
$smtp_server = 'smtphost.carnival.com'
# 
$results = @"
Failed Build: $caller_build_url_formatted
"@


$subject = "Monitoring_Alarm" 


write-output @"
Invoking:
-----
Send-MailMessage -To ${recipients} -Subject "${subject}" -Body "${results}" -SmtpServer ${smtp_server} -From ${sender_address}  
-----
"@
$recipients -split ',' | foreach-object  { $recipient = $_ ;
write-output ( 'Notified ${0} about {1}' -f $recipient, $results) 
Send-MailMessage -To $recipient -Subject "${subject}" -Body "${results}" -SmtpServer $smtp_server -From $sender_address 
# -erroraction 'SilentlyContinue'
}


}
write-output 'sending the mail'
generate_heat_alert  'node1'
