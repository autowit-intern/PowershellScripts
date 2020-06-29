function SnowUpdateIncident {
     
      

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

    function SnowIncidentCreation {
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
            # UPDATED to receive user input for the ticket number
            $TicketNumber = Read-Host -Prompt 'Input Incident Number'
            $SnowBaseURL = "https://dev101455.service-now.com/"
            $uri = $SnowBaseURL + "api/now/table/incident?number=$TicketNumber"
            
             # Specify HTTP method
             $method = "get"
            
            
             # Send HTTP request
             [xml]$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing
            
             $response.ChildNodes.result
            
            
            }


            Export-ModuleMember -Function 'SnowUpdateIncident' 'SnowIncidentCreation' 'SnowFetchIncident'