$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

Get-MailboxStatistics | Sort-Object TotalItemSize –Descending | ft @{label=”User”;expression={$_.DisplayName}},@{label=”Total Size (MB)”;expression={$_.TotalItemSize.Value.ToMB()}},@{label=”Items”;expression={$_.ItemCount}},@{label=”Storage Limit”;expression={$_.StorageLimitStatus}} -auto


Get-Mailbox | select displayname, email, @{n='totalitemsize';e={(Get-MailboxStatistics - Identity $_.displayname).totalitemsize}}|sort totalitemsize

Get-PSSession | Where-Object {$_.ConfigurationName -eq “Microsoft.Exchange”} | Remove-PSSession
