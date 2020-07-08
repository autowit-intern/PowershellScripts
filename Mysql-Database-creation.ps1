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

## Error handling
$ErrorActionPreference = "silentlycontinue"

#########  STEP 1 #######################



## Function to connect to mysql server   
function TestSQLConnection { 
                            $SQLConnection = Connect-MySqlServer -ComputerName localhost -Credential (Get-Credential) | Select-Object -Property state
                            }

testsqlconnection

## Tests connection to mysql server if server is not running an echo will be the output stating so                  

if ($SQLConnection.state -eq "open")
{
    $ReturnCode = 0
    Write-Host "Step 1 Complete. Target Server is up and running. Returncode: $ReturnCode"
}
else
{
     $ReturnCode = 2
    write-host "Target Server is Not Running. Returncode: $ReturnCode"
    exit
}
  

#############  STEP 2 ##############

## Retrieves a database from the mysql database if the name exists an echo message will return saying the name of the database already exists

$Name = Read-host "Enter database name"

    function Get-MySQL-Database { 
                                        
    
    
 if (Get-MySqlDatabase -name $Name) {
                                     $ReturnCode = 2
                                     Write-Host "Database with same name already exists. Returncode: $ReturnCode";
                                     exit
 }
 else 
 {
                                     $ReturnCode = 0
                                     Write-Host "Step 2 Complete. Database with name does not exist. Returncode: $ReturnCode";
 } } 

Get-MySQL-Database


################### STEP 3 ############################

## Creates a new database with specified "DBname" and "DBcharset"


$DBName = Read-Host "Enter New Database Name"
$DBCharSet = "ascii"

function NewSQLDB { 
                                       

                    Invoke-MySqlQuery -Connection $SQLConnection -query "CREATE SCHEMA $DBName DEFAULT CHARACTER SET $DBCharSet;"
                   
                    }

NewSQLDB

$NewDB = $DBName
if ($NewDB -eq $DBName)
{
    $ReturnCode = 0
    write-host "Step 3 Complete. Database Created successfully. Returncode: $ReturnCode"
}
else
{
   $ReturnCode = 2
   write-host "Failure; Error occured could not create database. Returncode: $ReturnCode"
   exit
}


####################### STEP 4 ########################

## Send email to the user with database details.
 
## Setting From and To variables
$From = read-host "Enter From Email"
$To = read-host "Enter To Email"

function Send-Confirmation-Email { 
                                        
$Subject = "Database Creation Details. $DBName"
$Body =  "New Database creation Details. Database name is $DBName"
$SMTPServer = "outlook.office365.com"
$SMTPPort = "587"
                                   

Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Credential (Get-Credential) -Port $SMTPPort -UseSsl 
}
if (Send-Confirmation-Email -eq $true)
{
    $returncode = 2
    write-host "Something went wrong. Email was not sent. Returncode: $ReturnCode"
    exit
}
else
{
    $ReturnCode = 1
    write-host "Step 4 Complete. Email has been sent successfully. Returncode: $ReturnCode"
}
