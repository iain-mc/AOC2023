$inputPath = "C:\Users\Administrator\AOC2023\1\input.txt" #hardcoaded filepath 

$input = Get-Content $inputPath #Camel case should be caps case, input is reserved variabel 

$calibriationValues = [System.Collections.Generic.List[Int]]::New() #need to initialise array? Should use Generic List 

foreach ($line in $input) #using proper bracing 
{
    $numbers = $line.tochararray() | Where-Object {$_ -match '\d'}

    $first = $numbers[0]

    $last = $numbers[$numbers.length -1]

    $calibrationValue = [int]"$($first)$($last)"

    $calibriationValues.Add($calibrationValue)
}

$sum = 0 

$calibriationValues | ForEach-Object {$sum += $_}

$sum