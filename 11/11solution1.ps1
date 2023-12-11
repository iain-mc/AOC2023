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

$GalaxyN = 1

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

#Expand Rows 
for($i=0; $i -lt $Universe.Length; $i++)
{
    if(!$($Universe[$i] | Measure-Object -Sum).sum)
    {
        $Universe = $Universe[0..$i] + $Universe[$i..($Universe.Length -1)]
        $i = $i + 2
    }
}

#Find Which Cols to Expand  
$RowLength = $Universe[0].Length
$ColsToExp = @()
for($C=0; $C -lt $RowLength; $C++)
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

#Expand the columns using a temp universe 
$NewUniverse = [System.Collections.Generic.List[Int[]]]::New()
foreach($Row in $Universe)
{
    $NewRow = [System.Collections.Generic.List[Int]]::New()
    for($i=0; $i -lt $Row.Length; $i++)
    {
        $NewRow += $Row[$i]
        if($ColsToExp.Contains($i))
        {
            $NewRow += $Row[$i]
        }
    }
    $NewUniverse += ,$NewRow
}

$Universe = $NewUniverse

$Total = 0 
$pairs = 0

for($R=0; $R -lt $Universe.Length; $R++)
{
    for($C=0; $C -lt $Universe[$R].Length; $C++)
    {
        if($Universe[$R][$C])
        {
            $StartCol = $C + 1
            for($NR=$R; $NR -lt $Universe.Length; $NR++)
            {
                for($NC=$StartCol; $NC -lt $Universe[$NR].Length; $NC++)
                {
                    if($Universe[$NR][$NC])
                    {
                        $pairs++
                        $Total += $(Get-Distance -SrcX $C -SrcY $R -DstX $NC -DstY $NR) 
                    }
                }
                $StartCol = 0 
            }
        }
    }
}

$Total