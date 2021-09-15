#***************************************************************************************************************************
#ScriptName: APP_Attempts
#Author: Arun Tangutoori
#Descripion: This script checks for App install/retry attempts and sets reg key for SCCM requirements
#***************************************************************************************************************************

<#

    Version: 2.0
    Last Updated: 01/27/2021

#>

 #region ---> Variables
    $SetupName ="setup.bat"
    $LogFile = "C:\intel\logs\NVIDIA_Video_CPanel_27.21.14.5225.log"
    $AppName = "HP_NVIDIA_Video_CPanel_Driver"
 #endregion ---> Variables

 #region ---> FUNCTIONS


 #Check if reg key exists

 Function Detect_APP_Install
    {
if (test-path 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*')
    {
     Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}' -Recurse -ErrorAction SilentlyContinue | 
     foreach {
               $Key = Get-ItemProperty -Path $_.PsPath
               #$CurrentKey
               if($Key.DriverDesc -like "NVIDIA Quadro*")
                  {
                   $DriverVersion = $Key.Driverversion
                   
                  }
               }
   }

   
#Comapare installed driver version with targeted version
If ($DriverVersion -ge "27.21.14.5225")
    { 
    $true
    }
    else
    {
    }

}

 Function INSTALL
    {
   
   Start-Process -FilePath .\$SetupName -ArgumentList ">>$LogFile" -Wait -PassThru 
   
   if(Detect_APP_Install -eq 'True'){
   }
   else{
   exit 1}
   }

 Function APP_Attempts_INSTALL
    {
     Param (
		    [Parameter(Mandatory=$true)]
		    $AppName

	    )
     $App = "APP_Attempts_$AppName"
     if((Get-Itemproperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name "$App" -EA SilentlyContinue) -and ((Get-Itemproperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name $App).$App) -lt 3)
     { 
        $Count= (Get-Itemproperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name $App).$App
        $Count = $Count+1
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name "$App" -Value $count  
        INSTALL
        
     }
      elseif((Get-Itemproperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name "$App" -EA SilentlyContinue) -and ((Get-Itemproperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name $App).$App) -ge 3)
     { 
        $Count= (Get-Itemproperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name $App).$App
        $Count = $Count+1
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts" -Name "$App" -Value $count  
        exit 1
     }
     else
     {
         if((test-path 'HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts'))
          {
             $Key = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts'
          
             if(!($Key.$App))
                  {
                   New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts' -Name "$App" -Value 1 -PropertyType DWORD
                   INSTALL
                  } 
          }

         else{
             New-Item -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts' -Force
             New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Intel\SCCM_APPRETRY_Attempts' -Name "$App" -Value 1 -PropertyType DWORD
             INSTALL
             }
     }
   }

#endregion ---> FUNCTIONS

##Script start 

##Call function to check APP_Attempts and install
     APP_Attempts_INSTALL -AppName $AppName