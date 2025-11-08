function Get-Test {
    [CmdletBinding()]  # CmdletBinding must be applied here, at the function level.
    
    param (
        # [Parameter(Mandatory)] ensures the user is prompted to provide a value for $name if it's not supplied
        [Parameter(Mandatory)]
        [string]$name  # If not provided, PowerShell will prompt for this parameter
    )

    Write-Verbose "Testing $Name"
    Write-Output "Hello $Name"
}
Get-Test    
