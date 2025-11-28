function Use-Array {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [int[]] $Numbers
    ) 
    
    try {
        for ($i = 0; $i -lt $Numbers.Count; $i++) {
            if ($Numbers[$i] % 2 -eq 0) {
                Write-Output "Element $($Numbers[$i]) is even."

            }
            else {
                Write-Output "Element $($Numbers[$i]) is odd."

            }

        }
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }

}

# OLD ENTRY POINT CHECK
# $PSCommandPath = automatic variable with the full script path.
# $MyInvocation.MyCommand.Path = automatic variable with the full script path.
# Both contain the same value even when dot-sourced → old entry point runs during tests.

# if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
#     Use-Array -Numbers @(6, 7, 8, 9, 10)
    

# }

# NEW ENTRY POINT CHECK
# $MyInvocation.InvocationName = automatic variable showing how the script was called ("script.ps1" or ".").
# $MyInvocation.MyCommand.Name = automatic variable with the script's file name.
# Direct run: InvocationName == Name → entry point runs.
# Dot-sourced (Pester): InvocationName = "." → no match → entry point skipped.

# if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
#     Use-Array -Numbers @(6, 7, 8, 9, 10)
# }

# if ($MyInvocation.MyCommand.Path -eq $PSCommandPath) {
#     Use-Array -Numbers @(6, 7, 8, 9, 10)
# }



if (-not $MyInvocation.ExpectingInput) {
    Use-Array -Numbers @(6, 7, 8, 9, 10)
}
