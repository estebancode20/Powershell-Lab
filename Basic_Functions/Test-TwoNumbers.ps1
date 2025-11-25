param(
    [int]$Num1 = 0,
    [int]$Num2 = 0
)   

function Show-Numbers {
    param(
        [int]$A,
        [int]$B
    )

    Write-Host "Number A: $A"
    Write-Host "Number B: $B"
    Write-Host "Sum: $($A + $B)"
}

Show-Numbers -A $Num1 -B $Num2
