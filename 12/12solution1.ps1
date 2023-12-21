#Get-Permutations
#  probably not going to work
#   gc .\input.txt | %{if((($_ -split ' ')[0] -replace "[\.#]").Length -eq 17){$_}}
#Test-Match
#foreach line
#   for each get-permutation
#      if test-match $_ {total ++}

function Test-Match {
    param (
        [Parameter(Mandatory)]
        [String] $Condition,
        [Parameter(Mandatory)]
        [Int[]] $Damaged 
    )

    $ConditionList = $Condition.Split('.',[System.StringSplitOptions]::RemoveEmptyEntries)

    if($ConditionList.Length -ne $Damaged.Length)
    {
        return $False
    }

    for($i=0; $i -lt $Damaged.Length; $i++)
    {
        if($Damaged[$i] -ne $ConditionList[$i].Length)
        {
            return $False
        }
    }
    
    return $True
}

function Get-Permutations 
{
    param (
        [Parameter(Mandatory)]
        [String] $Condition
    )

    $NumHash = $($Condition -replace "[\.#]").Length

    $Maps          = [System.Collections.Generic.List[String]]::New()
    $Premutations  = [System.Collections.Generic.List[String]]::New()


    $Bits = [math]::floor([math]::Log2(([math]::pow(2, $NumHash) -1))) +1

    0..([math]::pow(2, $NumHash) -1) | %{$Maps += ([convert]::ToString($_,2)).PadLeft($Bits,'0')}


    foreach($Map in $Maps)
    {
        $Current = 0 
        $Permutation = ""
        for($i=0; $i -lt $Condition.Length; $i++)
        {
            if($Condition[$i] -eq '?')
            {
                if($Map[$Current] -eq "0")
                {
                    $Permutation += "."
                }
                else
                {
                    $Permutation += "#"
                }
                $Current++
            }
            else 
            {
                $Permutation += $Condition[$i]
            }
        }
        $Permutations += ,$Permutation
    }

    return $Permutations
}

$InputFile = Get-Content $PSScriptRoot\Input.txt
$total = 0
$p = 0
foreach($Line in $InputFile)
{
    Write-Host "--$p--"
    $p++
    $Condition, $D = $Line -split '\s+'
    $Damaged = $D -split ','
    foreach($Permutation in $(Get-Permutations -Condition $Condition))
    {
        if(Test-Match -Condition $Permutation -Damaged $Damaged)
        {
            $total++
        }
    }
}

$total