function Add-Numbers {
    param(
        [int]$A,
        [int]$B
    )
    return ($A + $B)
}

# Allow running directly
if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Add-Numbers -A 2 -B 3
}

