#Connect-MicrosoftTeams
$Teams = get-team
$TeamsUsers = New-Object System.Collections.ArrayList
foreach($Team in $Teams)
{
    $Users = Get-TeamUser -GroupId $Team.GroupId
    foreach($User in $Users)
    {
        $TeamUser = New-Object System.Object
        $TeamUser | Add-Member -MemberType NoteProperty -Name UserName -Value $User.Name
        $TeamUser | Add-Member -MemberType NoteProperty -Name Email -Value $User.User
        $TeamUser | Add-Member -MemberType NoteProperty -Name Role -Value $User.Role
        $TeamUser | Add-Member -MemberType NoteProperty -Name TeamName -Value $Team.DisplayName 
        $TeamUser | Add-Member -MemberType NoteProperty -Name Description -Value $Team.Description
        $TeamsUsers.Add($TeamUser) | Out-Null
    }
}

$TeamsUsers | Sort-Object -Property UserName,TeamName | Format-Table # Output to console for instant gratification
$TeamsUsers | Sort-Object -Property UserName,TeamName | Export-Csv -Path c:\IT\TeamsUsers.csv -NoTypeInformation # Output to CSV for sorting and manipulation