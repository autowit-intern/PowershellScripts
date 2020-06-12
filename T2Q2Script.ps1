# Goal is to get all services that are stopped with names starting with a,s,d,f in descending order

Get-Service -name a*,s*,d*,f* | Where-Object {$_.status -eq "stopped"} | Select-Object -property name,displayname,status | Sort-Object -Descending