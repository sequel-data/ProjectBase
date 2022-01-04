Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName adm-mike.morris@galvestontexas.onmicrosoft.com

Get-CASMailbox | Export-Csv -NoTypeInformation c:\temp\GalvestonProtocols.csv

Get-TransportConfig | Format-List SmtpClientAuthenticationDisabled

Disconnect-ExchangeOnline