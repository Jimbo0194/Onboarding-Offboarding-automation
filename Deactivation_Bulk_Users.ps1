# Import AD Module
Import-Module ActiveDirectory
 
# Import the data from CSV file and assign it to variable
$Import_csv = Import-Csv -Path "enter path location"
 
# Specify target OU where the users will be moved to
$TargetOU = "OU=Disabled Users,DC=domain,DC=com"
 
$Import_csv | ForEach-Object {
 
    # Retrieve DN of User
    $UserDN = (Get-ADUser -Identity $_.SamAccountName).distinguishedName
 
    Write-Host "Moving Accounts....."
 
    # Move user to target OU. Remove the -WhatIf parameter after you tested.
    Move-ADObject -Identity $UserDN -TargetPath $TargetOU -WhatIf

    # Hide from GAL
     Get-ADUser -Filter "DisplayName -eq '$UserDN*'" -Properties * | Select-Object Displayname,msExchHideFromAddressLists
} 
Write-Host "Completed move"

$ID = Read-Host -Prompt 'Enter employee ID'
get-aduser -filter {employeeid -eq $ID}
