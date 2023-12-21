function Get-StepsToZN {
    param (
        [Parameter(Mandatory)]
        [String] $Element, 
        [Parameter(Mandatory)]
        [Char[]] $Instruction,
        [Parameter(Mandatory)]
        [Hashtable] $Nodes,
        [Parameter(Mandatory)]
        [bigint] $N
    )

    $total = 0 
    $CurrentElement = $Element
    $i = 0; 
    while ($true)
    {
        $total = $total + 1
        $Instruction = $Instructions[$i]
        $CurrentElement = $Nodes[$CurrentElement]["$Instruction"]

        if (($CurrentElement -match "[0-9A-Z]{2}Z") -and ($n -eq 0))
        {
            return $total  
        }

        $i = $i + 1
        $N = $N - 1
    
        if(($i % $Instructions.Length) -eq 0)
        {
            $i = 0 
        }
    }
}

function Get-StepsToZ {
    param (
        [Parameter(Mandatory)]
        [String] $Element, 
        [Parameter(Mandatory)]
        [Char[]] $Instruction,
        [Parameter(Mandatory)]
        [Hashtable] $Nodes
    )

    $total = 0 
    $CurrentElement = $Element
    $i = 0; 
    while ($true)
    {
        $total = $total + 1
        $Instruction = $Instructions[$i]
        $CurrentElement = $Nodes[$CurrentElement]["$Instruction"]

        if ($CurrentElement -match "[0-9A-Z]{2}Z")
        {
            return $total  
        }

        $i = $i + 1
    
        if(($i % $Instructions.Length) -eq 0)
        {
            $i = 0 
        }
    }
}

$InputFile = Get-Content $PSScriptRoot\input.txt

$Instructions = ($InputFile[0]).ToCharArray()

$Nodes = @{}

foreach ($Line in $InputFile[2..($InputFile.Length -1)])
{
    $Element = ($Line -split "=")[0].Trim()
    $Left, $Right = (($Line -split "=")[1].trim() -replace "[(),]") -split '\s+'

    $Nodes[$Element] = @{"R" = $Right; "L" = $Left}
}

$steps = @()
[bigint]$total = 1
$CurrentElements = $Nodes.Keys | Where-Object {$_ -Match "[0-9A-Z]{2}A"}

foreach ($Element in $CurrentElements)
{
    $steps += Get-StepsToZ -Element $Element -Instruction $Instructions -Nodes $Nodes
    "    $Element - $Steps    "
}

foreach ($Step in $Steps)
{
    $total = $total * $Step
}

$total