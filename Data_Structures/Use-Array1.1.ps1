[CmdletBinding()]
param()

# Simple array
$numbers = 1..5

for ($i = 0; $i -lt $numbers.Length; $i++) {
    if ($numbers[$i] % 2 -eq 0) {
        Write-Output "$($numbers[$i]) is even"
    } else {
        Write-Output "$($numbers[$i]) is odd"
    }
}