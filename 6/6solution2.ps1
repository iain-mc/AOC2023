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
$Time      = ($Input[0] -split ':')[1].trim() -replace '\s+'
$Distance  = ($Input[1] -split ':')[1].trim() -replace '\s+'

Get-WinCount -Time $Time -Distance $Distance