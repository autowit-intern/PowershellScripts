Describe  'STEP 1  Login to Google cloud platform API
           STEP 2 Check if target instance exist.
           STEP 3 Initiate vertical scaling the number of CPUs requested.
           STEP 4 Send mail to the Google account owner about the change.' {

    Context 'Checks to see if Gcloud user is authenticated and active
             Checks to see if target vm instance exists
             This step Initiates the CPU upgrade
             This Step sends an email to the account owner' {
        It 'Step1. gcloud account is active' {
            $CheckCreds = gcloud auth list --format=list
            $Login = $CheckCreds | Select-String -SimpleMatch 'active'  | Should be $true
        }

        
        It 'Step 2. VM instance exists' {
            
            $GetInstanceInfo = Get-GceInstance -Project $ProjectName -Zone $Zone -Name $InstanceName | Select-Object -Property Name
            $GetInstanceInfo | Should be $true
        }
       
        
        It 'Step 3. CPU upgraded successfully' {
            $ErrorActionPreference = 'silentlycontinue'
            #stop instance to edit machinetype
            gcloud compute --project $ProjectName instances stop --zone $Zone "$InstanceName"
            #editing machinetype
            gcloud compute instances set-machine-type $InstanceName --zone $Zone --machine-type $MachineType
            #Restart the instance after change has been made
            gcloud compute --project $ProjectName instances start --zone $Zone "$InstanceName"
            $NewMachineType = Get-GceInstance -Project $ProjectName -Zone us-central1-a -Name $InstanceName | Select-Object machinetype
            $NewMachineType | Should be $true
        }
        
        
        It 'Step 4. Email confirmation success' {
           $User = "troy.goodwin@students.williscollege.com"
           $File = "C:\users\troy\outlookpass.txt"
           $MyCredential=New-Object -TypeName System.Management.Automation.PSCredential `
           -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)
           #variables for email
           $Subject = "Instance Configuration Change"
           $Body =  "A change on the instance named $InstanceName has occured successfully. CPU upgrade complete. New CPU is $NewMachineType"
           $SMTPServer = "outlook.office365.com"
           $SMTPPort = "587"
           $ConfirmationEmail = Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Credential $MyCredential -Port $SMTPPort -UseSsl 
           $ConfirmationEmail | should be $null

        }
      
     }
  }
        
    

