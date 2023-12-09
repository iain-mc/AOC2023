function Get-Differences {
    param (
        [Parameter(Mandatory)]
        [bigint[]] $List
    )

    $Difference = [System.Collections.Generic.List[bigint]]::New()

    #Base Case: difference contains only zeros
    if ((($List | Select-Object -Unique).length -eq 1) -and (($List | Select-Object -Unique) -eq 0))
    {
        return
    }

    for ($i=1; $i -lt $List.Length; $i++)
    {
        $Difference += $List[$i] - $List[$i -1]
    }

    return $(Get-Differences -List $Difference) + ,$Difference
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$Total = 0

foreach ($Line in $InputFile)
{
    $List = [System.Collections.Generic.List[bigint]]::New()
    [bigint[]]$List = $Line -split '\s+'

    $a = Get-Differences -List $List
    $a +=  ,$List 

    $Next = 0 
    for ($i=1; $i -lt $a.Length; $i++)
    {
        $Next = $a[$i][$a[$i].length -1] + $Next
        Write-Host "$($a[$i]) - $Next"
    }

    $Total += $Next
}

$Total