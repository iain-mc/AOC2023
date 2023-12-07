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
            if ($Other.Cards[0] -gt $this.Cards[0])
            {
                return -1
            }
        }
        return 1
    }

}

function Get-HandType {
    param (
        [Parameter(Mandatory)]
        [Int[]] $Cards
    )

    switch ($Cards | select -Unique | measure | select -ExpandProperty count)
    {
        1 {return 7} #5
        2 {if($Cards[0] -eq $Cards[3]){return 6}else{return 5}} #4, FH
        3 {if(($Cards | select -Unique) -eq 2){return 4}else{return 3}} #3, 2P
        4 {return 2}
        default {return 1}
    }
}

$InputFile = Get-Content $PSScriptRoot\input.txt

$Hands = [System.Collections.Generic.List[Hand]]::New()

foreach ($Line in $InputFile)
{
    $Cards, $Bid = $Line -split "\s+"

    $HandType = Get-HandType -Cards $Cards.ToCharArray()

    $Hands += [Hand]::New($HandType, $Bid, $Cards.ToCharArray())
} 

#Sort all the cards of each type

$FullHouses = @()
foreach ($Hand in $($Hands | ?{$_.HandType -eq "Full House"}))
{

}



$Hands