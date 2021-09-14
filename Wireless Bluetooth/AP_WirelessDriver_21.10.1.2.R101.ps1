Param
(
    
    [String]$Inputparameter1,
    [String]$Inputparameter2
)

if($Inputparameter1){
If($Inputparameter1 -match ("/v:21.10.1.2")){
$Wireless = $Inputparameter1

}
If($Inputparameter1 -match "Bluetooth")
{
$Bluetooth = $Inputparameter1
}

}

if($Inputparameter2){
If($Inputparameter2 -match ("/v:21.10.1.2")){
$Wireless = $Inputparameter2

}
If($Inputparameter2 -match "Bluetooth")
{
$Bluetooth = $Inputparameter2
}

}

Try { Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop' } Catch {} 


#Try { Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop' } Catch {} 

	## Variables: Application 
[string]$appVendor = 'Intel' 
[string]$appName = 'WirelessDriver' 	
[string]$appVersion = '21.10.1.2' 
[string]$appLang = 'EN' 
[string]$appRevision = '01' 
[string]$appScriptAuthor = 'Abraham Mathew' 





 


$t = $env:temp
$Root = $env:systemdrive
$Rootdrive = $Root + "\"
$DriversFolder = $Rootdrive + "ProgramData\Intel\"
$ScriptDirectory = $DriversFolder + "WLAN\"
$extractlocation =  $t + "\WLAN"
$EXEpath = $ScriptDirectory + "WLANcInstall.exe"

$Logpath = $Root + "\Intel\Logs"

$Wireless | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append

 (get-date).ToString() + " - Intel Wireless Driver Installation started " | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append

If(test-path $extractlocation)
{
If($ScriptDirectory){

#Remove-Item -Path $ScriptDirectory -Recurse -Force
}

Copy-Item -path $extractlocation -Destination $DriversFolder  -Recurse -container -Force 

(get-date).ToString() + " - Intel Wireless Driver Installation Files copied " | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append

If(test-path $EXEpath)
{



If($Wireless){

(get-date).ToString() + " - Intel Wireless Driver Begin " | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append

$Wireless | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append

Start-Process -FilePath "WLANcInstall.exe" -ArgumentList  $Wireless -WorkingDirectory $ScriptDirectory -wait

(get-date).ToString() + " - Intel Wireless Driver Installation Successfull " | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append

}

If($Bluetooth){

(get-date).ToString() + " - Intel Bluetooth Driver Begin " | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append

start-process -FilePath .\install.bat -Wait

(get-date).ToString() + " - Intel Bluetooth Driver Installation Successful " | Out-File $Logpath\AP_Intel_EN_WirelessDriver_21.10.1.2.R101.log -Append



}
}
}

