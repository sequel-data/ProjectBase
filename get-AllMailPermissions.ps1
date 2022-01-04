Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

# Get all send on behalf permissions to CSV
Get-Mailbox | ? {$_.GrantSendOnBehalfTo -ne ""} | Select Identity, GrantSendOnBehalfTo | Export-Csv -Path C:\temp\SendOnBehalf.csv -NoTypeInformation
# Get all send as permissions to CSV
Get-Mailbox | Get-RecipientPermission | ? {$_.AccessRights -eq "SendAs"} |Select Identity, AccessRights, Trustee | Export-Csv -Path C:\temp\SendAs.csv -NoTypeInformation
# get all full access permissions to CSV
Get-Mailbox | Get-MailboxPermission | ? {$_.AccessRights -contains "FullAccess"} | Select Identity, User, AccessRights | Export-Csv -Path C:\temp\FullAccess.csv -NoTypeInformation
