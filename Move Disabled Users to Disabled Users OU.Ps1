# Re-hiring or re-enabling users

#move disabled users to Users OU
$user = Read-Host -Prompt 'Enter username'
$user_location = get-aduser $user #| Select-Object distinguishedname
$user_location = """$user_location"""
move-adobject -identity $user_location "OU=Users,OU=Corporate,DC=domain,DC=com"
Enable-ADAccount $user

#Check user´s location and info
Get-ADUser $user
net user $user /domain


# Offboarding Users 

#move users that requires disabling to the Disabled Users OU
$user = Read-Host -Prompt 'Enter username'
Disable-ADAccount $user 
$user_location = get-aduser $user | Select-Object distinguishedname -ExpandProperty distinguishedname -First 1
move-adobject -identity "$user_location" "OU=Disabled Users,DC=domain,DC=com"

#Remove all memberships
Get-ADUser "$user" -Properties MemberOf | Select -Expand MemberOf | %{Remove-ADGroupMember $_ -member "$user"}

#Check user´s location and info
Get-ADUser $user
net user $user /domain

#Set description to users
$user_m = Read-Host -Prompt "Enter username to set description"
$user_desc = Read-Host -Prompt "Enter description for user"
Set-ADUser $user_m -Description "$user_desc"

