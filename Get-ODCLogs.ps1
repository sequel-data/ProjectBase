wget https://aka.ms/intunexml -outfile Intune.xml
wget https://aka.ms/intuneps1 -outfile IntuneODCStandAlone.ps1
PowerShell -ExecutionPolicy Bypass -File .\IntuneODCStandAlone.ps1