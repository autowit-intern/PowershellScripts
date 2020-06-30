function SnowUpdateIncident {
     
   
    param ()
        ([string][ValidateSet("New","InProgress","OnHold","Resolved","Closed","Canceled")]$IncidentState)
        ([ValidatePattern('^INC\d{7}$')]$TicketNumber = Read-Host "Enter a Ticket Number (INCXXXXXXX)")
        

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

$Sys_Id = (SnowUpdateIncident -Ticketnumber $TicketNumber).sys_id
$SnowBaseURL = "https://dev101455.service-now.com/"
$uri = $SnowBaseURL + "api/now/v1/table/incident/$sys_Id"

 # Specify HTTP method
 $method = "patch"

# Specify request body

                                                switch ($IncidentState) {
                                                    "New" { $Body1 = `"incident_state`":`"1`" }
                                                    "InProgress" {$Body1 = `"incident_state`":`"2`"}
                                                    "OnHold" {$Body1 = `"incident_state`":`"3`"}
                                                    "Resolved" {$Body1 = `"incident_state`":`"4`"}
                                                    "Closed" {$Body1 = `"incident_state`":`"5`"}
                                                    "Canceled" {$Body1 = `"incident_state`":`"6`"}
                                                }     
$Body2 = $ShortDescription

$Body = $Body1 + $Body2
 
# Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -body $Body 

 $response.ChildNodes.Result


                                            }
                                                                                


SnowUpdateIncident