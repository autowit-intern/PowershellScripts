function SnowFetchIncident {
    # The goal for this script is to retrieve an incident ticket from servicenow instance 
    
    # Set your username and password for servicenow (must be admin)
    $SnowUsername = 'admin'
    $SnowPlainPassword = 'Unacceptable123$'
    
    # Converts your user and pass to base64 plaintext
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SnowUsername, $SnowPlainPassword)))
    
    # Set proper headers
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
    $headers.Add('Accept','application/xml')
    $headers.Add('Content-Type','application/xml')
    
    
    # Specify the ticketnumber you wish to retrieve and set the base URL of your instance
    # Added a validation set that only accept 'INC' and 7 numbers after. 
    # It will keep asking until you input the proper format for Ticketnumbers i.e (INC0010002)


    do
    {
        try {
        [ValidatePattern('^INC\d{7}$')]$TicketNumber = Read-Host "Enter a Ticket Number (INCXXXXXXX)" 
        } catch {}
    } until ($?)
    $SnowBaseURL = "https://dev101455.service-now.com/"
    $uri = $SnowBaseURL + "api/now/table/incident?number=$TicketNumber"
    
     # Specify HTTP method
     $method = "get"
    
    
     # Send HTTP request
     [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing
    
     $response.ChildNodes.result
    
    
    }


