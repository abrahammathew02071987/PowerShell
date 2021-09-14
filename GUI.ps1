function Test-PsRemoting
{
    param(
        [Parameter(Mandatory = $true)]
        $computername
    )
   
    try
    {
        $errorActionPreference = "Stop"
        $result = Invoke-Command -ComputerName $computername { 1 }
    }
    catch
    {
        Write-Verbose $_
        return $false
    }
   
    ## I've never seen this happen, but if you want to be
    ## thorough....
    if($result -ne 1)
    {
        Write-Verbose "Remoting to $computerName returned an unexpected result."
        return $false
    }
   
    $true   
}

Function check-validity
{
$startDate=(Get-Date)
If($startDate.Year -gt 2020){
$outhost="Script Expired: Validity is till 2020" | Out-Host
Exit(0)
}
$systemdirectory = Get-ChildItem 'C:\Program Files' | foreach { $_.LastWriteTime.Year -gt 2020} 
$systemdirectory | ForEach-Object {
If($_ -eq "True"){
$outhost="Script Expired: Validity is till 2020" | Out-Host
Exit(0)
}
}
}
check-validity














#---------------------------------------------------PowerShell GUI----------------------------------------------------------
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::OK
$MessageboxTitle = “Client Status”
$Messageboxbody = “Machine is Online.”
$Messageboxbody1 = “Machine is Offline.”
$MessageIcon = [System.Windows.MessageBoxImage]::Error
$MessageIcon1 = [System.Windows.MessageBoxImage]::Information

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Client Machine Configuration Reporting Tool                                                         by Abraham Mathew"
$objForm.Size = New-Object System.Drawing.Size(1100,650) 
$objForm.StartPosition = "CenterScreen"


$objForm.BackgroundImageLayout = "Zoom"
    # None, Tile, Center, Stretch, Zoom

$Font = New-Object System.Drawing.Font("Times New Roman",16,[System.Drawing.FontStyle]::Regular)
    # Font styles are: Regular, Bold, Italic, Underline, Strikeout
    
$objForm.Font = $Font


$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(300,500)
$OKButton.Size = New-Object System.Drawing.Size(110,30)
$LabelFont = New-Object System.Drawing.Font("Times New Roman",14,[System.Drawing.FontStyle]::Regular) 
$OKButton.Text = "Ok"
$OKButton.font = $LabelFont
#$OKButton.Add_Click({$VendorFolderLocation=$objTextBox.Text;$ConsoleFolder=$objTextBox1.Text;$SiteServer=$objTextBox2.Text;$objForm.Close()})
$OKButton.Add_Click({

    $objForm.Close()
    
    })
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(420,500)
$CancelButton.Size = New-Object System.Drawing.Size(110,30)
$LabelFont = New-Object System.Drawing.Font("Times New Roman",14,[System.Drawing.FontStyle]::Regular) 
$CancelButton.Text = "Cancel"
$CancelButton.font = $LabelFont
$CancelButton.Add_Click({$objForm.Close(); $cancel = $true })
$objForm.Controls.Add($CancelButton)

#-----------------------------------------test button---------------------------------------------------------------

$TestButton = New-Object System.Windows.Forms.Button
$TestButton.Location = New-Object System.Drawing.Size(700,100)
$TestButton.Size = New-Object System.Drawing.Size(110,30)
$LabelFont = New-Object System.Drawing.Font("Times New Roman",14,[System.Drawing.FontStyle]::Regular) 
$TestButton.Text = "Test"
$TestButton.font = $LabelFont
#$TestButton.Add_Click({$VendorFolderLocation=$objTextBox.Text;$ConsoleFolder=$objTextBox1.Text;$SiteServer=$objTextBox2.Text;$objForm.Close()})
$TestButton.Add_Click({
    If($objTextBox.Text.Length -gt 0) # Valid
    {
        $ClientName=$objTextBox.Text
        $client_status = Test-PsRemoting $ClientName
        If($client_status)
        {
            $result=[System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$messageicon1)
        }else
        {
            $result=[System.Windows.MessageBox]::Show($Messageboxbody1,$MessageboxTitle,$ButtonType,$messageicon)
        }
    }
    Else # Invalid
    {
             [windows.forms.messagebox]::show($objLabel1.Text,"Enter Input")
    }
    
    
    })
$objForm.Controls.Add($TestButton)

$objLabel = New-Object System.Windows.Forms.Label
$LabelFont = New-Object System.Drawing.Font("Times New Roman",20,[System.Drawing.FontStyle]::Bold)
$objLabel.Location = New-Object System.Drawing.Size(100,30)
$objLabel.Size = New-Object System.Drawing.Size(630,40) 
$objLabel.Text = "Please enter the input to the form"
$objLabel.font = $LabelFont


$objForm.Controls.Add($objLabel) 

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(400,100) 
$objTextBox.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBox)

