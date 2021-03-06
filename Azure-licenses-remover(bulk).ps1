  
$temp1 = Get-Content "c:\temp\userlist.csv"
$userList = @()
$x=0

   ## this peace of code iterates through each value in the file
   ## and query azure using a search base string if the any records are located, 
   ## the users emails is then store in the variable userlist

foreach($User in $temp1){
        $usertemp = Get-AzureADUser -SearchString $User
        if( $null -ne $usertemp){
            $userList += $usertemp.UserPrincipalName.tostring() #| Out-File -Append "c:\temp\userlis.csv"
            $x++ 
        }

}   
  

   ForEach ($user in $userList){
    

        $listoflicenceses = Get-AzureADUserLicenseDetail -ObjectID $user  #| Select -ExpandProperty AssignedLicenses | Select SkuID
    
        if($userList.Count -ne 0) {
            
            if($listoflicenceses  -is [array]) {
                   
                    for ($i=0; $i -lt $listoflicenceses.Count; $i++) {
                
                            #creates an object type license to get user license and parse it to $licenses variable
                            $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
                            #creates an object type licenses to store user's lincenses to be remove
                            $licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
                    
                            $license.SkuId = $listoflicenceses[$i].SkuId # itarate through each user license
                                        
                            #assing licenceses to remove to the variable Licenses.
                            $Licenses.RemoveLicenses = (Get-AzureADSubscribedSku | Where-Object -Property SkuID -Value $userList[$i].SkuId -EQ).SkuID
                            #license skuid id previously assing to the variable licenses gets remove from user account by using the set function
                            Set-AzureADUserLicense -ObjectId $user -AssignedLicenses $licenses
    
                            
    
                    } #end For
                  
            }#End If
            elseif($null -ne $listoflicenceses) {
                        #creates an object type license to get user license and parse it to $licenses variable
                        $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
                        #creates an object type licenses to store user's lincenses to be remove
                        $licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    
                        $license.SkuId = $listoflicenceses.SkuId #grabs user lincenses and 
                        $Licenses.RemoveLicenses = (Get-AzureADSubscribedSku | Where-Object -Property SkuID -Value $listoflicenceses.SkuId -EQ).SkuID
                        Set-AzureADUserLicense -ObjectId $user -AssignedLicenses $licenses
            }#end elseIF 
            else { #End Else 
                " No lincenses found for "+ $user + " in Azure. `n `n " | Out-File    -Append "C:\Users\rreyes\Desktop\report.csv" 
            }#end else
          
        } #End  if($userList.Count -ne 0)
        
         
       Get-AzureADUserLicenseDetail -ObjectId $user | Out-File -Append "C:\Desktop\report.csv"
    }  #End ForEach
    
