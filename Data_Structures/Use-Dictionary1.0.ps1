function Use-Dictionary {
    [CmdletBinding()]
    param()

    try {
        # Create a generic dictionary
        $dict = [System.Collections.Generic.Dictionary[string, int]]::new()
        $dict.Add("Apples", 5)
        $dict.Add("Oranges", 10)
        $dict.Add("Bananas", 3)

        foreach ($key in $dict.Keys) {
            $value = $dict[$key]
            if ($value -gt 5) {
                Write-Output "$key are in high quantity ($value)"
            }
            else {
                Write-Output "$key are in low quantity ($value)"
            }
        }
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

# if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
#     Use-Dictionary
# }

if (-not $MyInvocation.ExpectingInput) {
    Use-Dictionary
}