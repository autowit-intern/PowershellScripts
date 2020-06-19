# how to Pass Credentials silently to the -credential parameter in invoke-command

# First you ,ust save youre password to your filesystem

read-host -assecurestring | convertfrom-securestring | out-file C:\securestring.txt 

# Second you can now remote into a server without being prompted for credentials

$targetserver = "192.168.0.1"
$user = user1
$pass = Get-Content 'C:\mysecurestring.txt' | ConvertTo-SecureString
$creds = new-object -typename System.Management.Automation.PSCredential
         -argumentlist $user, $pass
# This command below remotes you into the targetserver without a prompt for credentials

Invoke-Command -ComputerName $TargetServer -Credential $creds -ScriptBlock {

# you can now run commands you would like here
}

