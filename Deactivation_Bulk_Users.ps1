ForEach ($user in (Import-CSV "C:\Users\c-lmonteale\Documents\Deact_test.csv")){
    $userccount= Get-ADUser -Filter "EmployeeID -eq  '$($user.ID.ToString())'"-Properties * | Select-Object SamAccountName
    $userccount= $userccount.SamAccountName.tostring()
    if ($userccount -ne $null){
        Get-ADUser $userccount | Disable-ADAccount
        $user_location= get-aduser $userccount | Select-Object distinguishedname -ExpandProperty distinguishedname -First 1
        move-adobject -identity "$user_location" "OU=Disabled Users,DC=Centric,DC=US"
        #Set description to users
        Set-ADUser $userccount -Description "Disabled per ticket #286337"
        #Remove all memberships
        Get-ADUser $userccount -Properties MemberOf | Select -Expand MemberOf | %{Remove-ADGroupMember -Confirm:$false -verbose $_ -member "$userccount"} 
        #Check user for report 
        Get-ADUser $userccount -Properties * | Select-Object office, manager, department, title | Out-File -Append "C:\Users\c-lmonteale\Documents\report.csv"
        'User '+ $userccount + ' Deactivated on Centric US' | Out-File -Append "C:\Users\c-lmonteale\Documents\report.csv"
        net user $userccount /domain | Out-File -Append "C:\Users\c-lmonteale\Documents\report.csv"
    }
    if ($userccount -eq $null){ 
    'User '+ $user.ID.ToString() + ' not found Centric US' | Out-File -Append "C:\Users\c-lmonteale\Documents\report.csv"
        }}
        
