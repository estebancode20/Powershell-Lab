function Use-ArrayList {
    [CmdletBinding()]
    param()

    try {
        $list = [System.Collections.ArrayList]::new()
        $items = @("PowerShell", "C#", "Python", "Go")

        # Add initial items
        foreach ($item in $items) {
            [void]$list.Add($item)
            Write-Output "Added: $item"
        }

        Write-Output "`nCurrent list: $($list -join ', ')"

        # Loop and remove/modify items
        for ($i = 0; $i -lt $list.Count;) {
            if ($list[$i] -eq "Python") {
                Write-Output "Removing: $($list[$i])"
                $list.RemoveAt($i)
            }
            elseif ($list[$i] -eq "Go") {
                Write-Output "Adding: Rust"
                [void]$list.Add("Rust")
                $i++
            }
            else {
                $i++
            }
        }

        Write-Output "`nFinal list: $($list -join ', ')"

        return $list  # Return the actual ArrayList for testing
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Use-ArrayList
}
