$SnowUsername = "admin"
$SnowPlainPassword = "Unacceptable123$"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SnowUsername, $SnowPlainPassword)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/xml')
$headers.Add('Content-Type','application/xml')

$TicketNumber = "INC0010111"
$SnowBaseURL = "https://dev101455.service-now.com/"
$uri = $SnowBaseURL + "api/now/table/incident?number=$TicketNumber"

 # Specify HTTP method
 $method = "get"


 # Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing

 $response.ChildNodes.result