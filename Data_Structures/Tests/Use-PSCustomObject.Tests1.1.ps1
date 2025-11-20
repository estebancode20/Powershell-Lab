Describe "Use-Object" {

    BeforeAll {
        . "$PSScriptRoot\..\Use-PSCustomObject1.1.ps1"
    }

    It "prints all properties of a PSCustomObject" {
        $user = [pscustomobject]@{
            Name = "Bob"
            Age  = 25
        }

        $result = Use-Object -User $user

        $result | Should -Contain "Name: Bob"
        $result | Should -Contain "Age: 25"
    }

    
}
