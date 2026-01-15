# Function 1: Adds two numbers
function Add-Numbers {
    param($a, $b)
    $result = $a + $b
    return $result
}

# Function 2: Multiplies two numbers
function Multiply-Numbers {
    param($x, $y)
    $result = $x * $y
    return $result
}

# Variables
$num1 = 5
$num2 = 10

# Calling functions
$sum = Add-Numbers -a $num1 -b $num2
$product = Multiply-Numbers -x $num1 -y $num2

Write-Host "Sum: $sum"
Write-Host "Product: $product"
