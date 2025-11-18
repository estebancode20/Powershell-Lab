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

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Use-Array -Numbers @(6, 7, 8, 9, 10)
    

}