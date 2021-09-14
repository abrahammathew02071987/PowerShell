$source = "C:\temp\ab"

$a= Get-Childitem  -path $source

$destination = "C:\temp\ab1"

  foreach($x in $a)  {
  try {

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::CreateFromDirectory($Source + "\" + $x,$destination + "\" + $x + ".zip") 

}
catch {
$_.error
}
}