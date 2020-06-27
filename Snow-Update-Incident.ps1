﻿# This sript will update an existing incidents state
$SnowUsername = "admin"
$SnowPlainPassword = "Unacceptable123$"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SnowUsername, $SnowPlainPassword)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/xml')
$headers.Add('Content-Type','application/xml')

$Sys_Id = "01746dba2f6910105822d7492799b607"
$SnowBaseURL = "https://dev101455.service-now.com/"
$uri = $SnowBaseURL + "api/now/v1/table/incident/$sys_Id"

 # Specify HTTP method
 $method = "patch"

 # Changing the incident state
 $Body = @{ 
           incident_state="3"

      }

# convert to json format
$BodyJson = $Body | convertto-json


 # Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -body $BodyJson -ContentType "application/json"

 $response.ChildNodes.result