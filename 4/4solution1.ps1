function Get-CardValue {
    param (
        [Parameter(Mandatory)]
        [String] $Card
    )

    $SplitCard = $Card -split "\|"
    $Winning =  $SplitCard[0].trim() -split "\s+"
    $Numbers =  $SplitCard[1].trim() -split "\s+"

    $WinningNumbers = 0

    foreach ($Number in $Numbers)
    {
        if ($Winning.contains($Number))
        {   
            $WinningNumbers++
        }
    }

    if (($WinningNumbers -eq 0) -or ($WinningNumbers -eq 1))  
    {
        return $WinningNumbers
    }

    return [Math]::Pow(2, $WinningNumbers -1)
}

$Input = Get-Content $PSScriptRoot\input.txt

$Total = 0 

foreach ($Card in $Input)
{
    $total += Get-CardValue -Card $(($Card -split ':')[1])
}

$Total