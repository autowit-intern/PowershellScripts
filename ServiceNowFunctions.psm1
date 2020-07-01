####### SERVICENOW FUNCITONS MODULE #########


######### GLOBAL VARIABLES ##########
#ServiceNow Username
$Global:SnowUsername = 'admin'

#ServiceNow Password
$Global:SnowPlainPassword = Get-Content 'C:\ServiceNowInstancePassword.txt' | ConvertTo-SecureString

# Converting SecureString to PlainText
$Global:SnowPlainPassword =  [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Global:SnowPlainPassword))

#Authentication information
$Global:base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Global:SnowUsername, $Global:SnowPlainPassword)))

#Setting the Headers
$Global:headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Global:headers.Add('Authorization',('Basic {0}' -f $Global:base64AuthInfo))
$Global:headers.Add('Accept','application/xml')
$Global:headers.Add('Content-Type','application/xml')

# My ServiceNow Instance base URL
$Global:SnowBaseURL = "https://dev101455.service-now.com/"
############### FUNCTIONS ################

#Fetching Incident record from servicenow instance function
 
 function SnowFetchIncident {
  # param statement
  [CmdletBinding()]
            param (
                [ValidatePattern('^INC\d{7}$')]
                [string]
                [int]
                $TicketNumber
            )
 # Input Validation 
 do
    {
        try {
        [ValidatePattern('^INC\d{7}$')]$TicketNumber = Read-Host "Enter a Ticket Number (INCXXXXXXX)" 
        } catch {}
    } until ($?)
    
    
    # URI of the instance you are accessing
    $uri = $Global:SnowBaseURL + "api/now/table/incident?number=$TicketNumber"
    
     # Specify HTTP method
     $method = "get"
    
    
     # Send HTTP request
     [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing
    
     $response.ChildNodes.result
    
    
    }
SnowFetchIncident
# Second function will update an existing incident records incident state and worknotes
function SnowUpdateIncident {
     
   
    param ()
        ([string][ValidateSet("New","InProgress","OnHold","Resolved","Closed","Canceled")]$IncidentState)
        ([ValidatePattern('^INC\d{7}$')]$TicketNumber = Read-Host "Enter a Ticket Number (INCXXXXXXX)")
        


# Converting Incident TicketNumber to sys_id
$Sys_Id = (SnowFetchIncident -Ticketnumber $TicketNumber).sys_id

$uri = $Global:SnowBaseURL + "api/now/v1/table/incident/$sys_Id"

 # Specify HTTP method
 $method = "patch"

# Specify request body

 switch ($IncidentState) {
                            "New" { $Body = `"incident_state`":`"1`" }
                            "InProgress" {$Body = `"incident_state`":`"2`"}
                            "OnHold" {$Body = `"incident_state`":`"3`"}
                            "Resolved" {$Body = `"incident_state`":`"4`"}
                            "Closed" {$Body = `"incident_state`":`"5`"}
                            "Canceled" {$Body = `"incident_state`":`"6`"}
                          }     

 
# Send HTTP request
 [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -body $Body 

 $response.ChildNodes.Result

SnowUpdateIncident
                                            }


            Export-ModuleMember -Function 'SnowUpdateIncident', 'SnowFetchIncident'