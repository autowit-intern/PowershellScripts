###### MYSQL DATABASE CREATION ######



## PREREQUISITES ##

### To download the mysql module uncomment all commands below
#Invoke-WebRequest  -Uri https://github.com/adbertram/MySQL/archive/master.zip -OutFile  'C:\MySQL.zip'

### create a variable storing the location you will unzip the files
#$modulesFolder =  'C:\Program Files\WindowsPowerShell\Modules'

### unzips mysql.zip to destination
#Expand-Archive -Path  C:\MySql.zip -DestinationPath $modulesFolder

### Renames the path to mysql instead of mysql-master
#Rename-Item -Path  "$modulesFolder\MySql-master" -NewName MySQL 




## REQUIREMENTS ##
<# STEP 1 Check if the “DbServer” is up and running.
   STEP 2 Check the Database with name provided in the input should not exist already.
   STEP 3 Create the database with specified “DbName” and “DbCharSet”.
   STEP 4 Send notification to the user.
#>
## Variables that need user input
$Target = Read-Host "Enter Target Computer"
if (-not($Target)) {
    $Target = "localhost"
}
$DBName = Read-host "Enter database name"
if (-not($DBName)) {
    $DBName = "potato"
}
$From = read-host "Enter From email Address"
if (-not($From)) {
    $From = "troy.goodwin@students.williscollege.com"
}
$To = read-host "Enter To Email Address"
if (-not($To)) {
    $To = "troy.goodwin@autowit.co"
}
## Error handling
$ErrorActionPreference = "silentlycontinue"

#########  STEP 1 #######################
# Passing email credentials silently
#(Get-Credential).Password | ConvertFrom-SecureString | Out-File "C:\users\troy\MYSQLPass.txt"                                      
#$pass = Get-Content "C:\users\troy\MYSQLPass.txt" | ConvertTo-SecureString
$User = "root"
$File = "C:\users\troy\MYSQLPass.txt"
$MYSQLCreds=New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)


$SQLConnect = Connect-MySqlServer -ComputerName $Target -Credential $MYSQLCreds | Select-Object -Property state 

## Tests connection to mysql server if server is not running an echo will be the output stating so                  

if ($SQLConnect.state -eq "open")
{
    $ReturnCode = 0
    Write-Host "Step 1 Complete. Target Server is up and running. Returncode: $ReturnCode" -ForegroundColor Green
}
else
{
     $ReturnCode = 2
    write-host "Target Server is Not Running. Returncode: $ReturnCode" -ForegroundColor Red
    exit
}
  

#############  STEP 2 ##############

## Retrieves a database from the mysql database if the name exists an echo message will return saying the name of the database already exists
$NameTest =  Get-MySqlDatabase


if ($NameTest.database -contains $DBName) {
    $ReturnCode = 0
    Write-Host "Error! Database with same name already Exists. Try Again. Returncode: $ReturnCode" -ForegroundColor Red
    exit    
 }
 else 
 {
    $ReturnCode = 0
    Write-Host "Step 2 Complete. Database with name does not exist. Returncode: $ReturnCode" -ForegroundColor Green
}
  

################### STEP 3 ############################

## Creates a new database with specified "DBname" and "DBcharset"
$DBCharSet = "ascii"
$SQLConnection = Connect-MySqlServer -ComputerName $Target -Credential $MYSQLCreds 
Invoke-MySqlQuery -Connection $SQLConnection -query "CREATE SCHEMA $DBName DEFAULT CHARACTER SET $DBCharSet;"
                   
$NewDB = $DBName
if ($NewDB -eq $DBName)
{
    $ReturnCode = 0
    write-host "Step 3 Complete. Database Created successfully. Returncode: $ReturnCode" -ForegroundColor Green
}
else
{
   $ReturnCode = 2
   write-host "Failure; Error occured could not create database. Returncode: $ReturnCode" -ForegroundColor Red
   exit 
}


####################### STEP 4 ########################

## Send email to the user with database details.
# Passing email credentials silently
#(Get-Credential).Password | ConvertFrom-SecureString | Out-File "C:\users\troy\outlookpass.txt"                                      
#$pass = Get-Content "C:\users\troy\outlookpass.txt" | ConvertTo-SecureString
function Send-Email { 

$User = "troy.goodwin@students.williscollege.com"
$File = "C:\users\troy\outlookpass.txt"
$EmailCreds=New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString) 


$Subject = "Database Creation Details. $DBName"
$Body =  "New Database creation Details. Database name is $DBName"
$SMTPServer = "outlook.office365.com"
$SMTPPort = "587"
                                   
Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Credential $EmailCreds -Port $SMTPPort -UseSsl 

}


if ($NewDB -eq $DBName)
{
    $returncode = 1
    write-host "Step 4 Complete. Email with details of change being sent now Returncode: $ReturnCode" -ForegroundColor Green
    Send-Email
}
else
{
    $ReturnCode = 2
    write-host "Something went wrong. Email not sent. Returncode: $ReturnCode" -ForegroundColor Red
    exit
}