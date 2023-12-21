function Get-Distance {
    param (
        [Parameter(Mandatory)]
        [Int] $SrcX,
        [Parameter(Mandatory)]
        [Int] $SrcY,
        [Parameter(Mandatory)]
        [Int] $DstX,
        [Parameter(Mandatory)]
        [Int] $DstY
    )

    return [System.Math]::Abs($SrcX -$DstX) + [System.Math]::Abs($SrcY - $DstY)
    
}

$InputFile = Get-Content $PSScriptRoot\Input.txt

$Universe = [System.Collections.Generic.List[Int[]]]::New()

#Generate the Universe Matrix 
foreach ($Line in $InputFile)
{   
    $Row = [System.Collections.Generic.List[Int]]::New()
    foreach ($Char in ($Line.ToCharArray()))
    {
        if($Char -eq '.'){ $Row += 0 }
        if($Char -eq '#'){ $Row += 1 } #$GalaxyN++}
    }
    $Universe += ,$Row
}

#Find which Rows to Expand 
$RowsToExp = @()

for($i=0; $i -lt $Universe.Length; $i++)
{
    if(!$($Universe[$i] | Measure-Object -Sum).sum)
    {
        $RowsToExp += $i
    }
}

#Find Which Cols to Expand  
$ColsToExp = @()

for($C=0; $C -lt $Universe[$C].Length; $C++)
{
    $Sum = 0 

    for($R=0; $R -lt $Universe.Length; $R++) 
    {
        $Sum = $Sum + $Universe[$R][$C]    
    }

    if(!$Sum)
    { 
        $ColsToExp += $C
    }
}
 
$Galaxies = @()
$ExpFactor = 1000000
$ExpFactor--

for($R=0; $R -lt $Universe.Length; $R++)
{
    for($C=0; $C -lt $Universe[$R].length; $C++)
    {
        if($Universe[$R][$C])
        {
            $ExpC = ($ColsToExp | ?{$_ -lt $C}).length
            $ExpR = ($RowsToExp | ?{$_ -lt $R}).length
            $X = $C + ($ExpC * $ExpFactor)
            $Y = $R + ($ExpR * $ExpFactor)
            $Galaxies += ,@($x,$y)
        }
    }   
}

$Total = 0 
$pairs = 0

for($g=0; $g -lt $Galaxies.Length; $g++)
{
    for($gn=($g+1); $gn -lt $Galaxies.Length; $gn++)
    {
        $Total += $(Get-Distance -SrcX $Galaxies[$g][0] -SrcY $Galaxies[$g][1] -DstX $Galaxies[$gn][0] -DstY $Galaxies[$gn][1]) 
    }
}

$Total