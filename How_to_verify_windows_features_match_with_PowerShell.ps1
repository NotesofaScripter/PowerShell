$OriginalServer = "Server_Name"
 
#Gets the windows features installed on the original server and stores it as $ComputerA_WindowsFeatures
$ComputerA_WindowsFeatures = (Get-WindowsFeature -ComputerName $OriginalServer | Where {$_.Installed -eq "True"}).Name
 
#Gets the windows features installed on the system you are currently logon that needs to match the original server and stores it as $ComputerB_WindowsFeatures
$ComputerB_WindowsFeatures = (Get-WindowsFeature | Where {$_.Installed -eq "True"}).Name
 
#Compares the 2 variables and stores the differences as $difference
$difference = (Compare-Object -ReferenceObject $ComputerA_WindowsFeatures -DifferenceObject $ComputerB_WindowsFeatures).inputobject
 
#Installed all of the features that are stored in the $difference variable. Make sure to point to the SXS folder as it will need it for windows 2012
foreach ($feature in $difference){Install-WindowsFeature $feature -Source C:\Sources\sxs}
 
#After the features are all installed, just for error checking I get the installed features of the local system again.
$ComputerB_WindowsFeatures = (Get-WindowsFeature | Where {$_.Installed -eq "True"}).Name
 
#Compares the new installed features with the original server features
$Newdifference = (Compare-Object -ReferenceObject $ComputerA_WindowsFeatures -DifferenceObject $ComputerB_WindowsFeatures).inputobject
 
#checks to see if the $NewDifference variable has data, if empty lets you know the features match
if ($Newdifference -eq $null){Write-host "Installed features match on both servers" -ForegroundColor Green}
 
#If there is differences run the script again.
Else{Write-host "Run the script again."}