$inputPath = "C:\Users\Administrator\AOC2023\1\input.txt"

$input = Get-Content $inputPath

$calibriationValues = @()

$numMap = @{
    "zero"      = "0";
    "one"       = "1";
    "two"       = "2";
    "three"     = "3";
    "four"      = "4";
    "five"      = "5";
    "six"       = "6";
    "seven"     = "7";
    "eight"     = "8";
    "nine"      = "9"
}

foreach ($line in $input)
{
    $line = $line.toLower()

    foreach ($number in $numMap.Keys)
    {
        $line = $line -replace $number,"$($number[0])$($numMap[$number])$($number[-1])"
    }

    $numbers = $line.tochararray() | Where-Object {$_ -match '\d'}

    $first = $numbers[0]

    $last = $numbers[$numbers.length -1]

    $calibrationValue = [int]"$($first)$($last)"

    $calibriationValues += $calibrationValue
}

$sum = 0 

$calibriationValues | ForEach-Object {$sum = $sum + $_}

$sum