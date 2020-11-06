# move disabled users to Users OU
$user = Read-Host -Prompt 'Enter username'
$user_location = get-aduser $user #| Select-Object distinguishedname
$user_location = """$user_location"""
move-adobject -identity $user_location "OU=Users,OU=Corporate,DC=domain,DC=com"
#Check user´s location and info
Get-ADUser $user
net user $user /domain

#move users that requires disabling to the Disabled Users OU
$user = Read-Host -Prompt 'Enter username'
Disable-ADAccount $user 
$user_location = get-aduser $user | Select-Object distinguishedname -ExpandProperty distinguishedname -First 1
move-adobject -identity "$user_location" "OU=Disabled Users,DC=domain,DC=com"
#Check user´s location and info
Get-ADUser $user
net user $user /domain
