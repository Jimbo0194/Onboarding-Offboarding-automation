#Create new user 
$name_new_user = Read-Host -Prompt 'Enter the full name of new user'
$Firstname = Read-Host -Prompt 'Enter user´s first name'
$surname = Read-Host -Prompt 'Enter user´s surname'
$new_user_logon = Read-Host -Prompt 'Enter user´s logon (SamAccountName)'
$main_email_new_user = Read-Host -Prompt 'Enter user´s main email'
$user_manager = Read-Host -Prompt 'Enter the manager of the user (logon)'
$user_job_title = Read-Host -Prompt 'Enter the user´s job title'
$user_department= Read-Host -Prompt 'Enter user´s department'
$user_office = Read-Host -Prompt 'Enter User´s Office Location'
$user_company = Read-Host -Prompt 'Enter User´s Company'


#Creating new user based on given info
New-ADUser -Name $name_new_user  -Displayname $name_new_user -office "$user_office" -GivenName $Firstname -company $user_company -Surname $surname -SamAccountName $new_user_logon -UserPrincipalName $main_email_new_user -Path "OU=Users,OU=CORP,DC=Centric,DC=US" -AccountPassword(Read-Host -AsSecureString "Type Password for User") -ChangePasswordAtLogon $true -Enabled $true -Manager $user_manager -Email $main_email_new_user -Department $user_department -Title $user_job_title

# Gathering the main email and adding it as the main Proxy Address attribute in AD
$address = "SMTP:"+"$main_email_new_user"
$address= $address.Replace("""","")
Set-ADUser $new_user_logon -add @{ProxyAddresses= $address}

# Select if the user expires or not
$user_expires = Read-Host -Prompt 'Is the user temporal? (y/n)'
if ($user_expires -eq 'y') {

    Get-ADUser $new_user_logon | Set-ADAccountExpiration -TimeSpan 90.0:0
    Write-Host 'User will expire in 90 days'

}else {
        
    Write-Host 'User has been created as permanent'
        
    }

# Copy all memberships from existing user to new user
$copy = Read-host "Enter user to copy from"
Write-Host "Adding $new_user_logon to security groups from $copy"
Get-ADUser -Identity $copy -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members $new_user_logon

# Run a Get-ADUser and a net user to check the account and its setup
Get-ADUser $user -Properties office, manager, department, title, ProxyAddresses | select ProxyAddresses
net user $user /domain
