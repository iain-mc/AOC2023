function Measure-Matrix 
{
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix, 
        [Parameter(Mandatory)]
        [Int] $StartY, 
        [Parameter(Mandatory)]
        [Int] $StartX,
        [Parameter(Mandatory)]
        [Char] $Direction 
    )

    $Steps = @()
    $Type = $Matrix[$StartY][$StartX]
    $CurrentPosition = @($StartY, $StartX)

    While($True)
    {
        $Steps += "$($CurrentPosition[0])$($CurrentPosition[1])-$Direction" 

        $NextPositions = Get-NextStep -Direction $Direction -Y $CurrentPosition[0] -X $CurrentPosition[1] -Type $Type
        $Direction = Get-NewDirection -PreviousY $CurrentPosition[0] -PreviousX $CurrentPosition[1] -NewY $NextPositions[0][0] -NewX $NextPositions[0][1]

        if($NextPositions[1])
        {   
            $NewDirection = Get-NewDirection -PreviousY $CurrentPosition[0] -PreviousX $CurrentPosition[1] -NewY $NextPositions[1][0] -NewX $NextPositions[1][1]
            if($Steps.contains("$($NextPositions[1][0])$($NextPositions[1][1])-$NewDirection")){
                return $Steps
            }

            if(($NextPositions[1][0] -ge 0) -and ($NextPositions[1][0] -lt $Matrix.Length))
            {
                if(($NextPositions[1][1] -ge 0) -and ($NextPositions[1][1] -lt $Matrix[0].Length))
                {
                    $Steps += Measure-Matrix -Matrix $Matrix -StartY $NextPositions[1][0] -StartX $NextPositions[1][1] -Direction $NewDirection
                }
            } 
        }

        if($Steps.contains("$($NextPositions[0][0])$($NextPositions[0][1])-$Direction"))
        {
            return $Steps
        }

        if(($NextPositions[0][0] -lt 0) -or ($NextPositions[0][0] -ge $Matrix.Length))
        {
            return ,$Steps
        }

        if(($NextPositions[0][1] -lt 0) -or ($NextPositions[0][1] -ge $Matrix[0].Length))
        {
            return ,$Steps
        }

        If($Steps.Length -gt 100)
        {
            return ,$Steps
        }

        $CurrentPosition = $NextPositions[0]
        $Type = $Matrix[$CurrentPosition[0]][$CurrentPosition[1]]
    }
}

function Get-NextStep 
{
    param (
        [Parameter(Mandatory)]
        [Int] $X, 
        [Parameter(Mandatory)]
        [Int] $Y,
        [Parameter(Mandatory)]
        [Char] $Direction,
        [Parameter(Mandatory)]
        [Char] $Type
    )

    $Positions = [System.Collections.Generic.List[Int[]]]::New()
    
    if($Direction -eq 'N')
    {
        switch ($Type) 
        {
            '-' { $Positions += ,@($Y, $($X +1)); $Positions += ,@($Y, $($X - 1)) }   
            '|' { $Positions += ,@($($Y -1), $X) }
            '\' { $Positions += ,@($Y, $($X -1)) }
            '/' { $Positions += ,@($Y, $($X +1)) }
            '.' { $Positions += ,@($($Y -1), $X) }
        }
    }

    if($Direction -eq 'S')
    {
        switch ($Type) 
        {
            '-' { $Positions += ,@($Y, $($X +1)); $Positions += ,@($Y, $($X -1)) }   
            '|' { $Positions += ,@($($Y +1), $X) }
            '\' { $Positions += ,@($Y, $($X +1)) }
            '/' { $Positions += ,@($Y, $($X -1)) }
            '.' { $Positions += ,@($($Y +1), $X) }
        }
    }

    if($Direction -eq 'E')
    {
        switch ($Type) 
        {
            '-' { $Positions += ,@($Y, $($X +1))}   
            '|' { $Positions += ,@($($Y -1), $X); $Positions += ,@($($Y +1), $X) }
            '\' { $Positions += ,@($($Y +1), $X) }
            '/' { $Positions += ,@($($Y -1), $X) }
            '.' { $Positions += ,@($Y, $($X +1)) }
        }
    }

    if($Direction -eq 'W')
    {
        switch ($Type) 
        {
            '-' { $Positions += ,@($Y, $($X -1)) }   
            '|' { $Positions += ,@($($Y -1), $X); $Positions += ,@($($Y +1), $X) }
            '\' { $Positions += ,@($($Y -1), $X) }
            '/' { $Positions += ,@($($Y +1), $X) }
            '.' { $Positions += ,@($Y, $($X -1)) }
        }
    }
    
    return ,$Positions
}

function Get-NewDirection {
    param (
        [Int] $PreviousY, 
        [Parameter(Mandatory)]
        [Int] $PreviousX, 
        [Int] $NewY, 
        [Parameter(Mandatory)]
        [Int] $NewX
     )

     if($NewY -gt $PreviousY)
     {
        Return 'S'
     }

     if($NewY -lt $PreviousY)
     {
        Return 'N'
     }

     if($NewX -lt $PreviousX)
     {
        Return 'W'
     }
    
     if($NewX -gt $PreviousX)
     {
        Return 'E'
     }
}

$InputFile = Get-Content $PSScriptRoot\TestInput.txt
$Matrix = [System.Collections.Generic.List[String]]::New()
$InputFile | %{$Matrix += $_}
$Matrix[0]
$Direction = "R"

(Measure-Matrix -Matrix $Matrix -StartY 0 -StartX 0 -Direction 'E')
