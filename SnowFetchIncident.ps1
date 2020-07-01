function SnowFetchIncident {
    # The goal for this script is to retrieve an incident ticket from servicenow instance 
    # Added a validation set that only accept 'INC' and 7 numbers after. 
    # It will keep asking until you input the proper format for Ticketnumbers i.e (INC0010002)
    do
    {
        try {
        [ValidatePattern('^INC\d{7}$')]$TicketNumber = Read-Host "Enter a Ticket Number (INCXXXXXXX)" 
        } catch {}
    } until ($?)
    
    # the URI of the base URL and api to connect to
    $uri = $Global:SnowBaseURL + "api/now/table/incident?number=$TicketNumber"
    
     # Specify HTTP method
     $method = "get"
    
    # Send HTTP request
     [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing
    
     # Displays the results 
     $response.ChildNodes.result
    
    
    }


