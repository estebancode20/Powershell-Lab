function Use-Hashtable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $UserInfo
    )

    try {
        foreach ($key in $UserInfo.Keys) {
            if ($UserInfo[$key]) {
                Write-Output ("{0}: {1}" -f $key, $UserInfo[$key])
            }
            else {
                Write-Output "$key has no value."
            }
        }
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}

# if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
#     # Hastable data structure is Unordered; optimized for fast key lookup
#     $user = @{ Name = "Alice"; Age = 30; Role = "Admin"; Department = $null} 
#     Use-Hashtable -UserInfo $user
# }


if (-not $MyInvocation.ExpectingInput) {
    # Hastable data structure is Unordered; optimized for fast key lookup
    $user = @{ Name = "Alice"; Age = 30; Role = "Admin"; Department = $null} 
    Use-Hashtable -UserInfo $user
}