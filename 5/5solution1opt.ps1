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


$Input = Get-Content $PSScriptRoot\input.txt

$Seeds = [System.Collections.Generic.List[Int64]]::New()
$Seeds = ($Input[0] -split ':')[1].trim() -split '\s+'

$SeedToSoil = @()
$SoilToFertilizer = @()
$FertilizerToWater = @()
$WaterToLight = @()
$LightToTemp = @()
$TempToHumid = @()
$HumidToLocation = @()

foreach ($Line in $Input)
{
    switch ($Line) {
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
        ($CurrentMap.Value) += @{"SrcLow"  = $StartSrc; "SrcHigh" = $StartSrc + $Range - 1; "DstLow"  = $StartDst}
    }
}

$LowLocation = 0

foreach ($Seed in $Seeds)
{
    $Seed = [Int64]$Seed
    $Soil = Get-MapValue -Map $SeedToSoil -Value $Seed 
    $Fertilizer = Get-MapValue -Map $SoilToFertilizer -Value $Soil 
    $Water = Get-MapValue -Map $FertilizerToWater -Value $Fertilizer 
    $Light = Get-MapValue -Map $WaterToLight -Value $Water 
    $Temp = Get-MapValue -Map $LightToTemp -Value $Light 
    $Humid = Get-MapValue -Map $TempToHumid -Value $Temp 
    $Location = Get-MapValue -Map $HumidToLocation -Value $Humid 

    if (($Location -lt $LowLocation) -or ($LowLocation -eq 0))
    {
        $LowSeed = $Seed
        $LowLocation = $Location
    }
}

"SEED: $LowSeed"
"LOCACTION: $LowLocation"