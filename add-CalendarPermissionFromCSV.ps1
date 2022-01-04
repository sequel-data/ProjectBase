Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

$SharePerms2 = import-csv -Path 'C:\temp\book4.csv'

foreach($SharePerm in $SharePerms2)
{
    $Identity = ($SharePerm.Mailbox.Replace("SMTP:","")).replace("smtp:","") + ":\calendar"
    $User = $SharePerm.Identity.split('\')[-1]
    $Access = $SharePerm.Access
    "Setting $Access permission for $User on $Identity"
    Add-MailboxFolderPermission -Identity $Identity -User $User -AccessRights $Access
    Set-MailboxFolderPermission -Identity $Identity -User $User -AccessRights $Access 
    Get-MailboxFolderPermission -Identity $Identity # | ? {$_.User -eq 'Default'}
}