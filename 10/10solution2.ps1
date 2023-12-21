function Get-StartPoint {
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix
    )
    
    for ($Y = 0; $Y -lt $($Matrix.Length); $Y++)
    {
        for ($X = 0; $X -lt $($Matrix[$Y].Length); $X++)
        {
            if ($Matrix[$Y][$X] -match "S")
            {
                return $Y,$X 
            }
        }
    }
}

function Get-NextStep {
    param (
        [Parameter(Mandatory)]
        [String] $Pipe,
        [Parameter(Mandatory)]
        [Object[]] $CurrentPos,
        [Parameter(Mandatory)]
        [Object[]] $PreviousPos
    )

    $Moves = @{
        "|" = @(@(-1,0) ,@(1,0));
        "-" = @(@(0,-1) ,@(0,1));
        "L" = @(@(-1,0) ,@(0,1));
        "J" = @(@(-1,0) ,@(0,-1));
        "7" = @(@(0,-1) ,@(1,0));
        "F" = @(@(0,1)  ,@(1,0));
        "." = @(@(0,0)  ,@(0,0));
        "S" = @(@(0,0)  ,@(0,0))
    }

    $PossibleSteps = $Moves[$Pipe]

    $NextStep = @($($CurrentPos[0] + $PossibleSteps[0][0]),$($CurrentPos[1] + $PossibleSteps[0][1]))

    if ($($NextStep[0] -eq $PreviousPos[0]) -and $($NextStep[1] -eq $PreviousPos[1]))
    {
        return @($($CurrentPos[0] + $PossibleSteps[1][0]),$($CurrentPos[1] + $PossibleSteps[1][1]))
    }

    return $NextStep
}

class Point : IEquatable[Object]
{
    [Int] $X
    [Int] $Y
    [String] $Type

    Point ([Int] $X, [Int] $y, [String] $Type)
    {
        $This.X     = $X
        $This.Y     = $Y
        $This.Type  = $Type
    }

    [Bool]
    Equals ([Object] $Other)
    {
        If ($($Other.X -eq $This.X) -and $($Other.Y -eq $This.Y))
        {
            return $True
        }
        return $False
    }

}

function Test-Enclosed {
    param (
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y,
        [Parameter(Mandatory)]
        [System.Array] $Route,
        [ref] $Scanned = [ref][System.Collections.Generic.List[Int[]]]::New()
    )

    $Scanned.value += [Point]::New($X,$Y, "")

    $Adjacent = Get-Adjacent -Matrix $Matrix -X $X -Y $Y

    #If it touches the perimeter, it's not enclosed
    if($($Adjacent.type).Contains('P'))
    {
        return $false
    }

    #If it touches non-route pipes, it's not enclosed
    foreach ($Pipe in $($Adjacent | ?{$_.Type -notmatch "[P\.]"}))
    {
        if(!$Route.Contains($Pipe))
        {
            return $False
        }
    }

    foreach ($Point in $($Adjacent | ?{$_.Type -match "[\.]"}))
    {
        if(($Scanned.value).Contains($Point)){continue}
        if(!$(Test-Enclosed -X $Point.X -Y $Point.Y -Scanned $Scanned -Route $Route))
        {
            return $false
        }
    }    

    return $True
}

function Get-AdjacentRecurse {
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix,
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y,
        [ref] $Adjacent = [ref][System.Collections.Generic.List[Int[]]]::New()
    )

    $Adjacent = Get-Adjacent -Matrix $Matrix -X $X -Y $Y
    
    foreach ($Point in $($Adjacent | ?{$_.Type -match "[\.]"}))
    {

    } 
}


