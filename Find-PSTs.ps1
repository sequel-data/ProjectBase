$Computers = (Get-ADComputer -Filter *).Name # You can filter by OS, OU, etc to run this in smaller batches.
$LogPath = "c:\temp"

$Log = @()
ForEach ($Computer in $Computers)
{   ForEach ($Drive in "C") # This can be a list of drive letters like "C","D","X"
    {   If (Test-Path "\\$Computer\$($Drive)$")
        {   Write-Host $Computer
            $Log += ForEach ($PST in ($PSTS = Get-ChildItem "\\$Computer\$($Drive)$" -Include *.pst -Recurse -Force -ErrorAction SilentlyContinue))
            # Walking the HDDs of every computer will take time and slow down the machine being scanned. 
            {   New-Object PSObject -Property @{
                    ComputerName = $Computer
                    Path = $PST.DirectoryName
                    FileName = $PST.BaseName
                    Size = "{0:N2} MB" -f ($PST.Length / 1mb)
                }
            }
        }
    }
}

$Log | Export-Csv $LogPath\PSTLog.csv -NoTypeInformation