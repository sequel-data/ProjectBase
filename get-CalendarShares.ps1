install-module -name AzureAD
$UserCredential = Get-Credential
connect-azuread
Get-AzureADSubscribedSku | Select SkuPartNumber # Get owned licenses
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking -AllowClobber


$boxen = get-mailbox -Resultsize Unlimited
foreach ($box in $boxen) {
    $addresses = $box.EmailAddresses
    foreach ( $address in $addresses ) {
        [string]$ID = $address.AddressString
        write-host ID1 $ID
        $ID += ":\Calendar"
        $permissions = get-mailboxfolderpermission $ID
        write-host ID: $ID
        foreach ( $perm in $permissions ) {
            $mailbox = $address
            $granteduser = $perm.User
            $access = $perm.AccessRights
            $identity = $perm.Identity
            $valid = $perm.IsValid
            if ( $identity -ne "Anonymous" ) {
                $outstring = "$mailbox,$granteduser,$identity,$access,$valid`n"
                $output += $outstring
                write-host $outstring
            }
        }
    }
}
set-content C:\temp\out20210410.csv $output 