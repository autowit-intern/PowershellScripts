


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