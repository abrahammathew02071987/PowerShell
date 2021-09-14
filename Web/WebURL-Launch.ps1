

$startDate=(Get-Date)
If($startDate.Year -gt 2016){
$outhost="Script Expired: Validity is till 2016" | Out-Host
Exit(0)
}
$systemdirectory = Get-ChildItem 'C:\Program Files' | foreach { $_.LastWriteTime.Year -gt 2016}
$systemdirectory | ForEach-Object {
If($_ -eq "True"){
$outhost="Script Expired: Validity is till 2016" | Out-Host
Exit(0)
}
}
#------------------Script----------------------------------
$ie = new-object -com InternetExplorer.Application
$csv = import-csv -Path c:\temp\ab1.csv

$csv | ForEach {
$x = [String]$_.WebUrl.Trim(" ")
#------------------Edge-----------------------

start microsoft-edge:$x

#---------Internet Explorer-------------------
$navOpenInBackgroundTab = 0x1000;

$ie.Navigate2($x);


#----------------------Chrome----------------------------------------------
[System.Diagnostics.Process]::Start("chrome.exe",$x)
#-----------------------FireFox---------------------------------------------
[System.Diagnostics.Process]::Start("Firefox.exe",$x)

}
$ie.Visible = $true;