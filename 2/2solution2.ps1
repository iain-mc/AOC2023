function Get-MinimumCubes {
    param (
        [Parameter(Mandatory)]
        [string] $Game
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

    return $Cubes
}

$Input = Get-Content $PSScriptRoot\input.txt

$Total = 0

foreach ($Line in $Input)
{
    $Game = $($line -split ':')[1]

    $MinimumCubes = Get-MinimumCubes -Game $Game

    $Power = $MinimumCubes["red"] *  $MinimumCubes["green"] *  $MinimumCubes["blue"]

    $Total += $Power

}

$Total