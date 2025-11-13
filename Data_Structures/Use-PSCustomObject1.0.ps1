function Use-Object {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $User
    )

    try {
        $props = @($User.PSObject.Properties)
        $i = 0

        while ($i -lt $props.Count) {
            $name = $props[$i].Name
            $value = $props[$i].Value
            Write-Output ("{0}: {1}" -f $name, $value)
            $i++
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
