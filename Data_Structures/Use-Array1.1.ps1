[CmdletBinding()]
param(
    [string]$ShowOdd = "true"  # accept string
)

# Convert the string $ShowOdd to boolean:
# Uses a regex to match So it matches strings like "true", "TRUE",
# or "1" exactly. If it matches, $ShowOddBool = $true; otherwise $false.
$ShowOddBool = if ($ShowOdd -match '^(?i)true|1$') { $true } else { $false }

$numbers = 1..5
for ($i = 0; $i -lt $numbers.Length; $i++) {
    if ($numbers[$i] % 2 -eq 0) {
        Write-Output "$($numbers[$i]) is even"
    } elseif ($ShowOddBool) {
        Write-Output "$($numbers[$i]) is odd"
    }
}


