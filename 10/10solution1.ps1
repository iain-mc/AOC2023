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

$InputFile = Get-Content $PSScriptRoot\Input.txt

$Matrix = [System.Collections.Generic.List[Char[]]]::New()

$InputFile | %{$Matrix += ,$_.ToCharArray()}

$Steps = 1

$Start = Get-StartPoint -Matrix $Matrix

$PreviousPosition = $Start
$CurrentPosition = @($($Start[0] - 1), $($Start[1]))

while ($true)
{
    write-host "$($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) - $($CurrentPosition[0]),$($CurrentPosition[1])"

    $NextPosition = Get-NextStep -Pipe $($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) -CurrentPos $CurrentPosition -PreviousPos $PreviousPosition
    $PreviousPosition = $CurrentPosition
    $CurrentPosition = $NextPosition 
    $Steps = $Steps + 1


    if ($($Matrix[$CurrentPosition[0]][$CurrentPosition[1]]) -eq 'S')
    {
        Write-Host "TOTAL = $($Steps/2)"
        return 
    }
}



#Get-NextStep -Pipe 'F' -CurrentPos @(0,2) -PreviousPos (1,2)
