$status = $false
if( Get-NetAdapter -Interfacedescription "Cisco AnyConnect*" | ? Status -eq Up)
{
    $status = $false
}else
{
    if(Get-NetConnectionProfile -Name "*intel.com")
    {
        $status = $true
    }
    else{
        $status = $false
    }
}

$status 
