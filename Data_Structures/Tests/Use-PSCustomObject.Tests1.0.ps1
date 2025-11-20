Describe "Use-Object" {

    BeforeAll {
        . "$PSScriptRoot\..\Use-PSCustomObject1.0.ps1"
    }

    It "outputs all properties of the PSCustomObject" {
        $user = [pscustomobject]@{
            Name   = "Karl"
            Age    = 79
            Active = $true
            Joined = Get-Date "2024-01-01"
        }

        $result = Use-Object -User $user

        $result | Should -Contain "Name: Karl"
        $result | Should -Contain "Age: 79"
        $result | Should -Contain "Active: True"
        ($result -join "`n") | Should -Match "Joined: "

    }
    
    # Never throws, because PowerShell will always convert the input into a PSCustomObject — even strings, integers, arrays, and hashtables.
    # It "throws an error if input is not a PSCustomObject" {
    #     { Use-Object -User @{ Name = "Bob" } } | Should -Throw
    # }

}
