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

    return $WinningNumbers
}

$Input = (Get-Content $PSScriptRoot\input.txt) -split "\n"

$Stack = [System.Collections.Stack]::New()

$total = 0 

for ($i=$Input.length -1; $i -ge 0; $i--)
{
    $stack.push($Input[$i])
}

while ($stack.Count)
{
    $Card = $Stack.pop()
    $total++

    if ($Value = Get-CardValue -Card $(($Card -split ':')[1]))
    {
        $GameID = [int]($Card | Select-String -Pattern "(?<=\s)\d*(?=\:)"  | select -exp Matches).value

        foreach ($C in $Input[($GameID + $Value -1)..$GameID])
        {
            $Stack.Push($C)
        }
    }
}

$total