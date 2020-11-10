#Create new user 
$name_new_user = Read-Host -Prompt 'Enter the full name of new user'
$Firstname = Read-Host -Prompt 'Enter user´s first name'
$surname = Read-Host -Prompt 'Enter user´s surname'
$new_user_logon = Read-Host -Prompt 'Enter user´s logon (SamAccountName)'
$main_email_new_user = Read-Host -Prompt 'Enter user´s main email'
$user_manager = Read-Host -Prompt 'Enter the manager´s name of the user (add " " at the beggining and end)'
$user_job_title = Read-Host -Prompt 'Enter the user´s job title'
$user_company = Read-Host -Prompt 'Enter User´s Company:'

$user_department= Read-Host -Prompt 'Enter user´s department'

New-ADUser -Name $name_new_user -GivenName $Firstname -company $user_company -Surname $surname -SamAccountName $new_user_logon -UserPrincipalName $main_email_new_user -Path "OU=Users,OU=CORP,DC=Centric,DC=US" -AccountPassword(Read-Host -AsSecureString "Type Password for User") -ChangePasswordAtLogon $true -Enabled $true -Manager $user_manager -Email $main_email_new_user -Department $user_department -Title $user_job_title
$user_expires = Read-Host -Prompt 'Is the user temporal? (y/n)'

# Select if the user expires or not
if ($user_expires -eq 'y') {

    Get-ADUser $new_user_logon | Set-ADAccountExpiration -TimeSpan 90.0:0
    Write-Host 'User will expire in 90 days'

}else {
    
    Write-Host 'User has been created as permanent'
    
}

# Copy all memberships from existing user to new user

    $copy = Read-host "Enter user to copy from"
    $Sam  = Read-host " Enter user to copy to"
    Get-ADUser -Identity $copy -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members $Sam



# Run a Get-ADUser and a net user to check the account and its setup
Get-ADUser $new_user_logon
net user $new_user_logon /domain

    
#Name – Defines the Full Name

#Given Name – Defines the First Name

#Surname – Defines the Surname

#SamAccountName – Defines the User Name

#UserPrincipalName – Defines the UPN for the user account

#Path – Defines the OU path. The default location is “CN=Users,DC=domain,DC=com”

#AccountPassword – This will allow user to input password for the user and system will convert it to the relevant data type

#Enable – defines if the user account status is enabled or disabled. 
