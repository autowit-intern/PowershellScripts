<# 
   The goal of this script is to (a)test the bandwidth average,(b) bandwidth usage, 
   (c)latencyto a public server, (d)capture hostname,ipaddress, mac address of a remote server,and
   (e)log it all. There is a 5 second delay between each task.
#> 

#### requirements #####

<# You will need to have speedtester installed
   to do so Install-Module -Name SpeedTester
   Import-Module -Name SpeedTester
#>
# (e) To log everything into a report style text
   Start-Transcript -Path C:\users\troy\documents\PCinfo.txt

# (a)To run the speedtester

Start-SpeedTest

start-sleep -Seconds 5

# (b)To find bandwidth usage 

get-netadapterstatistics

Start-Sleep -Seconds 5

# (c)To see the latency to a public server

Test-Connection google.com | format-table

Start-Sleep -Seconds 5

<# (d)To capture hostname, ip, and mac

In order to get the required information
you must first be remoted into a target server
below i will demonstrate that along with retrieving
the desired info

#>

$TargetServer = "<ipaddress>"

Enable-PSRemoting -Force

$creds = Get-Credential

Invoke-Command -ComputerName $TargetServer -Credential $creds -ScriptBlock {

hostname

start-sleep -Seconds 2

ipconfig /all

}


Stop-Transcript