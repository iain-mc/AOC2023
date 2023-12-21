class WF 
{
    [String] $Name
    [Rule[]] $Rules
    [String] $Default

    WF([String] $Name, [Rule[]] $Rules, [String] $Default)
    {
        $This.Name    = $Name
        $This.Rules   = $Rules
        $This.Default = $Default
    }

    [String] Evaluate([Part] $Part)
    {
        foreach($Rule in $This.Rules)
        {
            if($Rule.Evaluate($Part))
            {
                return $Rule.NextWF
            }
        }

        return $This.Default
    }
}

class Rule
{
    [Char]   $Type
    [Char]   $Operator
    [Int]    $Value
    [String] $NextWF

    Rule([Char] $Type, [Char] $Operator, [Int] $Value, [String] $NextWF)
    {
        $This.Type     = $Type
        $This.Operator = $Operator
        $This.Value    = $Value
        $This.NextWF   = $NextWF
    }

    [bool] Evaluate([Part]$Part)
    {
        switch ($This.Operator) {
            '>' { return $Part.($This.Type) -gt $This.Value }
            '<' { return $Part.($This.Type) -lt $This.Value }
            '=' { return $Part.($This.Type) -eq $This.Value }
        }
        return $False
    }
}

class Part 
{
    [Int] $X
    [Int] $M
    [Int] $A
    [Int] $S

    Part([Int] $X, [Int] $M, [Int] $A, [Int] $S)
    {
        $This.X = $X
        $This.M = $M
        $This.A = $A
        $This.S = $S
    }
}

$InputFile = Get-Content $PSScriptRoot\Input.txt -Raw
$WorkFlows, $Parts = $InputFile -split "`n`n"

$WorkFlows = $WorkFlows -split "`n"
$Parts = $Parts -split "`n"

$WFS = @{}

foreach($WF in $WorkFlows)
{
    $WF -match "([a-z]*){(.*)}"
    $WFName  = $Matches[1]
    $WFRules = $Matches[2] -split ','
    $Rules = @()
    for($i=0; $i -lt ($WFRules.length); $i++)
    {
        if($i -eq ($WFRules.length -1))
        {
            $Default = $WFRules[$i]
        }
        else 
        {
            $Type, $Value, $NextWF = $WFRules[$i] -split "<|:|>"
            $WFRules[$i] -match "[<>]"
            $Operator = $Matches[0]
            $Rules += [Rule]::New($Type, $Operator, $Value, $NextWF)
        }
    }

    $WFS[$WFName] = [WF]::New($WFName, $Rules, $Default)
}

$PTS = @()

foreach($Part in $Parts)
{
    $part -match "{(.*)}"
    $X, $M, $A, $S = $Matches[1]  -split ",?.=" | ?{$_}
    $PTS += [Part]::New($X, $M, $A, $S)
}

$total  = 0 

foreach($P in $PTS)
{
    $Next = $WFS['in'].Evaluate($P)
    while($($Next -ne 'A') -and $($Next -ne 'R'))
    {
        $Next = $WFS[$Next].Evaluate($P)
    }
    
    if($Next -eq 'A')
    {
        $total = $total + $P.X + $P.M + $P.A + $P.S 
    }
}

$total