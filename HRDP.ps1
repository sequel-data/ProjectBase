$cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Set-ExecutionPolicy RemoteSigned -Force
Import-PSSession $session

Start-transcript
$StartDate=”10/16/2020”
$EndDate=”11/16/2020”
$Admin=”mike.morris@sequeldata.com”
$SearchScope=“*”+”sfv=spm”+“*”
Get-mailbox | ForEach-Object{ Start-HistoricalSearch -ReportTitle "Outbound Spam” –SenderAddress $($_.UserPrincipalName) -StartDate $StartDate -EndDate $EndDate -ReportType MessageTraceDetail -NotifyAddress $Admin | where {$_.custom_data -like $SearchScope} }
Stop-transcript
