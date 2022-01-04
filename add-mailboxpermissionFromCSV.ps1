Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

$SharePerms = import-csv -Path C:\temp\test.csv 

foreach($SharePerm in $SharePerms)
{
    $Identity = $SharePerm.Identity.split('/')[-1]
    $User = $SharePerm.User.split('\')[-1]
    $Access = $SharePerm.Access
    "$Identity getting shared as $Access to $User"
    Add-MailboxPermission -Identity $Identity -User $User -AccessRights $Access
    #Get-MailboxPermission -Identity $Identity 
}