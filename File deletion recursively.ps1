get-childitem '\\itcbdropbox.intel.com\DropBox\PlatformEng-KT-Resources\User\Packaging\' -Recurse -include *.7z | foreach ($_) {Remove-Item -Path $_.fullname}

$count = 0
get-childitem '\\itcbdropbox.intel.com\DropBox\PlatformEng-KT-Resources\User\Packaging\' -Recurse -include *.exe | foreach ($_) {
$a  = Get-ItemProperty -Path $_.fullname
if($a.LastWriteTime.Year -lt 2021){

write-host $_.fullname
Remove-Item -Path $_.fullname
$count = $count + 1
}
}