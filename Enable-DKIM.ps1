Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName sequeldata@xbiotech.com -ShowProgress $true

# Specify the custom domain to create the keys for
$Domain = "xbiotech.com"

# Create the keys for the domain
New-DkimSigningConfig -DomainName $Domain -Enabled $false
Write-Host -fore red "selector1._domainkey"
Write-Host -fore red "selector2._domainkey"
Get-DkimSigningConfig -Identity $Domain | Format-List Selector1CNAME, Selector2CNAME
Write-Host -fore red "Now you have to go enter these TXT records in DNS because O365 Powershell blows"

# Some day this section will add the DNS records for you 
# But nothing will change the fact that the Exchange servers in O365 will take 9 hours to see those records
#Connect-MsolService
#Get-MsolDomain -DomainName $Domain | select * | fl

$DnsConfigured = $false
While($DnsConfigured -eq $false)
{
    $DomainKey = "selector1._domainkey." + $Domain
    if(Resolve-DnsName -Name $DomainKey -Type txt | Where-Object {$_.Strings -match "selector1"}) 
    {
        Set-DkimSigningConfig -Identity $Domain -Enabled $true
        $DnsConfigured = $true
        "DNS Resolves finally"
    }
}


Get-DkimSigningConfig -Identity $Domain