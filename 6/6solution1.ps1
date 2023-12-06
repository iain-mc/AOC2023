function Get-WinCount {
    param (
        [Parameter(Mandatory)]
        [Int64] $Time,
        [Parameter(Mandatory)]
        [Int64] $Distance
        )
    
    $Wins = 0 

    for ($i=1; $i -lt $Time; $i++)
    {
        if (($i * ($Time - $i)) -gt $Distance)
        {
            $Wins++
        }
    }

    return $Wins
}

$Input      = Get-Content $PSScriptRoot\input.txt
$Times      = ($Input[0] -split ':')[1].trim() -split '\s+'
$Distances  = ($Input[1] -split ':')[1].trim() -split '\s+'

$Total = 1 #Assuming there is at least one win, should add a check 

for ($i=0; $i -lt $Times.Length; $i++)
{
    $Total = $Total * $(Get-WinCount -Time $Times[$i] -Distance $Distances[$i]) 
}

$Total