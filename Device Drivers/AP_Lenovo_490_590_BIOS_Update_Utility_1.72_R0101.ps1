 <# 
2 .SYNOPSIS 
3     Invoke AP_Lenovo_490_590_BIOS_Update_Utility_1.72_R0101 process. 
4  
5 .DESCRIPTION 
6     This script will invoke the Multi driver pack installation process  
7  

29 #> 


Try { Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop' } Catch {} 

#----------------------------------------------------------Function to check previous version-----------------------------------------






	## Variables: Application 
[string]$appVendor = 'Lenovo_490_590' 
[string]$appName = 'BIOS_Update_Utility' 	
[string]$appVersion = '1.72' 
[string]$appLang = 'EN' 
[string]$appRevision = '01' 
[string]$appScriptAuthor = 'Abraham Mathew' 
$logname ="AP_" + $appVendor + "_" + $appName + "_" + $appVersion + "_" + $appRevision + ".log"


$t = $env:temp
$Root = "$env:systemdrive"
$ScriptDirectory = "C:" + "\Intel\KIC\Drivers\"
$extractlocation =  $t + "\AP_Lenovo_490_590_BIOS_Update_Utility_1.72_R0101\*"




$Rootdrive = "C:" + "\"


$Logpath1 = "C:" + "\Intel\Logs"
$DriversFolder = "C:" + "\Intel\KIC\Drivers"
$DriversFolder1 = "C:" + "\Intel\KIC\Drivers"

$Logpath = $Logpath1 + "\" + $logname

$Bios= $ScriptDirectory  + "FLASH\n2iuj27w\"
$BiosLog = $Bios + "Winuptp.log"
$TS = $ScriptDirectory  + "Lenovo Intelligent Thermal Solution\"
$IDTTD = $ScriptDirectory  + "Intel Dynamic Tuning Technology Driver\"

$PM = $ScriptDirectory  + "Power Management Driver\"
#--------------------------------------------------------function definition------------------------------------

function Copy-Log {
if(Test-Path "c:\windows\dpINST.LOG"){
Copy-Item "c:\windows\dpINST.LOG" -Destination "c:\intel\logs\" -Force
if(Test-Path "c:\intel\logs\Masterlist.log"){
Remove-Item "c:\intel\logs\Masterlist.log"
}
if(Test-Path "c:\intel\logs\dpINST.LOG"){
Rename-Item -Path "c:\intel\logs\dpINST.LOG" -NewName "Masterlist.log" -Force
}
}
}


function Log-Config([string]$arg1) {
if(Test-Path "c:\windows\dpINST.LOG"){
$filename = "c:\intel\logs\" + $arg1
Copy-Item "c:\windows\dpINST.LOG" -Destination "c:\intel\logs\" -Force
if(Test-Path "c:\intel\logs\ChildList.log"){
Remove-Item "c:\intel\logs\ChildList.log"
}
Rename-Item -Path "c:\intel\logs\dpINST.LOG" -NewName "ChildList.log" -Force
$strReference = Get-Content "c:\intel\logs\Masterlist.log"
$strDifference = Get-Content "c:\intel\logs\ChildList.log"
$a = Compare-Object $strReference $strDifference -SyncWindow 0
$a | %{if($_.SideIndicator -eq "=>"){
$_.InputObject  | out-file $filename -Append
}
}
if(Test-Path "c:\intel\logs\Masterlist.log"){
Remove-Item "c:\intel\logs\Masterlist.log"
}
if(Test-Path "c:\intel\logs\ChildList.log"){
Remove-Item "c:\intel\logs\ChildList.log"
}
}
}

function delete-folder([string[]]$Folderpath){
For ($i=0; $i -le $Folderpath.Length; $i++){
Try {
Remove-Item -LiteralPath $Folderpath[$i] -Force -Recurse
}

Catch {}
}
}

#----------------------------------------------------------------------------------------------------------------------
(get-date).ToString() + " - Lenovo_490_590_BIOS_Update_Utility_1.72  started `n" | Out-File $Logpath -Append

#------------------------------------Copy Driver Files-----------------------------------------------------
if (-Not (Test-Path $DriversFolder))
{
     md -path $DriversFolder
}

Copy-Item -path $extractlocation -Destination $DriversFolder  -Container -Recurse  -Force 
#Copy-Item -path $extractlocation1 -Destination $DriversFolder1   -Recurse  -Force 
#Copy-Item -path $extractlocation2 -Destination $DriversFolder1   -Recurse  -Force 
#Copy-Item -path $extractlocation3 -Destination $DriversFolder  -Container -Recurse  -Force 

(get-date).ToString() + " - Driver Installation Files copied " | Out-File $Logpath -Append


#------------------------------------BitLocker suspension-----------------------------------------------------



$a = Get-BitLockerVolume  c:
$b = [String]$a.ProtectionStatus
If($b -ne "off"){
(get-date).ToString() + " - BitLocker Suspension  started " | Out-File $Logpath -Append
Start-Process -FilePath "MNE_BitLocker_Suspend_1.0.exe" "/s" -WorkingDirectory $ScriptDirectory -wait

(get-date).ToString() + " - Bitlocker Suspended " | Out-File $Logpath -Append
}

#1------------------------------------Lenovo PM Device 1.67.17.52 Installation----------------------------------------------------- 
$DriverVersion = $null
Try { 
$d = Get-PnpDevice | where{$_.friendlyname -eq "Lenovo PM Device"}
$DriverVersion = ((Get-PnpDeviceProperty -InstanceId $d.InstanceId | where {$_.keyname -eq "DEVPKEY_Device_DriverVersion"}).data).trim()


} Catch {}

If($DriverVersion -eq $null -or ([version]$DriverVersion -lt [version]"1.67.17.52")) {

If(test-path $PM)
{
if(Test-Path "c:\windows\dpINST.LOG"){
Copy-Log
} else{
$Dpinstnotpresent = $true
}

(get-date).ToString() + " - Lenovo PM Device_1.67.17.52 Begin " | Out-File $Logpath -Append

$p = Start-Process -FilePath "dpinst_x64.exe" '-S'  -WorkingDirectory $PM -wait -PassThru
if($Dpinstnotpresent){
Copy-Log
if(Test-Path "c:\intel\logs\Masterlist.log"){

if(Test-Path "c:\intel\logs\Lenovo_PM_Device_1.67.17.52.log"){
Remove-Item "c:\intel\logs\Lenovo_PM_Device_1.67.17.52.log"
}
Rename-Item -Path "c:\intel\logs\Masterlist.log" -NewName "Lenovo_PM_Device_1.67.17.52.log" -Force
}
}else{

Log-Config("Lenovo_PM_Device_1.67.17.52.log")
}

(get-date).ToString() + " - Lenovo PM Device_1.67.17.52 Installation completed with exit code $($p.exitcode) `n " | Out-File $Logpath -Append


} 
}else{

(get-date).ToString() + " - Lenovo PM Device_1.67.17.52 Already Installed " | Out-File $Logpath -Append
}
#2------------------------------------Thermal Solution 2.0.369.1 Installation----------------------------------------------------- 
$DriverVersion = $null
Try { 
$d = Get-PnpDevice | where{$_.friendlyname -eq "Lenovo Intelligent Thermal Solution"}
$DriverVersion = ((Get-PnpDeviceProperty -InstanceId $d.InstanceId | where {$_.keyname -eq "DEVPKEY_Device_DriverVersion"}).data).trim()


} Catch {} 
If($DriverVersion -eq $null -or ([version]$DriverVersion -lt [version]"2.0.369.1")) {



If($TS){

(get-date).ToString() + " - Thermal Solution 2.0.369.1 Begin " | Out-File $Logpath -Append
Copy-Log

#Start-Process -FilePath "r0gar18w.exe" '/VERYSILENT /LOG=C:\INTEL\LOGS\Audio.log /NORESTART /SUPPRESSMSGBOXES /DIR=C:\INTEL\KIC\DRIVERS\WIN\Audio\'  -WorkingDirectory $ScriptDirectory -wait
$p = Start-Process -FilePath "Dpinst.exe" '/s'  -WorkingDirectory $TS -wait -PassThru
Log-Config("Thermal_Solution_2.0.369.1.log")
(get-date).ToString() + " - Thermal Solution 2.0.369.1 Installation completed with exit code $($p.exitcode) `n " | Out-File $Logpath -Append

}
}else{
(get-date).ToString() + " - Thermal Solution 2.0.369.1 Already Installed " | Out-File $Logpath -Append
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#3------------------------------------Intel Dynamic Tuning Technology Driver 8.7.10200.12510 Installation----------------------------------------------------- 
$DriverVersion = $null
Try { 
$d = Get-PnpDevice | where{$_.friendlyname -eq "Intel(R) Dynamic Tuning Manager"}
$DriverVersion = ((Get-PnpDeviceProperty -InstanceId $d.InstanceId | where {$_.keyname -eq "DEVPKEY_Device_DriverVersion"}).data).trim()


} Catch {} 
If($DriverVersion -eq $null -or ([version]$DriverVersion -lt [version]"8.7.10200.12510")) {



If($IDTTD){

(get-date).ToString() + " - Intel Dynamic Tuning Technology Driver 8.7.10200.12510 Begin " | Out-File $Logpath -Append
Copy-Log

#Start-Process -FilePath "r0gar18w.exe" '/VERYSILENT /LOG=C:\INTEL\LOGS\Audio.log /NORESTART /SUPPRESSMSGBOXES /DIR=C:\INTEL\KIC\DRIVERS\WIN\Audio\'  -WorkingDirectory $ScriptDirectory -wait
$p = Start-Process -FilePath "Dpinst.exe" '/s'  -WorkingDirectory $IDTTD -wait -PassThru
Log-Config("Intel_Dynamic_Tuning_Technology_Driver_8.7.10200.12510.log")
(get-date).ToString() + " - Intel Dynamic Tuning Technology Driver 8.7.10200.12510 Installation completed with exit code $($p.exitcode) `n " | Out-File $Logpath -Append

}
}else{
(get-date).ToString() + " - Intel Dynamic Tuning Technology Driver 8.7.10200.12510 Already Installed " | Out-File $Logpath -Append
}
#4------------------------------------Lenovo Bios Update 01.72 Installation----------------------------------------------------- 

$DriverVersion = $null
Try { 
$a = gwmi Win32_bios
$b = $a.SMBIOSBIOSVersion.Split("(")[1]
$DriverVersion= $b.Split(" ")[0]


} Catch {} 

If($DriverVersion -eq $null -or ([version]$DriverVersion -lt [version]"1.72")) {
If(test-path $Bios)
{



(get-date).ToString() + " - Lenovo T590 Bios Update 1.72 Begin " | Out-File $Logpath -Append

$p = Start-Process -FilePath "WINUPTP.EXE" "-s" -WorkingDirectory $Bios -wait -PassThru
if (Test-Path $BiosLog)
{
     copy-Item –path $BiosLog  “C:\intel\logs”   -Force
     
}



(get-date).ToString() + " - Lenovo T590 Bios 1.72 Installation completed with exit code $($p.exitcode) `n  " | Out-File $Logpath -Append


} 
}else{
(get-date).ToString() + " - Lenovo T590 Bios 1.72 Already Installed " | Out-File $Logpath -Append
}










(get-date).ToString() + " - Lenovo_490_590_BIOS_Update_Utility_1.72  completed " | Out-File $Logpath -Append

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------

delete-folder("c:\intel\kic\Drivers\Intel Dynamic Tuning Technology Driver\","c:\intel\kic\Drivers\Power Management Driver\","c:\intel\kic\Drivers\Lenovo Intelligent Thermal Solution\","c:\intel\kic\Drivers\FLASH\n2iuj26w\")

$tdir = $env:TEMP + "\AP_Lenovo_490_590_BIOS_Update_Utility_1.72_R0101"
if(test-path $tdir) {
Remove-Item –path $tdir -Recurse -Force

}
"---------------------------------------------------------------------------------------------------- `n" | Out-File $Logpath -Append




