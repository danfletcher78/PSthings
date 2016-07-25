$body = $null
$head = $null
$footer = $null


$head = @"
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
"@

$footer = @'
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>'
'@
#$body = '<div class="container">'

##Data

$diskData = Import-Csv C:\users\dan.fletcher\Desktop\DiskReport_23062016.csv
# Format Critical Category data
$htmldata_c = $diskdata|Where-Object {$_.Category -eq 'Critical'}|convertto-html -Fragment
$htmldata_c = $htmldata_c -replace '<th>', '<th class =danger>'
$htmldata_c = $htmldata_c -replace '<table>','<table class="table table-hover">'
# Format Warning Category data
$htmldata_w = $diskdata|Where-Object {$_.Category -eq 'Warning'}|convertto-html -Fragment
$htmldata_w = $htmldata_w -replace '<th>', '<th class =warning>'
$htmldata_w = $htmldata_w -replace '<table>','<table class="table table-hover">'
# Format Error Category data
$htmldata_e = $diskdata|Where-Object {$_.Category -eq 'Error'}|convertto-html -Fragment
$htmldata_e = $htmldata_e -replace '<th>', '<th class =info>'
$htmldata_e = $htmldata_e -replace '<table>','<table class="table table-hover">'
# Format Nomal Category data
$htmldata_n = $diskdata|Where-Object {$_.Category -eq 'Normal'}|convertto-html -Fragment
$htmldata_n = $htmldata_n -replace '<th>', '<th class =success>'
$htmldata_n = $htmldata_n -replace '<table>','<table class="table table-hover">'

#build body content
$body = '<div class="container">'
$body += '<div class="container container-fluid">'
$body += '<h2>Critical Disks</h2>'
$body += $htmldata_c
$body += '</br>'
$body += '<h2>Warning Disks</h2>'
$body += $htmldata_w
$body += '</br>'
$body += '<h2>Error / No Data</h2>'
$body += $htmldata_e
$body += '</br>'
$body += '<h2>Normal Disks</h2>'
$body += $htmldata_n
$body += "</div>"
$body += "</div>"
$document = ConvertTo-Html -Head $head -Body $body -PostContent $footer
$document|Out-File C:\users\dan.fletcher\Desktop\output.html


