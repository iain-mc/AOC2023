function Test-ValidGame {
    param (
        [Parameter(Mandatory)]
        [string] $Game,
        [Parameter(Mandatory)]
        [Int] $Red,
        [Parameter(Mandatory)]
        [Int] $Green,
        [Parameter(Mandatory)]
        [Int] $Blue
    )
    
    $Cubes = @{'red' = 0; 'blue' = 0; 'green' = 0}

    foreach ($Draw in $Game -split ';')
    {
        $draw = $Draw.trim()
        foreach ($Colour in $Draw -split ',')
        {
            $Colour = $Colour.trim()
            $CubeNumber = [Int]$($Colour -split ' ')[0]
            $CubeColour = $($Colour -split ' ')[1]
            
            if($CubeNumber -gt $Cubes[$CubeColour]) 
            {
                $Cubes[$CubeColour] = $CubeNumber
            }

        }
    }

    if ($($Cubes['red'] -gt $Red) -or $($Cubes['blue'] -gt $Blue) -or $($Cubes['green'] -gt $Green))
    {
        return $False
    }

    return $True
}

$Input = Get-Content $PSScriptRoot\input.txt

$Total = 0

foreach ($Line in $Input)
{
    $GameID = $($($line -split ':')[0] -split ' ')[1]
    $Game = $($line -split ':')[1]


    if(Test-ValidGame $Game -Red 12 -Green 13 -Blue 14)
    {
        $Total += $GameID
    }
}

$Total