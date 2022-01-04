$path="OU=Domain Users,DC=ad,DC=hookbang,DC=com"
$UsersToImport = import-csv -Path C:\IT\hookbang.csv

foreach($UserToImport in $UsersToImport)
{
    $UserToImport.username 
    $UserToImport.password
    $Name = $UserToImport.username
    $Pswd = $UserToImport.password
    New-AdUser -Name $Name -Path $path -Enabled $True -ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString $Pswd -AsPlainText -force) -passThru -CannotChangePassword -PasswordNeverExpires
}