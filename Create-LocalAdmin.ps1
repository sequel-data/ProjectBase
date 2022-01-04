$NewLocalAdmin = "LocalAdmin1"
$Password = ConvertTo-SecureString "P@ssW0rD!" -AsPlainText -Force
function Create-NewLocalAdmin {
    New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "FirstClose Local Admin"
    Write-Verbose "$NewLocalAdmin local user crated"
    Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
    Write-Verbose "$NewLocalAdmin added to the local administrator group"
}
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password -Verbose