Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
New-Item -Type Directory -Path "C:\HWID"
Set-Location -Path "C:\HWID"
Install-Script -Name Get-WindowsAutoPilotInfo
Get-WindowsAutoPilotInfo.ps1 -OutputFile AutoPilotHWID.csv