$nums = @(1,2,3,4,5)

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
$CurrentElement = "AAA"
$i = 0; 
while ($true)
{
    $total = $total + 1
    $Instruction = $Instructions[$i]
    $CurrentElement = $Nodes[$CurrentElement]["$Instruction"]

    if ($CurrentElement -eq "ZZZ")
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