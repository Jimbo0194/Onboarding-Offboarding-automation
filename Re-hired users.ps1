# Re-hiring or re-enabling users

#move disabled users to Users OU
$user = Read-Host -Prompt 'Enter username'
$user_expires = Read-Host -Prompt "Is the user temporal? (y/n)"
$user_location = get-aduser $user | Select-Object distinguishedname -ExpandProperty distinguishedname -First 1
move-adobject -identity "$user_location" "OU=Users,OU=CORP,DC=domain,DC=com"
Enable-ADAccount $user
# Select if the user expires or not
if ($user_expires -like 'y') {

    Get-ADUser $user | Set-ADAccountExpiration -TimeSpan 90.0:0
    Write-Host 'User will expire in 90 days'

}else {
    
    Write-Host 'User has been created as permanent'
    
}
# Copy all memberships from existing user to new user
$copy = Read-host "Enter user to copy from"
Get-ADUser -Identity $copy -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members $user

# Run a Get-ADUser and a net user to check the account and its setup
Get-ADUser $user -Properties office, manager, department, title
net user $user /domain
