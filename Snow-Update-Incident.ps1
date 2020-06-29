function Snow-Update-Incident {
     
      

# This script will update an existing incidents state
$SnowUsername = "admin"
$SnowPlainPassword = "Unacceptable123$"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SnowUsername, $SnowPlainPassword)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')
$headers.Add('Content-Type','application/json')

# Updated to receive user input for the sys_id

$Sys_Id = Read-Host -Prompt 'Enter Your Sys_Id'
$SnowBaseURL = "https://dev101455.service-now.com/"
$uri = $SnowBaseURL + "api/now/v1/table/incident/$sys_Id"

 # Specify HTTP method
 $method = "patch"

# Specify request body
$body = "{`"short_description`":`"hello hello hello`",`"incident_state`":`"1`"}"

# convert to json format
$BodyJson = $Body | convertto-json


 # Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -body $BodyJson -ContentType "application/json"

 $response.ChildNodes.result

}

Snow-Update-Incident