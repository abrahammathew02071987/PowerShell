@echo off
:: Minimize the command prompt
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Unrestricted -file "%~dp0AP_WirelessDriver_21.10.1.2.R101.ps1" %1 %2



EXIT