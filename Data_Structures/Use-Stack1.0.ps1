function Use-Stack {
    [CmdletBinding()]
    param()

    try {
        # Create a LIFO stack
        $stack = [System.Collections.Stack]::new()

        # Push several items
        1..5 | ForEach-Object { $stack.Push($_) }

        do {
            $item = $stack.Pop()
            
            if ($item -eq 3) {
                Write-Output "Middle item reached: $item"
            }
            else {
                Write-Output "Popped: $item"
            }
        }
        until ($stack.Count -eq 0)
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Use-Stack
}
