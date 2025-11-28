function Use-ArrayList {
    [CmdletBinding()]
    param()

    try {
        $list = [System.Collections.ArrayList]::new()
        $items = @("PowerShell", "C#", "Python", "Go")

        for ($i = 0; $i -lt $items.Count; $i++) {
            [void]$list.Add($items[$i])
            Write-Output "Added: $($items[$i])"
        }

        Write-Output "`nCurrent list: $list"

        for ($i = 0; $i -lt $list.Count; $i++) {
            if ($list[$i] -eq "Python") {
                Write-Output "Removing: $($list[$i])"
                $list.Remove($list[$i])
            }
            <#
            The script cannot add "Rust" because when "Python" is removed,
            the list is re-indexed, and "Go" moves to the previous index,
            causing the loop to skip it.
            #>

            elseif ($list[$i] -eq "Go") {
                Write-Output "Adding: Rust"
                [void]$list.Add("Rust")
            }
        }

        Write-Output "`nFinal list: $list"
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

# if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
#     Use-ArrayList
# }

# if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
#     Use-ArrayList
# }

# if ($MyInvocation.MyCommand.Path -eq $PSCommandPath) {
#     Use-ArrayList
# }

if (-not $MyInvocation.ExpectingInput) {
    Use-ArrayList
}
