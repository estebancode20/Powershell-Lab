Describe "Use-Dictionary" {

    BeforeAll {
        . "$PSScriptRoot\..\Use-Dictionary1.0.ps1"
    }

    It "outputs correct messages for each dictionary entry" {
        $result = Use-Dictionary

        $result | Should -Contain "Apples are in low quantity (5)"
        $result | Should -Contain "Oranges are in high quantity (10)"
        $result | Should -Contain "Bananas are in low quantity (3)"
    }

}
