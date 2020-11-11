#Reset Password for users
$user = Read-Host -Prompt 'Enter username'
$new_pass = (Read-Host -Prompt 'Enter password' AsSecureString)
Unlock-ADAccount -Identity '$user'
Set-ADAccountPassword -Identity '$user' -NewPassword $new_pass -Reset
#pending if instruction to select bet. perm and temp passwords.
Set-ADUser -Identity '$user' -ChangePasswordAtLogon $True
