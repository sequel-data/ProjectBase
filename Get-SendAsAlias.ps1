Connect-ExchangeOnline
Get-OrganizationConfig | fl Sendfrom*
# Uncomment below to enable send from alias org-wide
#Set-OrganizationConfig -SendFromAliasEnabled $true