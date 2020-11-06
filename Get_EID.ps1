# Gives the Employee ID 
$user = Read-Host "Enter user logon name"
Get-ADUser $user -Properties employeeid | select employeeID
