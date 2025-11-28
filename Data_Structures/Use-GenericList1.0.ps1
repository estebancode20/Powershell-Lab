function Use-GenericList {
    [CmdletBinding()]
    param()

    try {
        # Create a new List[int] and populate it with integers
        $list = New-Object System.Collections.Generic.List[System.Int32]
        $list.AddRange([int[]](1..10))  # Adding integers 1 to 10

        Write-Output "Original list: $($list)"

        # Iterate through the list using while loop
        $i = 0
        while ($i -lt $list.Count) {
            $value = $list[$i]
            
            # Use switch to evaluate each value
            switch ($value) {
                {$_ -lt 5} { Write-Output "Value $value is less than 5." }
                {$_ -eq 5} { Write-Output "Value $value is equal to 5." }
                {$_ -gt 5} { Write-Output "Value $value is greater than 5." }
            }

            $i++
        }
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

# Run the function
# if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
#     Use-GenericList
# }


if (-not $MyInvocation.ExpectingInput) {
    Use-GenericList
}