function Get-StringHash {
    param (
        [Parameter(Mandatory)]
        [String] $InputString
    )
    
    $CurrentValue = 0 

    foreach($c in $InputString.ToCharArray())
    {
        $CurrentValue += [byte][char]$c
        $CurrentValue  = $CurrentValue * 17
    }

    return $CurrentValue % 256
}

$InputFile = Get-Content $PSScriptRoot\Input.txt

$Total = 0 

foreach($Element in $InputFile -split ',')
{
    $total += Get-StringHash -InputString $Element
}

$Total