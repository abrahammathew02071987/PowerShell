
[void][reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
$baseurl = "https://openknowledge.worldbank.org"
For ($i=1; $i -le 1; $i++) #length can be total length number of pages.
{
$url = "https://openknowledge.worldbank.org/discover?rpp=10&etal=0&group_by=none&page=$i"
$p = Invoke-WebRequest -Uri $url -UseBasicParsing
$page = $p.Links | where {$_.href -match "/handle"} | select href |
Sort-Object href |Get-Unique -AsString
$page | % {
$pages = $baseurl + $_.href

"---------------------------$pages-----------------------------"
$pages | % {
$Hrefpages = (Invoke-WebRequest -Uri $_ -UseBasicParsing ).links |
Where-Object outerhtml -Like '*pdf.png*' | select -ExpandProperty href
#$Hrefpages.count >> "C:\Users\amathe4x\Desktop\New folder\code.txt"
For ($i=1; $i -le $Hrefpages.count; $i++) {
$Hrefpages | % {
$pd = $baseurl + $_
Write-Output $pd
$file = "File" + $i + "-" + $pages.Split("/")[5]
Invoke-WebRequest -Uri $pd -UseBasicParsing -OutFile "C:\VM\New
folder\$file.pdf"


}
}
}

}
}