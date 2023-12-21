$InputFile = Get-Content $PSScriptRoot\input.txt

$Instructions = ($InputFile[0]).ToCharArray()

$Nodes = @{}

foreach ($Line in $InputFile[2..($InputFile.Length -1)])
{
    $Element = ($Line -split "=")[0].Trim()
    $Left, $Right = (($Line -split "=")[1].trim() -replace "[(),]") -split '\s+'

    $Nodes[$Element] = @{"R" = $Right; "L" = $Left}
}

$total = 0 
$CurrentElements = $CurrentElements = [System.Collections.Generic.List[String]]::New()
$CurrentElements = $Nodes.Keys | Where-Object {$_ -Match "[0-9A-Z]{2}A"}
$i = 0; 

while ($true)
{
    $total = $total + 1
    $Instruction = $Instructions[$i]
    
    $NextElements = @()

    foreach ($Element in $CurrentElements)
    {
        $NextElements += $Nodes[$Element]["$Instruction"]
    }

    $CurrentElements = $NextElements
    $done = $true
    $CurrentElementS | %{if($_ -match "[0-9A-Z]{2}[0-9A-Y]"){$done = $false}}

    if ($done)
    {
        $total 
        return 
    }

    $i = $i + 1
   
    if(($i % $Instructions.Length) -eq 0)
    {
        $i = 0 
    }

}