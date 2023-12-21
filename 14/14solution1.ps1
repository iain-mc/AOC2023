function Sort-Col {
    param (
        [Parameter(Mandatory)]
        [string] $Col
    )
    
    for($i=0; $i -lt $Col.Length; $i++)
    {
        $c = $i
        if($Col[$i] -eq "O")
        {
            for($n=$i-1; $n -ge 0; $n--)
            {
                if($Col[$n] -match "[O|#]")
                {
                    break
                }
                if($Col[$n] -eq ".")
                {
                    if($n -eq 0)
                    {
                        $Col = $($Col[$c] + $Col[$n] + (-join $Col[($c+1)..$($Col.Length -1)]))
                    }
                    elseif ($c -eq $Col.Length -1) 
                    {
                        $Col = (-join $Col[0..$($n-1)]) + $Col[$c] + $Col[$n]
                    }
                    else 
                    {
                        $Col = (-join $Col[0..$($n-1)]) + $Col[$c] + $Col[$n] + (-join $Col[$($c+1)..$($Col.Length -1)])
                    }
                    $c = $n
                }  
            }
        }
    }

    return $Col
}

function Get-ColWeight {
    param (
        [Parameter(Mandatory)]
        [string] $Col
    )

    $Weight = 0
    
    for($i=0; $i -lt $Col.Length; $i++)
    {
        if($Col[$i] -eq "O")
        {
            $Weight += $Col.Length -$i 
        }
    }

    return $Weight
}

$InputFile = Get-Content $PSScriptRoot\TestInput.txt

$Matrix = [System.Collections.Generic.List[String]]::New()

foreach ($Line in $InputFile)
{
    $Matrix += $Line
}

$Weight = 0
for($i=0; $i -lt $Matrix[0].Length; $i++)
{
    $Column = -join ($Matrix | %{$_[$i]})
    $SortedColum = Sort-Col -Col $Column
    $Weight += Get-ColWeight -Col $SortedColum 
}

$Weight
