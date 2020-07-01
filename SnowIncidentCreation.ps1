function SnowIncidentCreation {
# This script creates a incident record in ServiceNow with the caller id set to admin and a short description 
# The URI of the serviceNow instance and the api connection info
$uri = $Global:SnowBaseURL + "api/now/v1/table/incident"

 # Specify HTTP method
 $method = "post"

# Specify request body
$body = "{`"caller_id`":`"admin`",`"short_description`":`"This is a test`"}"

 # Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing -Body $body

 # Displays the results 
 $response.ChildNodes.result
}

