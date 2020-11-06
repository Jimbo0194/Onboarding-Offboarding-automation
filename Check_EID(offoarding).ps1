#Check users without knowing the logon (Offboarding)
 $ID = Read-Host -Prompt 'Enter employee ID'
 get-aduser -filter {employeeid -eq $ID}