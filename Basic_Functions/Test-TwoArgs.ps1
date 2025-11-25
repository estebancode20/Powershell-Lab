param(
    [string]$First = "DEFAULT1",
    [string]$Second = "DEFAULT2"
)

function Show-Args {
    param(
        [string]$A,
        [string]$B
    )

    Write-Host "Received A: $A"
    Write-Host "Received B: $B"
}

Show-Args -A $First -B $Second
