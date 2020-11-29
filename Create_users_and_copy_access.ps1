#Create new user 
$name_new_user = Read-Host -Prompt 'Enter the full name of new user'
$Firstname = Read-Host -Prompt 'Enter user´s first name'
$surname = Read-Host -Prompt 'Enter user´s surname'
$new_user_logon = Read-Host -Prompt 'Enter user´s logon (SamAccountName)'
$domains_list = '@CentricBrands.com', '@JoesJeans.com', '@RobertGraham.US', '@BuffaloJeans.com','@Hudsonjeans.com', '@bcbg.com', '@Centric.US'
$menu = $true

# Menu display to select email domain
while($menu -ne $false) {
    Write-Host 'Domain List - Please select one based on number:'

    Write-Host '1 - @CentricBrands.com'
    Write-Host '2 - @JoesJeans.com'
    Write-Host '3 - @RobertGraham.US'
    Write-Host '4 - @BuffaloJeans.com'
    Write-Host '5 - @Hudsonjeans.com'
    Write-Host '6 - @bcbg.com'
    Write-Host '7 - @Centric.US'
    
    $choice = Read-Host 
    if ($choice -eq 0) {
        $menu = $false
        Write-Host 'Valid Option - Adding' + $domains_list[0] + 'to ' + $name_new_user
        $main_email_new_user = $new_user_logon+$domains_list[0]
    }elseif ($choice -eq 1) {
        $menu = $false
        Write-Host 'Valid Option - Adding' + $domains_list[1] + 'to ' + $name_new_user
        $main_email_new_user = $new_user_logon+$domains_list[1]
    }elseif ($choice -eq 2) {
        $menu = $false
        Write-Host 'Valid Option - Adding' + $domains_list[2] + 'to ' + $name_new_user
        $main_email_new_user = $new_user_logon+$domains_list[2]
    }elseif ($choice -eq 3) {
        $menu = $false
        Write-Host 'Valid Option - Adding' + $domains_list[3] + 'to ' + $name_new_user
        $main_email_new_user = $new_user_logon+$domains_list[3]
    }elseif ($choice -eq 4) {
        $menu = $false
        Write-Host 'Valid Option - Adding' + $domains_list[4] + 'to ' + $name_new_user
        $main_email_new_user = $new_user_logon+$domains_list[4]
    }elseif ($choice -eq 5) {
        $menu = $false
        Write-Host 'Valid Option - Adding' + $domains_list[5] + 'to ' + $name_new_user
        $main_email_new_user = $new_user_logon+$domains_list[5]
    }elseif ($choice -eq 6) {
        $menu = $false
        Write-Host 'Valid Option - Adding' + $domains_list[6] + 'to ' + $name_new_user
        $main_email_new_user = $new_user_logon+$domains_list[6]
    }
}

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
$user_expires = Read-Host -Prompt 'Is the user temporal? (Y/N)'
if ($user_expires -like 'y') {

    Get-ADUser $new_user_logon | Set-ADAccountExpiration -TimeSpan 90.0:0
    Write-Host 'User will expire in 90 days'

}elseif ($user_expires -like 'n') {
        
    Write-Host 'User has been created as permanent'
        
    }

# Ask if an existing user can be used to mirror accesses to the new user
$ask_copy = Read-host -Prompt 'Will access be mirrored from an existing user? (Y/N)'

if ($ask_copy -like 'y') {
    # Copy all memberships from existing user to new user
    $copy = Read-host "Enter user to copy from"
    Write-Host "Adding $new_user_logon to security groups from $copy"
    Get-ADUser -Identity $copy -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members $new_user_logon

}elseif ($ask_copy -like 'n') {

    Write-Host 'New user created, user not added to any security group'
    
}

# Run a Get-ADUser and a net user to check the account and its setup
Get-ADUser $new_user_logon -Properties office, manager, department, title
Get-ADUser $new_user_logon -Properties ProxyAddresses | select ProxyAddresses
net user $new_user_logon /domain
