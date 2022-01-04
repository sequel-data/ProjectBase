Import-Module ExchangeOnlineManagement
$UserCredential = Get-Credential
Connect-ExchangeOnline -Credential $UserCredential -ShowProgress $true # [-ExchangeEnvironmentName <Value>] [-DelegatedOrganization <String>]