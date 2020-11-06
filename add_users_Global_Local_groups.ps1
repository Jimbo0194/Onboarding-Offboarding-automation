Import-Module ActiveDirectory

#Adds users to global groups
$user = Read-Host -Prompt "Enter Username"
$groupname = Read-Host -Prompt "Enter Global Group to add"
Add-ADGroupMember -Identity $groupname -Member $user

#Adds Users to Local Domain Groups
$user = Read-Host -Prompt "Enter Username"
$groupname = Read-Host -Prompt "Enter Local Group to add"
Add-LocalGroupMember -Group $groupname -Member $user