 <# 
2 .SYNOPSIS 
3     Invoke AP_HP_ZBook15G3_BIOS_Update_1.47_R0101 process. 
4  
5 .DESCRIPTION 
6     This script will invoke the Multi driver pack installation process  
7  

29 #> 


Try { Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop' } Catch {} 

#----------------------------------------------------------Function to check previous version-----------------------------------------






	## Variables: Application 
[string]$appVendor = 'HP' 
[string]$appName = 'ZBook_Bios' 	
[string]$appVersion = '01.47' 
[string]$appLang = 'EN' 
[string]$appRevision = '01' 
[string]$appScriptAuthor = 'Abraham Mathew' 
$logname ="AP_" + $appVendor + "_" + $appName + "_" + $appVersion + "_" + $appRevision + ".log"


$t = $env:temp
$Root = "$env:systemdrive"
$ScriptDirectory = "C:" + "\Intel\KIC\Drivers\"
$extractlocation =  $t + "\AP_HP_ZBook15G3_BIOS_Update_1.47_R0101\*"




$Driver = $ScriptDirectory + "SP100177"
$Driver1 = $ScriptDirectory +  "sp103801"

$WireButtonLog = $Driver + "\InstallCmdWrapper-InstallCmd.log"



$Rootdrive = "C:" + "\"


$Logpath1 = "C:" + "\Intel\Logs"
$DriversFolder = "C:" + "\Intel\KIC\Drivers"
$DriversFolder1 = "C:" + "\Intel\KIC\Drivers"

$Logpath = $Logpath1 + "\" + $logname

(get-date).ToString() + " - HP Zbook G3 Bios update  started `n" | Out-File $Logpath -Append

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

(get-date).ToString() + " - BitLocker Suspension  started " | Out-File $Logpath -Append

Start-Process -FilePath "MNE_BitLocker_Suspend_1.0.exe" "/s" -WorkingDirectory $ScriptDirectory -wait

(get-date).ToString() + " - Bitlocker Suspended " | Out-File $Logpath -Append





#2------------------------------------Wireless Button Driver 2.1.10.1  - Laptop Installation----------------------------------------------------- 


If(test-path $Driver)
{



(get-date).ToString() + " - Wireless Button Driver  Begin " | Out-File $Logpath -Append

Start-Process -FilePath "InstallCmdWrapper.exe"   -WorkingDirectory $Driver -wait
if (Test-Path $WireButtonLog)
{
     copy-Item –path $WireButtonLog "C:\intel\Logs"  -Force
     Rename-Item "C:\intel\Logs\InstallCmdWrapper-InstallCmd.log" “HPWirelessButton_Install.log”
}

(get-date).ToString() + " - Wireless Button Driver  Installation Completed " | Out-File $Logpath -Append


} 



#4------------------------------------HP Bios Update 01.47 Installation----------------------------------------------------- 

$DriverVersion = $null
Try { 
$a = gwmi Win32_bios
$DriverVersion = ($a.SMBIOSBIOSVersion.Split(" ")[2]).trim(" ")



} Catch {} 

If($DriverVersion -eq $null -or ([version]$DriverVersion -lt [version]"01.47")) {
If(test-path $Driver1)
{



(get-date).ToString() + " - HP Bios Update 01.47 Begin " | Out-File $Logpath -Append

Start-Process -FilePath "HPBIOSUPDREC.exe" "-s" -WorkingDirectory $Driver1 -wait
if (Test-Path “C:\Swsetup\sp103801\HPBIOSUPDREC64.log”)
{
     copy-Item –path “C:\Swsetup\sp103801\HPBIOSUPDREC64.log”  “C:\intel\logs”   -Force
     
}



(get-date).ToString() + " - HP Bios Update 01.47 Installation Successfull " | Out-File $Logpath -Append


} 
}else{
(get-date).ToString() + " - HP Bios Update 01.47 Already Installed " | Out-File $Logpath -Append
}










(get-date).ToString() + " - HP Zbook G3 Bios update  completed " | Out-File $Logpath -Append



$tdir = $env:TEMP + "\AP_HP_ZBook15G3_BIOS_Update_1.47_R0101"
if(test-path $tdir) {
Remove-Item –path $tdir -Recurse -Force

}
"---------------------------------------------------------------------------------------------------- `n" | Out-File $Logpath -Append

