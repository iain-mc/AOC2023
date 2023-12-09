 #Get-NextValue
    #Base Case = all zeros : return 0 else return Get-Nex

#Get-Differences
    #Base Case = all zeros : return $Differences else; $Differnces += Get-Differneces($input)


function Get-Differences {
    param (
        [Parameter(Mandatory)]
        [bigint[]] $List
    )

    $Difference = @()# [System.Collections.Generic.List[bigint]]::New()
    $Differences = @()#[System.Collections.Generic.List[bigint[]]]::New()

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
        $next = $a[$i][$a[$i].length -1] + $next
        Write-Host "$($a[$i]) - $next"
    }
    $total += $next

}

