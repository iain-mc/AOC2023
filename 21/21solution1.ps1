function Get-Adjacent
{
    param (
        [Parameter(Mandatory)]
        [Int[]] $Point,        
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[String]] $Matrix
    )
    
    $Box = @(
        @(-1, 0),
        @( 0,-1),
        @( 0, 1),
        @( 1, 0)
    )
    
    $Adjacent = [System.Collections.Generic.List[Int[]]]::New()

    foreach($B in $Box)
    {
        $Y = $($Point[0] + $B[0])
        $X = $($Point[1] + $B[1])

        if($Matrix[$Y][$X] -match "\.|S")
        {
            $Adjacent += ,@($Y, $X)
        }
    }

    return ,$Adjacent
}

$InputFile = Get-Content $PSScriptRoot\Input.txt
$Matrix = [System.Collections.Generic.List[String]]::New()

$I, $Y, $X = 0 
foreach($Line in $InputFile)
{
    $Matrix += $Line
    if($Line.Contains('S'))
    {
        $X = $Line.IndexOf('S')
        $Y = $I
    }
    else 
    {
        $I++
    }
}

$Steps = 64

$StartPoints  = [System.Collections.Generic.List[Int[]]]::New()
$StartPoints += ,@($Y, $X)

$NextPoints   = [System.Collections.Generic.List[Int[]]]::New()

foreach ($i in 1..$Steps)
{
    foreach ($Point in $StartPoints)
    {
        $NextPoints += Get-Adjacent -Point $Point -Matrix $Matrix
    }

    $StartPoints = $NextPoints | Select-Object -Unique
    $NextPoints = [System.Collections.Generic.List[Int[]]]::New()

    Write-Host "STEP: $i -- $($StartPoints.Length)"
}

$Adjacent = Get-Adjacent $Start $Matrix