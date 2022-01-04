$output = $null
$mailboxes = get-mailbox
foreach($mailbox in $mailboxes){
    $email = $mailbox.primarysmtpaddress
    $stats = get-mailboxstatistics -Identity $email
    $size = $stats.TotalItemSize
    $count = $stats.ItemCount
    $outstring = "$email;$size;$count`n"
    $output += $outstring
    write-host $outstring
}
set-content C:\temp\O365MailboxCounts.csv $output

