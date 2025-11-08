function Get-Test {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $name
    )

    try {
        while ($true) {
            Write-Verbose "Testing $name"
            Write-Output "Hello $name"
            break
        }
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }

}

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Get-Test -name "Alicia" -Verbose
}