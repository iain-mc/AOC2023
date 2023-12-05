function Get-Number {
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix,
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y 
    )

     #track back to find start of number or line
     while (($X -gt 0) -and ($Matrix[$Y][$X -1] -match "\d"))
     {
         $X--
     }
     $Start = $X

     #track forwards to find end of number or line 
     while (($X -lt ($Matrix[$Y].Length -1)) -and ($Matrix[$Y][$X +1] -match "\d"))
     {
         $X++
     }
     $End = $X

     #save the number 
     $Number = -join $Matrix[$Y][$Start..$End]

     return @([Int]$Number, $End) 
}

function Test-NumberAdjacet {
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix,
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y 
    )

    $NumAdjacent = 0 
    $Gears += @()
    
    #ABOVE (dont check if first row)
    if ($Y -ne 0)
    {
        foreach ($increment in -1..1)
        {
            if ($Matrix[$($Y - 1)][$X + $Increment] -match "\d") 
            {
                $ret = $(Get-Number -Matrix $Matrix -Y $($Y -1) -X $($X + $Increment))
                $Gears += $ret[0]
                $End = $ret[1]

                if($End -ge $X)
                {
                    break
                }
            }
      }
    }

    #BESIDE (don't check if end or begining of line)
    if ($X -ne 0)
    {
        if ($Matrix[$($Y   )][$X -1] -match "\d") { $Gears += $(Get-Number -Matrix $Matrix -Y $($Y   ) -X $($X -1))[0] }
    }

    if ($X -ne $($Matrix[$Y].Length -1))
    {
        if ($Matrix[$($Y   )][$X +1] -match "\d") { $Gears += $(Get-Number -Matrix $Matrix -Y $($Y  ) -X $($X +1))[0] }
    }

    #BELOW (don't check if last row)
    if ($Y -ne $($Matrix.Length -1))
    {
        foreach ($increment in -1..1)
        {
            if ($Matrix[$($Y + 1)][$X + $Increment] -match "\d") 
            {
                $ret = $(Get-Number -Matrix $Matrix -Y $($Y +1) -X $($X + $Increment))
                $Gears += $ret[0]
                $End = $ret[1]

                if($End -ge $X)
                {
                    break
                }
            }
      }
    }

    if($Gears.length -eq 2)
    {
        return $($gears[0]) * $($gears[1])
    }

    return 0 
}

function Test-SymbolAdjacet {
    param (
        [Parameter(Mandatory)]
        [System.Array] $Matrix,
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y, 
        [String] $Symbols = "*&@/+#$%=-"
    )

    #ABOVE (dont check if first row)
    if ($Y -ne 0)
    {
        if ($Matrix[$($Y - 1)][$X -1] -match "[$Symbols]") { return $true }
        if ($Matrix[$($Y - 1)][$X   ] -match "[$Symbols]") { return $true }
        if ($Matrix[$($Y - 1)][$X +1] -match "[$Symbols]") { return $true }
    }

    #BESIDE (don't check if end or begining of line)
    if ($X -ne 0)
    {
        if ($Matrix[$($Y   )][$X -1] -match "[$Symbols]") { return $true }
    }

    if ($X -ne $($Matrix[$Y].Length -1))
    {
        if ($Matrix[$($Y   )][$X +1] -match "[$Symbols]") { return $true }
    }

    #BELOW (don't check if last row)
    if($Y -ne $($Matrix.Length -1))
    {
        if ($Matrix[$($Y + 1)][$X -1] -match "[$Symbols]") { return $true }
        if ($Matrix[$($Y + 1)][$X   ] -match "[$Symbols]") { return $true }
        if ($Matrix[$($Y + 1)][$X +1] -match "[$Symbols]") { return $true }        
    }

    return $False
}


$Input = Get-Content $PSScriptRoot\input.txt

$Symbols = $Input.ToCharArray() | ?{$_ -notmatch '[\d\.]' } | select -Unique | Join-String

$Matrix = [System.Collections.Generic.List[Char[]]]::New()

$Input | %{$Matrix += ,$_.ToCharArray()}

$total = 0

for ($Y = 0; $Y -lt $($Matrix.Length); $Y++)
{
    for ($X = 0; $X -lt $($Matrix[$Y].Length); $X++)
    {
        if ($Matrix[$Y][$X] -notmatch "[$Symbols]")
        {
            continue 
        }

        $total += Test-NumberAdjacet -Matrix $Matrix -Y $Y -X $X
    }
}

$total