Describe  'This script will have four steps that will create a new database on a MYSQL server' {

          
            


context                      'checks to see if target server is running,
                   runs a check against database name user enter to see if it exists,
                   if it doesnt exist it will be created on the target server,
                   after a successful creation an email will be sent to the account owner' {

                it 'Step 1 Completed server is up and running' {
                    $SQLConnect = Connect-MySqlServer -ComputerName $Target -Credential $MYSQLCreds | Should be $true

                }

                it 'Verified that server is up and running' {
                    $SQLConnect = Connect-MySqlServer -ComputerName $Target -Credential $MYSQLCreds | Should not be $false

                }

                it 'Step 2 verify if database exists' {
                    
                    Get-MySqlDatabase -name $DBName | should be $null
                }

                it 'Verified the database doesnt exist' {
                    Get-MySQLdatabase -name $DBname | should not be $true
                }

                it 'Step 3 Creates new database with name provided in step 2' {
                    $DBCharSet = "ascii"
                    $SQLConnection = Connect-MySqlServer -ComputerName $Target -Credential $MYSQLCreds 
                    Invoke-MySqlQuery -Connection $SQLConnection -query "CREATE SCHEMA $DBName DEFAULT CHARACTER SET $DBCharSet;" | should be $null
                }

                it 'Verified that database was created' {
                   Get-MySqlDatabase -name $DBName | should not be $false
                }

                It 'Step 4. Will send an email if step 3 succeeds otherwise shows error' {
           
                    Send-Email | should be $null
                }   
        
                It 'Verified the Email was sent'  {
                    function Send-Email {
                    $User = "troy.goodwin@students.williscollege.com"
                    $File = "C:\users\troy\outlookpass.txt"
                    $MyCredential=New-Object -TypeName System.Management.Automation.PSCredential `
                    -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)
                    #variables for email
                    $Subject = "Database Creation Details. $DBName"
                    $Body =  "New Database creation Details. Database name is $DBName"
                    $SMTPServer = "outlook.office365.com"
                    $SMTPPort = "587"
                    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Credential $MyCredential -Port $SMTPPort -UseSsl 
                    }
                    Send-Email | should not be $true
                }

                    
        }
  }
                