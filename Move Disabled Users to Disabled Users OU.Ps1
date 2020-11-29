$user = Read-Host -Prompt 'Enter username'
Disable-ADAccount $user 
$time = Get-Date -Format "%M/dd/yyyy"
$user_location = Get-ADUser $user | Select-Object distinguishedname -ExpandProperty distinguishedname -First 1
move-adobject -identity "$user_location" "OU=Disabled Users,DC=domain,DC=com"

#Remove all memberships
Get-ADUser "$user" -Properties MemberOf | Select -Expand MemberOf | %{Remove-ADGroupMember -Confirm:$false $_ -members "$user"} 

#Remove SMTP addresses
ForEach-Object { Set-AdUser -Identity $user -Clear ProxyAddresses }

#Set description to users
$ticket = Read-Host -Prompt "Enter deactivation request ID number"
$fill = (-join("Deactivated per " + "$time" + " ticket " + " #$ticket"))
Set-ADUser $user -Description $fill

#Check description for user
Get-ADUser $user -Properties office, manager, department, title, ProxyAddresses | select ProxyAddresses
net user $user /domain