#$objLabel = New-Object System.Windows.Forms.Label
#$objLabel.Location = New-Object System.Drawing.Size(300,205) 
#$objLabel.Size = New-Object System.Drawing.Size(400,40)
#$LabelFont = New-Object System.Drawing.Font("Times New Roman",12,[System.Drawing.FontStyle]::Regular) 
#$objLabel.Text = "Registry Path"
#$objForm.Controls.Add($objLabel) 
#$objLabel.font = $LabelFont 

$objLabel3 = New-Object System.Windows.Forms.Label
$objLabel3.Location = New-Object System.Drawing.Size(100,100) 
$objLabel3.Size = New-Object System.Drawing.Size(280,40) 
$LabelFont = New-Object System.Drawing.Font("Times New Roman",14,[System.Drawing.FontStyle]::Regular) 
$objLabel3.Text = "Computer Name"
$objLabel3.font = $LabelFont
$objForm.Controls.Add($objLabel3) 




$objTextBox2 = New-Object System.Windows.Forms.TextBox 
$objTextBox2.Location = New-Object System.Drawing.Size(400,175) 
$objTextBox2.Size = New-Object System.Drawing.Size(500,20) 
$objForm.Controls.Add($objTextBox2)



$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(100,175) 
$objLabel2.Size = New-Object System.Drawing.Size(250,40) 
$LabelFont = New-Object System.Drawing.Font("Times New Roman",14,[System.Drawing.FontStyle]::Regular) 
$objLabel2.Text = "Log FilePath"
$objForm.Controls.Add($objLabel2)
$objLabel2.font = $LabelFont



$objTextBox4 = New-Object System.Windows.Forms.TextBox 
$objTextBox4.Location = New-Object System.Drawing.Size(400,250) 
$objTextBox4.Size = New-Object System.Drawing.Size(500,20) 
$objForm.Controls.Add($objTextBox4)

#--------------------------Registry Path--------------------------------------------------------------

$objLabel5 = New-Object System.Windows.Forms.Label
$objLabel5.Location = New-Object System.Drawing.Size(100,325) 
$objLabel5.Size = New-Object System.Drawing.Size(250,40) 
$LabelFont = New-Object System.Drawing.Font("Times New Roman",14,[System.Drawing.FontStyle]::Regular) 
$objLabel5.Text = "Registry Path"
$objForm.Controls.Add($objLabel5)
$objLabel5.font = $LabelFont

$objTextBox3 = New-Object System.Windows.Forms.TextBox 
$objTextBox3.Location = New-Object System.Drawing.Size(400,400) 
$objTextBox3.Size = New-Object System.Drawing.Size(500,20) 
$objForm.Controls.Add($objTextBox3)

$radioButton1 = New-Object system.windows.Forms.RadioButton 
$radioButton1.Text = "HKLM"
$radioButton1.AutoSize = $true
$radioButton1.Width = 104
$radioButton1.Height = 20
$radioButton1.location = new-object system.drawing.point(400,325)
$radioButton1.Font = "Microsoft Sans Serif,10"
$objForm.controls.Add($radioButton1)

$radioButton2 = New-Object system.windows.Forms.RadioButton 
$radioButton2.Text = "HKCU"
$radioButton2.AutoSize = $true
$radioButton2.Width = 104
$radioButton2.Height = 20
$radioButton2.location = new-object system.drawing.point(500,325)
$radioButton2.Font = "Microsoft Sans Serif,10"
$objForm.controls.Add($radioButton2)

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()

#---------------------------------------------------
$Clientname=$objTextBox.Text
$Logpath=$objTextBox2.Text
$DestinationPath=$objTextBox4.Text
$RegistryPath=$objTextBox3.Text
$NewLogfileName = $Clientname + ".log"
$NewLogfile = "c:\temp\" + $NewLogfileName
if($DestinationPath){
$NewLogfile = $DestinationPath + "\" + $NewLogfileName
}
    

Write-Host $Clientname
Write-Host $Logpath
Write-Host $DestinationPath
Write-Host $RegistryPath


If($Clientname -ne $null) {
$Clientname | Out-File $NewLogfile -Append
$session = New-PSSession -ComputerName $Clientname
if($Logpath){
$L = Invoke-Command -Session $session -ScriptBlock{Get-Content -Path $($using:Logpath) }
$L | Out-File $NewLogfile -Append
}
if($RegistryPath){
if($radioButton1.Checked -eq "True"){
$reg =  "HKLM:" + "\" + $RegistryPath
$R = Invoke-Command -Session $session -ScriptBlock{ Get-ItemProperty $($using:reg)  }
$R | Out-File $NewLogfile -Append
}else {
$reg =  "HKCU:" + "\" + $RegistryPath
$cred = Get-Credential
$R = Invoke-Command -ComputerName $Clientname -Credential $cred -ScriptBlock {Test-Path -Path $($using:reg) ; Get-ItemProperty $($using:reg)}
$R | Out-File $NewLogfile -Append
}


}
}

