# Script parameters
# Top-level parameters
# Script-scope parameters
param(
    [int]$Num1 = 0,
    [int]$Num2 = 0
)   

Write-Host $Num1 
Write-Host $Num2

function Mult-Number {
    Write-Host "Number Num1: $Num1"
    Write-Host "Number Num2: $Num2"
    Write-Host "Sum: $($Num1 + $Num2)"
}
# Two ways to execute 
# .\Test-TwoNumbers.ps1 -Num1 4 -Num2 6
# . .\Test-TwoNumbers.ps1
# $Num1 = 2
# $Num2 = 3
# Mult-Number

#--------------------------------------------------



# .\Test-TwoNumbers.ps1
Write-Output "Running script directly from the terminal"

# Dot-Sourcing and calling functions with arguments
# . .\Test-TwoNumbers.ps1
# add-Number -a 4 -b 5
# sub-Numbers -a 3 -b 5


function Add-Number {
    param(
        [int]$A,
        [int]$B
    )

    Write-Host "Number A: $A"
    Write-Host "Number B: $B"
    Write-Host "Sum: $($A + $B)"
}



function Sub-Number {
    param(
        [int]$A,
        [int]$B
    )
    Write-Host "Number A: $A"
    Write-Host "Number B: $B"
    Write-Host "Difference: $($A - $B)"


}
