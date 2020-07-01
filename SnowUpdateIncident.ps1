function SnowUpdateIncident {
 # This function will update an incident records incident state and worknotes    
 # input validation   
    param ()
        ([string][ValidateSet("New","InProgress","OnHold","Resolved","Closed","Canceled")]$IncidentState)
        ([ValidatePattern('^INC\d{7}$')]$TicketNumber = Read-Host "Enter a Ticket Number (INCXXXXXXX)")
        
# Converts the ticketnumber into sys_id 
$Sys_Id = (SnowFetchIncident -Ticketnumber $TicketNumber).sys_id

# The URI is needed to connect to serivenow api
$uri = $Global:SnowBaseURL + "api/now/v1/table/incident/$sys_Id"

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

 
# Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -body $Body 

 # Displays the results 
 $response.ChildNodes.Result


                                            }
                                                                                


