#install-module -name AzureAD
#$UserCredential = Get-Credential
#connect-azuread
#Get-AzureADSubscribedSku | Select SkuPartNumber # Get owned licenses
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import-PSSession $Session -DisableNameChecking -AllowClobber
function Start-Sleep($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Speed of Cloud!" -Status "Building a mailbox..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    }
    Write-Progress -Activity "Speed of Cloud!" -Status "Building a mailbox..." -SecondsRemaining 0 -Completed
}

#$UPN = "FireStation7Fax@CH.Galveston.City" # Set user to change
# Eat a list of UPNs from a txt file, 1 per line, no commas
# I said UPN! Has to be login name, not necessarily primary SMTP
$UPNs = Get-Content -Path 'D:\OneDrive - Sequel Data Systems\Desktop\shared.txt'
$TargetMailboxType = "Shared"

foreach($UPN in $UPNs)
{
    # Get user and make sure location is set
    "Working on $UPN"
    Get-AzureADUser -ObjectID $UPN | Select-Object DisplayName, UsageLocation
    $userUPN=$UPN
    $userLoc="US"
    Set-AzureADUser -ObjectID $userUPN -UsageLocation $userLoc

    # Assign license
    $planName="DESKLESSPACK_GOV"
    $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    $License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $planName -EQ).SkuID
    $LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    $LicensesToAssign.AddLicenses = $License
    Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $LicensesToAssign

    # Wait for speed of cloud
    Start-Sleep 120

    # Change mailbox type
    get-mailbox $userUPN
    Set-Mailbox $userUPN -Type $TargetMailboxType

    # Remove license
    $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    $License.RemoveLicenses = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $planName -EQ).SkuID
    Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $license
}