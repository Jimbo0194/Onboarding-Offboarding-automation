# Installing Modules
#Install-Module -Name MSOnline -Confirm:$false
#Install-Module -Name AzureAD -Confirm:$false


# Checking AD token Connection
if ($null -eq $creds){
    $creds = Get-Credential
    Connect-AzureAD -Credential $creds
    Connect-MsolService -Credential $creds
} else {
    $token_check = [Microsoft.Open.Azure.AD.CommonLibrary.AzureSession]::AccessTokens
    Write-Verbose "Connected to tenant: $($token.AccessToken.TenantId) with user: $($token.AccessToken.UserId)"
}

$user = $false
while ($user -ne $true) {
    $Usr_UPN= Read-Host 'Enter user´s email'
    try {
        Get-AzureADUser -ObjectId $Usr_UPN
        Set-MsolUser -UserPrincipalName $Usr_UPN -UsageLocation US
        Set-MsolUserLicense -UserPrincipalName $Usr_UPN -AddLicenses 'centricbrands:ENTERPRISEPACK'
        Set-MsolUserLicense -UserPrincipalName $Usr_UPN -AddLicenses 'centricbrands:EMS'
        $user = $true
    }
    catch {
        Write-Host 'User not valid'
        $user = $false
    }
      
}

# 
Start-Sleep -Seconds 3

# Confirming the adding of the licenses
$licensePlanList = Get-AzureADSubscribedSku
$userList = Get-AzureADUser -ObjectID $Usr_UPN | Select-Object -ExpandProperty AssignedLicenses | Select-Object SkuID 
$userList | ForEach-Object { $sku=$_.SkuId ; $licensePlanList | ForEach-Object { If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36) ) { Write-Host $_.SkuPartNumber } } }
