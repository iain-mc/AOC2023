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

class Lense {
    [String] $Label
    [Int] $Focus

    Lense([String]$Label, [Int]$Focus)
    {
        $This.Label = $Label
        $This.Focus = $Focus
    }
}

class Box {
    [Int] $Number
    [Lense[]] $Lenses

    Box([Int] $Number)
    {
        $This.Number = $Number 
        $This.Lenses = [System.Collections.Generic.List[Lense]]::new()
    }

    [void] AddLense ([Lense] $Lense)
    {
        if($This.Lenses.Length -eq 0)
        {
            $This.Lenses += $Lense
            return 
        }

        if(($This.Lenses.Label).Contains($Lense.Label))
        {
            for($i=0; $i -lt $this.Lenses.Length; $i++)
            {
                if($this.Lenses[$i].Label -eq $Lense.Label)
                {
                    $this.Lenses[$i].Focus = $Lense.Focus
                    return 
                }
            }
        }

        $This.Lenses += $Lense
    }

    [void] RemoveLense([String] $Label)
    {
        if($This.Lenses.Length -eq 0)
        {
            return 
        }
        
        if(($This.Lenses.Label).Contains($Label))
        {
            $This.Lenses = $This.Lenses | ?{$_.Label -ne $Label}
        }
    }

    [Int] GetBoxValue()
    {
        $Value = 0

        for($i=0; $i -lt $This.Lenses.Length; $i++)
        {
            $Value += $(($This.Number + 1) * ($i + 1) * $This.Lenses[$i].Focus)
        }

        return $Value
    }
}


$InputFile = Get-Content $PSScriptRoot\Input.txt 

$Boxes = [System.Collections.Generic.List[Box]]::New()
0..255 | %{$Boxes += [Box]::New($_)}

foreach($Element in $InputFile -split ',')
{
    if($Element.Contains('-'))
    {
        $Label = ($Element -split '-')[0]
        $BoxN  = Get-StringHash -InputString $Label
        $Boxes[$BoxN].RemoveLense($Label)
    }

    if($Element.Contains('='))
    {
        $Label, $Focus = ($Element -split '=')
        $BoxN  = Get-StringHash -InputString $Label
        $Boxes[$BoxN].AddLense([Lense]::New($Label, $Focus))
    }
}

$Total = 0 
foreach($Box in $Boxes)
{
    if($Box.Lenses.Length)
    {
        $Total += $Box.GetBoxValue()
    }
}

$Total