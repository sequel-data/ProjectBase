Set-AzureRmVMExtension -ResourceGroupName "BKT-Prod-Public-Web" -VMName "vm-rx" -Location "westus2" -Publisher "Microsoft.HpcCompute" -ExtensionName "AmdGpuDriverWindows" -ExtensionType "AmdGpuDriverWindows" -TypeHandlerVersion 1.0 -SettingString '{ }'