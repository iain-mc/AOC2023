Class Hand : IComparable
{
    [Int] $HandType
    [Int] $Bid
    [Int[]] $Cards

    Hand ([Int] $HandType, [Int] $Bid, [Int[]] $Cards)
    {
        $this.HandType = $HandType
        $this.Bid = $Bid
        $this.Cards = $Cards
    }

    [Int]
    CompareTo ([object] $Other)
    {
        if ($other.HandType -gt $this.HandType)
        {
            return -1
        }

        if ($other.HandType -eq $this.HandType)
        {
            for ($i=0; $i -lt ($this.Cards.length); $i++)
            {
                if ($Other.Cards[$i] -gt $this.Cards[$i])
                {
                    return -1
                }
                if ($Other.Cards[$i] -lt $this.Cards[$i])
                {
                    return 1
                }
            }
            return 0
        }
        return 1
    }

}

function Get-MostCommon {
    param (
        [Parameter(Mandatory)]
        [Char[]] $List
    )
        
    $mostCommon = 0
    $n = 0
    for ($i=0; $i -lt $List.Length; $i++)
    {
        $Same = 0
        for ($j=0; $j -lt $List.Length; $j++)
        {
            if ($i -eq $j)
            {
                continue
            }

            if ($list[$i] -eq $List[$j])
            {
                $same++
            }
        }
        if($Same -gt $n)
        {
            $n = $Same
            $MostCommon = $i
        }
    }

    return $List[$MostCommon]
}
function Optimise-Cards {
    param (
        [Parameter(Mandatory)]
        [Char[]] $Cards
    )
    
    $MostCommon = Get-MostCommon -List $Cards

    if ($MostCommon -eq "J") 
    {
        if(($( $Cards | ?{$_ -ne "J"})).Length)
        {
            $MostCommon = Get-MostCommon $($Cards | ?{$_ -ne "J"})
        }
        else 
        {
            $MostCommon = "A"
        }
    }

    return $Cards -replace "J",$MostCommon   
}

function Get-HandType {
    param (
        [Parameter(Mandatory)]
        [Char[]] $Cards
    )

    $Cards = $Cards | Sort-Object
    
    switch ($Cards | select -Unique | measure | select -ExpandProperty count)
    {
        1 {return 7} #5
        2 {if(($Cards[0] -eq $Cards[3]) -or ($Cards[4] -eq $Cards[1])){return 6}else{return 5}} #4, FH
        3 {if(($Cards[0] -eq $Cards[2]) -or ($Cards[2] -eq $Cards[4]) -or ($Cards[1] -eq $Cards[3])){return 4}else{return 3}} #3, 2P
        4 {return 2}
        default {return 1}
    }
}

$InputFile = Get-Content $PSScriptRoot\input.txt

$Hands = [System.Collections.Generic.List[Hand]]::New()

foreach ($Line in $InputFile)
{
    $Cards, $Bid = $Line -split "\s+"

    $HandType = Get-HandType -Cards $(Optimise-Cards -Cards $Cards).ToCharArray()

    $Cards = $Cards -replace ""," "
    $Cards = $Cards -replace "T","10"
    $Cards = $Cards -replace "J","1"
    $Cards = $Cards -replace "Q","12"
    $Cards = $Cards -replace "K","13"
    $Cards = $Cards -replace "A","14"
    $Cards = $Cards.trim()

    $CardArray = @()
    $Cards.Split() | %{$CardArray += [Int]$_}

    $Hands += [Hand]::New($HandType, $Bid, $CardArray)
} 

$Total = 0
 
$Hands = $Hands | Sort-Object

for ($i=0; $i -lt $Hands.Length; $i++)
{
     $total += $($i + 1) * $($Hands[$i].Bid)
}

$Total