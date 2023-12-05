function Test-IsSeed {
    param (
        [Parameter(Mandatory)]
        [String] $Seeds,
        [Parameter(Mandatory)]
        [Int64] $Seed
    )

    $SeedsInput = ($Seeds -split ':')[1].trim() -split '\s+'

    for($i=0; $i -lt ($SeedsInput.length -1); $i = $i + 2)
    {
        $SeedMin  = [Int64]$SeedsInput[$i]
        $SeedMax  = [Int64]$SeedsInput[$i] + ([Int64]$SeedsInput[$i + 1] -1)

        if (($Seed -ge $SeedMin) -and ($Seed -le $SeedMax))
        {
            return $True
        }
    }

    return $false 
}

function Get-MapValue {
    param (
        [Parameter(Mandatory)]
        [PSObject] $Map,
        [Parameter(Mandatory)]
        [Int64] $Value
    )

    foreach ($M in $Map)
    {
        if (($Value -ge $M['SrcLow']) -and ($Value -le $M['SrcHigh']))
        {
            return $M['DstLow'] + ($Value - $M['SrcLow'])
        }
    }
    
    return $value 
}

function Get-MapValueReverse {
    param (
        [Parameter(Mandatory)]
        [PSObject] $Map,
        [Parameter(Mandatory)]
        [Int64] $Value
    )

    foreach ($M in $Map)
    {
        if (($Value -ge $M['DstLow']) -and ($Value -le $M['DstHigh']))
        {
            return $M['SrcLow'] + ($Value - $M['DstLow'])
        }
    }
    
    return $value 
}

$Input = Get-Content $PSScriptRoot\input.txt

$SeedToSoil         = @()
$SoilToFertilizer   = @()
$FertilizerToWater  = @()
$WaterToLight       = @()
$LightToTemp        = @()
$TempToHumid        = @()
$HumidToLocation    = @()

foreach ($Line in $Input)
{
    switch ($Line) 
    {
        "seed-to-soil map:"             {$CurrentMap = [ref]$SeedToSoil;        continue}
        "soil-to-fertilizer map:"       {$CurrentMap = [ref]$SoilToFertilizer;  continue}
        "fertilizer-to-water map:"      {$CurrentMap = [ref]$FertilizerToWater; continue}
        "water-to-light map:"           {$CurrentMap = [ref]$WaterToLight;      continue}
        "light-to-temperature map:"     {$CurrentMap = [ref]$LightToTemp;       continue}
        "temperature-to-humidity map:"  {$CurrentMap = [ref]$TempToHumid;       continue}
        "humidity-to-location map:"     {$CurrentMap = [ref]$HumidToLocation;   continue}
    }

    if($Line -match "^[\d ]")
    {
        [Int64]$StartDst, [Int64]$StartSrc, [Int64]$Range = $Line -split '\s+'
        ($CurrentMap.Value) += @{"SrcLow"  = $StartSrc; 
                                 "SrcHigh" = $StartSrc + $Range - 1;
                                 "DstLow"  = $StartDst; 
                                 "DstHigh" = $StartDst + $Range - 1}
    }
}

$SeedLine = $Input[0]
$location = 0

while ($true)
{
    $Humid      = Get-MapValueReverse -Map $HumidToLocation     -Value $location 
    $Temp       = Get-MapValueReverse -Map $TempToHumid         -Value $Humid
    $Light      = Get-MapValueReverse -Map $LightToTemp         -Value $Temp 
    $Water      = Get-MapValueReverse -Map $WaterToLight        -Value $Light
    $Fertilizer = Get-MapValueReverse -Map $FertilizerToWater   -Value $Water 
    $Soil       = Get-MapValueReverse -Map $SoilToFertilizer    -Value $Fertilizer 
    $Seed       = Get-MapValueReverse -Map $SeedToSoil          -Value $Soil 

    if(Test-IsSeed -Seeds $Seedline -Seed $Seed)
    {
        "LOWEST LOCATION: $location - SEED: $Seed "
        return 
    }

    $Location++
}
