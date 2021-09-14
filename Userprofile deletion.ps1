#Detects if C:\Users\%username%\Appdata\Roaming\folder_name\file_or_subfolder_name exists

Function CurrentUser{
#CurrentUser function converts the username object string "@{username=domain\user}" 
#         to the exact logon string "user" like the example below
#@{username=DOMAIN\USER}
#@{username DOMAIN\USER}
#DOMAIN\USER}
#DOMAIN\USER
#DOMAIN USER
#USER
$loggedInUserName = get-wmiobject win32_computersystem | select username
$loggedInUserName = [string]$loggedInUserName
$loggedinUsername = $loggedInUserName.Split("=")
$loggedInUserName = $loggedInUserName[1]
$loggedInUserName = $loggedInUserName.Split("}")
$loggedInUserName = $loggedInUserName[0]
$loggedInUserName = $loggedInUserName.Split("\")
$loggedInUserName = $loggedInUserName[1]
Return $loggedInUserName
}
$user = CurrentUser

$appPath = "C:\Users\" + $user + "\Appdata\Roaming\Wellnomics\WorkPace"
If (Test-Path $appPath) {
    get-childitem $appPath -Recurse -include *.raw | foreach ($_) {Remove-Item -Path $_.fullname}
    
}