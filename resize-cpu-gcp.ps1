# RESIZE CPU GOOGLE CLOUD PLATFORM

# STEPS/REQUIREMENTS
<# STEP 1  Login to Google cloud platform API
	Success : Continue to next step.
	Failure : Set “Unable to Log in to your google account please try again.”

   STEP 2 Check if target instance exist.
	Success : Continue to next step.
	Failure : Set “Target instance does not exist”

   STEP 3 Initiate vertical scaling the number of CPU’s requested.
	Success : Continue to next step.
	Failure : Set “unable to increase the requested amount of CPUs to the instance”

   STEP 4 Send mail to the Google account owner about the change.
	Success : Send mail, configuration successful with instance details
	Failure :  Send mail, Configuration failed kindly reach out to your administrators. 
#>

## ERRORHANDLING ###
$ErrorActionPreference = 'silentlycontinue'
## variables needed

$InstanceName = Read-host "Enter Instance Name" 


## step 1 ##
## variables needed ##
$ProjectName = read-host "enter projectname"
$Zone = read-host "enter the zone"
$Instance = read-host "enter the instance name"
# Login
function gcloud-Login {
                        gcloud compute  --project $ProjectName ssh --zone $Zone --ssh-key-expire-after=1m "$Instance" 
                        }

gcloud compute --project $ProjectName instances start --zone $Zone "$Instance"


# Verification of login

if (gcloud-login -eq success)
{
    echo "success" 
}
else
{
    echo "fail"
    exit
}




## step 2 ##

function InstanceCheck { Get-GceInstance -Project $ProjectName -Zone us-central1-a -Name $InstanceName 
                        }

if (InstanceCheck -eq $InstanceName)
{   
    $ReturnCode = 0
    echo "success. Instance Exists. Returncode: $ReturnCode "
}
else
{   
    $ReturnCode = 2
    echo "failure.Target Instance Does Not Exist. Returncode: $ReturnCode"
    exit
}

## step 3 ##

#Must Stop instance to edit machinetype 
gcloud compute --project $ProjectName instances stop --zone $Zone "$Instance"

#Change the machine type function
function ChangeMachineType { Param(
	                                [parameter(Mandatory)]
                                    [ValidateSet("n1-standard-2","n1-standard-4","n1-standard-8","n1-standard-16")]
	                                $MachineType 
                                    )
gcloud compute instances set-machine-type $InstanceName --zone $Zone --machine-type $MachineType

}
# Tells the user the valid options
Write-Host 'VALID OPTIONS ARE (n1-standard-2,n1-standard-4,n1-standard-8,n1-standard-16) '

ChangeMachineType

# Restart the instance after change has been made
gcloud compute --project $ProjectName instances start --zone $Zone "$Instance"

$NewMachineType = Get-GceInstance -Project $ProjectName -Zone us-central1-a -Name $InstanceName | Select-Object machinetype

if ($NewMachineType -eq $MachineType)
{
    $ReturnCode = 0
    Write-Host "Success. CPU upgraded. Returncode: $ReturnCode"
}
else
{
    $ReturnCode = 2
    Write-Host "failure. Could Not Upgrade CPU. Try Again. Returncode: $Returncode "
    exit
}

## Step 4 ##
# send mail confirmation.
$From = read-host "Enter From Email"
$To = read-host "Enter To Email"

function Send-Confirmation-Email { 
                                        
$Subject = "Instance Configuration Change"
$Body =  "A change on the instance named $InstanceName has occured successfully. CPU upgrade complete. New CPU is $NewMachineType"
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