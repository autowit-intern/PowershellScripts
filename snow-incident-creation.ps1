function Snow-Incident-Creation {
# This script creates a incident record in ServiceNow
$SnowUsername = "admin"
$SnowPlainPassword = "Unacceptable123$"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SnowUsername, $SnowPlainPassword)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/xml')
$headers.Add('Content-Type','application/xml')


$SnowBaseURL = "https://dev101455.service-now.com/"
$uri = $SnowBaseURL + "api/now/v1/table/incident"

 # Specify HTTP method
 $method = "post"

# Specify request body
$body = "{`"caller_id`":`"admin`",`"short_description`":`"This is a test`"}"

 # Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing -Body $body

 $response.ChildNodes.result
}

Snow-Incident-Creation