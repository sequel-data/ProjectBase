$Credential = Get-Credentialget
Connect-AzureAD -Credential $Credential
Connect-MsolService 
Set-MsolDirSyncEnabled -EnableDirSync $false -Force
(Get-MSOLCompanyInformation).DirectorySynchronizationEnabled