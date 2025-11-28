<#
Its purpose is to list and print all NoteProperty names and values of a given process object.
This function loops through all the NoteProperty members of a given process object and prints their names and values.

$props = $Process | Get-Member -MemberType NoteProperty → gets metadata about all NoteProperties of $Process.
$propName = $props[$i].Name → extracts each property’s name.
$propValue = $Process.$propName → dynamically accesses that property value from the original process object.
Prints Name: Value for each property.
#>


function Use-Object {
    [CmdletBinding()]  
    param(
        [Parameter(Mandatory)]
        [System.Diagnostics.Process] $Process
    )

    try {
        # Get all properties of the process
        $props = $Process | Get-Member -MemberType NoteProperty
        $i = 0
        while ($i -lt $props.Count) {
            $propName = $props[$i].Name
            $propValue = $Process.$propName
            Write-Output ("{0}: {1}" -f $propName, $propValue)
            $i++
        }
    }
    catch [System.Exception] {
        Write-Error "Message $($_.Exception.Message)"
    }
}


# if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
#     $proc = Get-Process | Select-Object -First 1
#     Use-Object -Process $proc
# }


if (-not $MyInvocation.ExpectingInput) {
    $proc = Get-Process | Select-Object -First 1
     Use-Object -Process $proc
}