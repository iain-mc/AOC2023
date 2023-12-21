function Test-ReflectionRow
{
    param (
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[String]] $Matrix,
        [Parameter(Mandatory)]
        [Int] $A,
        [Parameter(Mandatory)]
        [Int] $B
    )
    
    #Base Case 
    if(($A -lt 0) -or ($B -ge ($Matrix.Count)))
    {
        return $True
    }

    if($Matrix[$A] -eq $Matrix[$B])
    {
        return Test-ReflectionRow -Matrix $Matrix -A $($A -1) -B $($B +1)
    }

    return $False
}

function Test-ReflectionCol
{
    param (
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[String]] $Matrix,
        [Parameter(Mandatory)]
        [Int] $A,
        [Parameter(Mandatory)]
        [Int] $B
    )
    
    [string]$ColA = $Matrix | %{$_[$A]}
    [string]$ColB = $Matrix | %{$_[$B]}

    #Base Case 
    if(($A -lt 0) -or ($B -ge ($Matrix[0].Length)))
    {
        return $True
    }

    if($ColA -eq $ColB)
    {
        return Test-ReflectionCol -Matrix $Matrix -A $($A -1) -B $($B +1)
    }

    return $False
}

$InputFile = Get-Content $PSScriptRoot\Input.txt

$Matrices  = [System.Collections.Generic.List[Object[]]]::New()
$Matrices += ,[System.Collections.Generic.List[String]]::New()

$M = 0 
foreach ($Line in $InputFile)
{
    if($Line)
    {
        $Matrices[$M] += $Line
    }
    else 
    {
        $Matrices += ,[System.Collections.Generic.List[String]]::New()
        $M++
    }

}

$Total = 0 
$MT = 0 

foreach ($Matrix in $Matrices)
{  
    
    for($i=0; $i -lt $Matrix.Count -1; $i = $i +1)
    {
        if(Test-ReflectionRow -Matrix $Matrix -A $i -B $($i +1))
        {
            $RefRow = $i + 1
            $Total = $total + $(100 * ($RefRow))
            break
        }

        $RefRow = 0
    }

    for($i=0; $i -lt $Matrix[0].Length -1; $i = $i +1)
    {
        if(Test-ReflectionCol -Matrix $Matrix -A $i -B $($i +1))
        {
            $RefCol = $i + 1
            $Total = $Total + $RefCol
            break
        }

        $RefCol = 0
    }
    $MT++
}

$Total