function Get-Adjacent {
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix,
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y 
    )

    $Adjacent = [System.Collections.Generic.List[Point]]::New()
    #ABOVE (dont check if first row)
    if ($Y -ne 0)
    {
        $Adjacent += [Point]::New($($X   ),$($Y -1),$Matrix[$Y -1][$X]) 
         
        if ($X -ne 0)
        {
            $Adjacent += [Point]::New($($X -1),$($Y -1),$Matrix[$Y -1][$X -1])
        }
    
        if ($X -ne $($Matrix[$Y].Length -1))
        {
            $Adjacent += [Point]::New($($X +1),$($Y -1),$Matrix[$Y -1][$X +1])
        }
    }
    else 
    {
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
    }


    #BESIDE (don't check if end or begining of line)
    if ($X -ne 0)
    {
        $Adjacent  += [Point]::New($($X -1),$($Y),$Matrix[$Y][$X -1]) 
    }
    else 
    {
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
    }

    if ($X -ne $($Matrix[$Y].Length -1))
    {
        $Adjacent += [Point]::New($($X +1),$($Y),$Matrix[$Y][$X +1]) 
    }
    else 
    {
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
    }

    #BELOW (don't check if last row)
    if($Y -ne $($Matrix.Length -1))
    {
        $Adjacent += [Point]::New($($X   ),$($Y + 1),$Matrix[$Y +1][$x]) 
           
        if ($X -ne 0)
        {
            $Adjacent += [Point]::New($($X -1),$($Y + 1),$Matrix[$Y +1][$X -1]) 
        }
    
        if ($X -ne $($Matrix[$Y].Length -1))
        {
            $Adjacent += [Point]::New($($X +1),$($Y + 1),$Matrix[$Y +1][$X +1])
        }   
    }
    else 
    {
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
        $Adjacent += [Point]::New($null, $null, "P")
    }

    return $Adjacent
}

function Get-Route {
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix
    )
    $Start = Get-StartPoint -Matrix $Matrix

    $PreviousPosition = $Start
    $CurrentPosition = @($($Start[0]), $($Start[1] + 1))

    $Route = [System.Collections.Generic.List[Point]]::New()
    $Route += [Point]::New($Start[1], $Start[0], $Matrix[$Start[0]][$Start[1]])

    while ($true)
    {
        $Route += [Point]::New($CurrentPosition[1], $CurrentPosition[0], $Matrix[$CurrentPosition[0]][$CurrentPosition[1]])
        $NextPosition = Get-NextStep -Pipe $($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) -CurrentPos $CurrentPosition -PreviousPos $PreviousPosition
        $PreviousPosition = $CurrentPosition
        $CurrentPosition = $NextPosition 
        $Steps = $Steps + 1

        if ($($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) -eq 'S')
        {
            foreach ($line in $Matrix)
            {
                write-host $line
            }
            return $Route 
        }
    }
}

$InputFile = Get-Content $PSScriptRoot\Input.txt

$Matrix = [System.Collections.Generic.List[Char[]]]::New()
$InputFile | %{$Matrix += ,$_.ToCharArray()}

$Route = Get-Route -Matrix $Matrix   

foreach($Point in $Route)
{
     


}

return 



for ($Y = 0; $Y -lt $($Matrix.Length); $Y++)
{
    for ($X = 0; $X -lt $($Matrix[$Y].Length); $X++)
    {
        if ($Matrix[$Y][$X] -match "\.")
        {
            if (test-Enclosed -x $X -y $Y -Route $Route)
            {
                "$Y,$X - $($Matrix[$Y][$X])" 
            }
        }
    }
}

<# $PrintMatrix = [System.Collections.Generic.List[Char[]]]::New()

$InputFile | %{$Matrix += ,$_.ToCharArray();$PrintMatrix += ,$_.ToCharArray() }

$Steps = 1

$Start = Get-StartPoint -Matrix $Matrix

$PreviousPosition = $Start
$CurrentPosition = @($($Start[0] - 1), $($Start[1]))

$Route = [System.Collections.Generic.List[Point]]::New()
$Route += [Point]::New($Start[1], $Start[0], $Matrix[$Start[0]][$Start[1]])

while ($true)
{
    #write-host "$($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) - $($CurrentPosition[0]),$($CurrentPosition[1])"
    $Route += [Point]::New($CurrentPosition[1], $CurrentPosition[0], $Matrix[$CurrentPosition[0]][$CurrentPosition[1]])
    $PrintMatrix[$CurrentPosition[0]][$CurrentPosition[1]] = 'x'
    $NextPosition = Get-NextStep -Pipe $($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) -CurrentPos $CurrentPosition -PreviousPos $PreviousPosition
    $PreviousPosition = $CurrentPosition
    $CurrentPosition = $NextPosition 
    $Steps = $Steps + 1


    if ($($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) -eq 'S')
    {
        foreach ($line in $printmatrix)
        {
            write-host $line
        }
        Write-Host "TOTAL = $($Steps/2)"
        Test-Enclosed -x 1 -y 1 -Route $Route
        return 
    }

}



#Get-NextStep -Pipe 'F' -CurrentPos @(0,2) -PreviousPos (1,2)
 #>