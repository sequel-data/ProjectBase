$office365Credential = Get-Credential

$global:office365= New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $office365Credential  -Authentication Basic   –AllowRedirection

Import-PSSession $office365

Get-Mailbox | Get-MailboxStatistics | Select-Object DisplayName, IsArchiveMailbox, ItemCount, TotalItemSize | Format-Table –autosize | Sort "TotalItemSize" -Descending

Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics |
Select-Object -Property @{label=”User”;expression={$_.DisplayName}},
@{label=”Total Messages”;expression= {$_.ItemCount}},
@{label=”Total Size (MB)”;expression={[math]::Round(`
($_.TotalItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1MB),2)}} |
Sort "Total Size (MB)" -Descending

Remove-PSSession 