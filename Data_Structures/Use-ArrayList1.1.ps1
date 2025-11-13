function Use-ArrayList {
    [CmdletBinding()]
    param()

    try {
        $list = [System.Collections.ArrayList]::new()
        $items = @("PowerShell", "C#", "Python", "Go")

        # Add initial items to the list
        for ($i = 0; $i -lt $items.Count; $i++) {
            [void]$list.Add($items[$i])
            Write-Output "Added: $($items[$i])"
        }

        Write-Output "`nCurrent list: $list"

        # Loop through the list and remove/modify items as necessary
        for ($i = 0; $i -lt $list.Count;) {  # Do not increment $i here
            if ($list[$i] -eq "Python") {
                Write-Output "Removing: $($list[$i])"
                $list.RemoveAt($i)  # Remove item at index $i
            }
            elseif ($list[$i] -eq "Go") {
                Write-Output "Adding: Rust"
                [void]$list.Add("Rust")
                $i++  # Move to the next item after adding Rust
            }
            else {
                $i++  # Only increment $i for items that were not removed or modified
            }
        }

        Write-Output "`nFinal list: $list"
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Use-ArrayList
}
