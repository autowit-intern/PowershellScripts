# how to pass variables to the -argumentlist

$test1 = "testing"


Invoke-Command -ComputerName $TargetServer -Credential $creds -ScriptBlock { param ($test2="onetwothree")

write-host $test1
Write-Host $test2

} -ArgumentList $test1