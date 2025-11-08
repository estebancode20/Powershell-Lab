function Get-Test { 
    [CmdletBinding()]  # CmdletBinding must be applied here, at the function level.
    
    param (
        # [Parameter(Mandatory)] ensures the user is prompted to provide a value for $name if it's not supplied
        [Parameter(Mandatory)]
        [string]$name  # If not provided, PowerShell will prompt for this parameter
    )

    try {
        while ($true) {
            Write-Verbose "Test $name"  # show only if -Verbose is specified
            Write-Output "Hello $name" 
            break  
        }
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)" 
    }
}


if ($PSCommandPath -eq $MyInvocation.MyCommand.path) {
    
    Get-Test -name "Alicia" -Verbose  
}
