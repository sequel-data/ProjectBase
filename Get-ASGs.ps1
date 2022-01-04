$nics =Get-AzureRmNetworkInterface -ResourceGroupName "Resource-SRVRS" 
foreach($nic in $nics)
{
    $vm = (Get-AzureRmVM 3> $null | where-object -Property Id -EQ $nic.VirtualMachine.id).Name
    $Name = $nic.Name
    $prv =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAddress
    $alloc =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAllocationMethod
    $asgs =  $nic.IpConfigurations | select-object -ExpandProperty ApplicationSecurityGroups
    foreach($asg in $asgs)
    {
        $asg.Name
    }
    Write-Output "$vm, $Name, $prv, $alloc, $asc"
}