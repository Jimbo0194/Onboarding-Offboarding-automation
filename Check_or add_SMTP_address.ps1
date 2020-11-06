#Check the current SMTP user primary address
$User = Read-Host -Prompt 'Enter AD User' 
get-aduser $User -Properties ProxyAddresses | select Name, ProxyAddresses

#Add an SMTP address to the user ( SMTP sets as primary address, smtp sets as additional address)
$user_to_add = Read-Host -Prompt 'Enter the user to add an SMTP address'
$address = Read-Host -Prompt 'Enter SMTP address to add'
$address= $address.Replace("""","")
Set-ADUser $user_to_add -add @{ProxyAddresses= $address}

#Remove an SMTP address to the user 
$user_address_del = Read-Host -Prompt 'Enter AD User'
$address_delete = Read-Host -Prompt 'Enter address to remove'
$address_delete= $address_delete.Replace("""","")
Set-ADUser $user_address_del -remove @{ProxyAddresses=$address_delete}


