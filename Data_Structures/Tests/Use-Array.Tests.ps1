Describe "Use-Array" {

    BeforeAll {
        . "$PSScriptRoot\..\Use-Array.ps1"
    }

    It "Should correctly identify even and odd numbers" {
        $result = Use-Array -Numbers @(1, 2, 3, 4, 5)
        $result | Should -Contain "Element 1 is odd."
        $result | Should -Contain "Element 2 is even."
        $result | Should -Contain "Element 3 is odd."
        $result | Should -Contain "Element 4 is even."
        $result | Should -Contain "Element 5 is odd."
    }

    It "Should throw an error if input is not an integer array" {
        { Use-Array -Numbers @("a", "b") } | Should -Throw
    }
}
