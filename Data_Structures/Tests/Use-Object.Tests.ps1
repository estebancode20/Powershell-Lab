Describe "Use-Object" {

    BeforeAll {
        . "$PSScriptRoot\..\Use-Object1.0.ps1"
    }

    It "outputs all NoteProperty values of a process" {
        $proc = Get-Process | Select-Object -First 1
        $result = Use-Object -Process $proc

        $props = $proc | Get-Member -MemberType NoteProperty
        $props.Count | Should -BeGreaterThan 0

        $firstProp = $props[0].Name
        $result -join "`n" | Should -Match "${firstProp}:"
    }

    It "throws an error when Process parameter is missing" {
        Write-Host "Testing missing Process parameter"
        { Use-Object -Process $null } | Should -Throw
}

}
