<#--------------------BIOS------------------#>
try
{
$bios = Get-WmiObject Win32_BIOS
$BIOSVersion = $bios.SMBIOSBIOSVersion
}
catch{
    $BIOSVersion = "0"
}

<#--------------------Bluetooth by PS------------------#>
try
{
    $bDevice = Get-PnpDevice | where{$_.friendlyname -eq "Intel(R) Wireless Bluetooth(R)"}
    $BluetoothPSVersion = ((Get-PnpDeviceProperty -InstanceId $bDevice.InstanceId | where {$_.keyname -eq "DEVPKEY_Device_DriverVersion"}).data).trim()
}
catch{
    $BluetoothPSVersion = "0"
}
<#--------------------Display Link by Registry Path------------------#>
try
{
    If(Test-path "HKLM:\SOFTWARE\DisplayLink\Core\")
    {
        $DisplayLinkVersion =(gp "HKLM:\SOFTWARE\DisplayLink\Core\").Version
    } 
}
catch{
    $DisplayLinkVersion = "0"
}
<#--------------------Graphics by PS------------------#>
try
{
    $grpDevice = Get-PnpDevice | where{$_.friendlyname -like "Intel(R) *HD Graphics*"}
    $GraphicsPSVersion = ((Get-PnpDeviceProperty -InstanceId $grpDevice.InstanceId | where {$_.keyname -eq "DEVPKEY_Device_DriverVersion"}).data).trim()
    $GraphicsPSVersion = $GraphicsPSVersion.Split()[0]
}
catch{
    $GraphicsPSVersion = "0"
}

<#--------------------WLAN by Registry------------------#>
try
{
    If(Test-path "HKLM:\SOFTWARE\Intel\WLAN")
    {
        $WLANRegVersion =(gp "HKLM:\SOFTWARE\Intel\WLAN\").WirelessDriverVersion
    }
}
catch{
    $WLANRegVersion = "0"
}


<#--------------------JSON RESULT------------------#>
$JsonResult = "[
  {
    `"DriverName`": `"BIOS`",
    `"DriverVersion`": `"" + $BIOSVersion +"`"
  },
  {
    `"DriverName`": `"Bluetooth`",
    `"DriverVersion`": `"" + $BluetoothPSVersion +"`"
  },
  {
    `"DriverName`": `"DisplayLink`",
    `"DriverVersion`": `"" + $DisplayLinkVersion +"`"
  },
  {
    `"DriverName`": `"IntelGraphics`",
    `"DriverVersion`": `"" + $GraphicsPSVersion +"`"
  },
  {
    `"DriverName`": `"WLAN`",
    `"DriverVersion`": `"" + $WLANRegVersion +"`"
  }
]"

Return $JsonResult 

#---------------------------------------------------------------------Audio-------------------------------------------------------------------
$DriverVersion = $null
Try { 
$d = Get-PnpDevice | where{$_.friendlyname -eq "Realtek(R) Audio"}
$Audio = ((Get-PnpDeviceProperty -InstanceId $d.InstanceId | where {$_.keyname -eq "DEVPKEY_Device_DriverVersion"}).data).trim()


} Catch {} 

Try { 
$d = Get-PnpDevice | where{$_.friendlyname -eq "Conexant ISST Audio"}
$Audio1 = ((Get-PnpDeviceProperty -InstanceId $d.InstanceId | where {$_.keyname -eq "DEVPKEY_Device_DriverVersion"}).data).trim()


} Catch {} 

if($Audio){
$DriverVersion = $Audio
}
if($Audio1){
$DriverVersion = $Audio1
}