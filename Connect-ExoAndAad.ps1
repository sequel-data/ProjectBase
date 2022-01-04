install-module -name AzureAD
$UserCredential = Get-Credential
connect-azuread
Get-AzureADSubscribedSku | Select SkuPartNumber # Get owned licenses
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking -AllowClobber

