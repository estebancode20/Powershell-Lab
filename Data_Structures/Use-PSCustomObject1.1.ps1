function Use-Object {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $User
    )

    try {
        
        foreach ($prop in $User.PSObject.Properties) {
            $name = $prop.Name
            $value = $prop.Value
            Write-Output ("{0}: {1}" -f $name, $value)
        }

    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    $user = [pscustomobject]@{
        Name   = "Alice"
        Age    = 30
        Active = $true
        Joined = (Get-Date)
    }

    Use-Object -User $user
}
