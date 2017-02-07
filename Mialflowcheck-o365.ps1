 #Powershell version Check
If ($PSVersionTable.PSVersion.major -lt 3){
Write-output "RequirePowershell3-Minimum"
break;
}
$status = $null

　
$date = Get-Date
$title = "Automated Email: $date"

$username = $args[0]
$password = $args[1]

$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$(convertto-securestring $Password -asplaintext -force)

　
$data = @"
{
  "Message": {
    "Subject": "$title",
    "Body": {
      "ContentType": "Text",
      "Content": "Monitoring"
    },
    "ToRecipients": [
      {
        "EmailAddress": {
          "Address": "service.hpoffice365@empired.com"
        }
      }
    ]
  },
  "SaveToSentItems": "false"
}
"@

　
　
#Send Email
try{
    $send = Invoke-WebRequest -Uri https://outlook.office365.com/api/v1.0/me/sendmail -Credential $cred -ContentType application/json -Method Post -Body $data -ErrorAction Stop
}
catch{
    $status += "SendEmailError,"
}
sleep 5

#read Inbox
try{
    $mail = Invoke-WebRequest -ContentType application/json -Uri 'https://outlook.office365.com/api/v1.0/me/folders/inbox/messages/?$select=Subject' -Credential $cred -ErrorAction Stop
}
catch {
    $status += "readInboxError,"
}

#convert data to a useable format
$emaildata = $($mail.Content|ConvertFrom-Json).value

　
#Write-host "Email Count $($emaildata.count)" -ForegroundColor Yellow

foreach ($email in $emaildata){

# Find the email matching the title sent above
    If ($email.Subject -eq $title) {
      $foundmail = $true
      $uri = "https://outlook.office365.com/api/v1.0/me/messages/" + $email.Id
      Try{
            $delete = Invoke-WebRequest -Uri $uri -Credential $cred -ContentType application/json -Method Delete -ErrorAction stop
        }
        catch{
            $status += "DeleteEmailError,"
        }
      #Write-host "$title : Deleted" -ForegroundColor Yellow
    }
    
}
If ($foundmail){
    $status += "MailflowSuccess"
    }
Else{
    $status += "SentEmailnotfound"
}

Write-host $status
 
