# 2. Remove the discovered groups from default protected group membership, reset their inheritance, and clear the admincount value.
# Yes it is out of order. The function needs to get loaded before it can be called by the first step. 
$Folder = 'C:\temp'
if (Test-Path -Path $Folder) {    
} else {
    New-Item -Path "c:\" -Name "temp" -ItemType "directory"
}

$LogFile = "c:\temp\ProtectedGroups.txt"
$Execute = Read-Host "Would you like to report or execute? (Type Execute to do the actual work. Any other input wil report only"
(Get-Date).ToString('yyyyMMddThhmmss') + "..........NEW LOG.........." | Out-File -filepath $LogFile -Append
(Get-Date).ToString('yyyyMMddThhmmss') + " Execute value = " + $Execute | Out-File -filepath $LogFile -Append
$protectedadgroups = @()

Function FixGroup($identity,$member)
{
    # Now it's time to do 3 things:
    # 1. remove the discovered group from membership of the protected group it was found in
    " Removing group $member from membership in protected group " + $identity
    (Get-Date).ToString('yyyyMMddThhmmss') + " Removing group $member from membership in protected group " + $identity | Out-File -filepath $LogFile -Append
    If($Execute -eq "execute"){Remove-ADGroupMember -Identity $identity -Members $member -Confirm:$false}
    # 2. Enable inheritance on the discovered group
    " Enabling inheritance on group $member"
    (Get-Date).ToString('yyyyMMddThhmmss') + " Enabling inheritance on group $member" | Out-File -filepath $LogFile -Append
    " Clearing admincount flag on group $member"
    (Get-Date).ToString('yyyyMMddThhmmss') + " Clearing admincount flag on group $member" | Out-File -filepath $LogFile -Append
    $adgroup = Get-ADGroup -Identity $member -Properties "ntSecurityDescriptor","adminCount"
    $adgroup | select Name,SamAccountName,adminCount,@{Name="AreAccessRulesProtected";Expression={$_.ntSecurityDescriptor.AreAccessRulesProtected}}
    If($Execute -eq "execute")
    {
        Set-ADGroup -Identity $adgroup -Replace @{ntSecurityDescriptor = $adgroup.ntSecurityDescriptor} -Clear "adminCount" -Confirm:$false #-verbose
        #start-sleep -s 5
        $adgroup.ntSecurityDescriptor.SetAccessRuleProtection($false, $true)
    }
}
# 1. discover non-defualt protected groups that are members of default protected groups.
$defaultprotectedgroups = @("Enterprise Admins","Domain Admins","Schema Admins","Administrators","Account Operators","Backup Operators","Print Operators","Server Operators","Domain Controllers","Read-only Domain Controllers","Cryptographic Operators")
foreach($defaultprotectedgroup in $defaultprotectedgroups)
{
    #$defaultprotectedgroup
    $discoveredGroups = Get-ADGroupMember -Identity $defaultprotectedgroup | ? {$_.objectclass -eq "group"}
    foreach($discoveredGroup in $discoveredGroups)
    {
        if($defaultprotectedgroups -match $discoveredGroup.Name)
        {# If true, the discovered group is among the default protected groups. We do not want to move any of these.
            #For instance, Domain admins is a member of Administrators. We do not want to pull it out of administrators or try to nullify its admincount or mod its inheritance.
        }
        else
        {
            # If false, this is a non-default group that has been made a member of a protected group, and we do want to pull it out of protected groups and admincount null and enable inheritance.
            # So we will add it to a new array that we will iterate through to do those things.
            "I found " + $discoveredgroup.Name + " in the protected group " + $defaultprotectedgroup + "."
            FixGroup $defaultprotectedgroup $discoveredGroup.distinguishedName
            $protectedadgroups += $discoveredGroup.distinguishedName
        }
    }
}

#3. Reset inheritance and clear the admincount value for all member users in the discovered non-default protected groups above.
foreach($protectedadgroup in $protectedadgroups)
{
    $protectedgroupmembers = (Get-ADGroupMember -Identity $protectedadgroup).distinguishedName
    foreach($protectedgroupmember in $protectedgroupmembers)
    {
        " Resetting inheritance and clearing admincount for user $protectedgroupmember"
        (Get-Date).ToString('yyyyMMddThhmmss') + " Resetting inheritance and clearing admincount for user $protectedgroupmember" | Out-File -filepath $LogFile -Append
        $aduser = get-aduser -Identity $protectedgroupmember -Properties "ntSecurityDescriptor","adminCount"
        $aduser | select Name,SamAccountName,adminCount,@{Name="AreAccessRulesProtected";Expression={$_.ntSecurityDescriptor.AreAccessRulesProtected}}
        If($Execute -eq "execute")
        {
            $aduser.ntSecurityDescriptor.SetAccessRuleProtection($false, $true)
            #start-sleep -s 5 
            Set-ADUser -Identity $aduser -Replace @{ntSecurityDescriptor = $aduser.ntSecurityDescriptor} -Clear "adminCount" -Confirm:$false #-verbose
        }
    }
}

(Get-Date).ToString('yyyyMMddThhmmss') + "..........END LOG.........." | Out-File -filepath $LogFile -Append