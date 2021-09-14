$n = Get-ComputerInfo | select cscaption
[BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi
-ComputerName $n.CsCaption).PowerOnLine