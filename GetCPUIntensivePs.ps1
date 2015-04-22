$path = split-path -parent $MyInvocation.MyCommand.Definition

$hostname = Read-Host 'enter Host Name'
$cred = Get-Credential 
$s = New-PSSession -computerName $hostname -credential $cred

$numberOfProcesses = 10

$p=Invoke-Command -Session $s -Scriptblock {
$CPUPercent = @{
  Name = 'CPUPercent'
  Expression = {
    $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
    [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
  }
}
$time=@{
Name='Timestamp'
Expression = {$(Get-Date -format F)}}

$ProcessList = Get-Process |  Select-Object -Property Name, $CPUPercent, $time | Sort-Object -Property CPUPercent -Descending | Select-Object -first 10

return $ProcessList 
} | Select * -ExcludeProperty RunspaceID, pscomputername, psshowcomputername

$filename=$path +"\" + "test.csv"

$p | Export-Csv  -path $filename  -NoTypeInformation

$filename=$path +"\" + "test.xml"

$p | Export-clixml  -path $filename  
Remove-PSSession $s


#json
$text='{"Objects":['
$rownum = 0
ForEach ($process in $p) {
Write-Output $Process

$text+='{"Name"'+ ':' + '"' + $Process.Name + '"' + ',' + '"CPU Consumption"' + ':' + '"' + $Process.CPUPercent + '"' + ',' + '"Time"' + ':' + '"' +$Process.Timestamp + '"}'
$rownum++
if($numberOfProcesses -ne $rownum){
$text+=','
}
}
$text+=']}'

$filename=$path +"\" + "test.json"
if(!(Test-Path -Path $filename))
  {
   $text | new-item -Path $filename -type "file" | Out-Null
  }
else
  {
   $text |  Out-File  $filename 
  }