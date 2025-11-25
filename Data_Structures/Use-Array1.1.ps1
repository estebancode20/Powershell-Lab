param(
    [string]$ShowOdd = "false"  # default at script level
)

function Show-Numbers {
    param(
        [string]$ShowOddFunc
    )

    Write-Host "DEBUG: ShowOdd parameter inside function = '$ShowOddFunc'"

    try {
        # Convert the string $ShowOddFunc to boolean
        $ShowOddBool = if ($ShowOddFunc -match '^(?i)true|1$') { $true } else { $false }

        $numbers = 1..5
        for ($i = 0; $i -lt $numbers.Length; $i++) {
            if ($numbers[$i] % 2 -eq 0) {
                Write-Output "$($numbers[$i]) is even"
            } elseif ($ShowOddBool) {
                Write-Output "$($numbers[$i]) is odd"
            }
        }
    }
    catch [Exception] {
        Write-Error "An error occurred: $($_.Exception.Message)"
    }
}

# Call function with script-level parameter
Show-Numbers -ShowOddFunc $ShowOdd
