function Get-Differences {
    param (
        [Parameter(Mandatory)]
        [bigint[]] $List
    )

    $Difference = @()
    $Differences = @()

    #Base Case: difference contains only zeros
    if ((($List | select -Unique).length -eq 1) -and (($List | select -Unique) -eq 0))
    {
        return
    }

    for ($i=1; $i -lt $List.Length; $i++)
    {
        $Difference += $List[$i] - $List[$i -1]
    }

    $Differences = $(Get-Differences -List $Difference)

    return $Differences + ,$Difference
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$Total = 0

foreach ($Line in $InputFile)
{
    $List = [System.Collections.Generic.List[bigint]]::New()
    [bigint[]]$List = $Line -split '\s+'

    $a = Get-Differences -List $List
    $a +=  ,$List 

    $next = 0 
    for ($i=1; $i -lt $a.Length; $i++)
    {
        $next = $a[$i][0] - $next
    }

    $total += $next
}

$Total
