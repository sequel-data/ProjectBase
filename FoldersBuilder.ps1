$RootFolder = "C:\Users\mike\Sequel Data Systems\Everyone at Sequel - General\Customers"
$RootFolder = "C:\temp\Customers"
$LogFile = "c:\temp\folderLog.txt"

$Customers = get-content C:\temp\Customers.txt

foreach($Customer in $Customers)
{
    cd $RootFolder
    $Customer = $Customer.Replace('/','-')
    $Customer = $Customer.Replace('.','_')
    if ((Test-Path -PathType Container -Path $Customer) -eq $False)
    {
        Try
        {
            New-Item -ItemType Directory -Force -Path $Customer
            "Creating folder for " + $Customer
        }
        Catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            "Shit, something went wrong: $ErrorMessage while trying to create folder $FailedItem" >> $LogFile
        }
    }
    cd "C:\temp\Customers\$Customer"
    New-Item -ItemType Directory -Force -Path "Quotes"
    New-Item -ItemType Directory -Force -Path "Cost"
    New-Item -ItemType Directory -Force -Path "Services"
}