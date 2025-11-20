Describe "Use-GenericList" {

    BeforeAll {
        ."$PSScriptRoot\..\Use-GenericList1.0.ps1"

    }

    It "Should output values less than 5 correctly" {
        $output = Use-GenericList
        $output | Should -Contain "Value 1 is less than 5."
        $output | Should -Contain "Value 2 is less than 5."
        $output | Should -Contain "Value 3 is less than 5."
        $output | Should -Contain "Value 4 is less than 5."
    }

    It "Should output value equal to 5 correctly" {
        $output = Use-GenericList
        $output | Should -Contain "Value 5 is equal to 5."
    }

    It "Should output values greater than 5 correctly" {
        $output = Use-GenericList
        $output | Should -Contain "Value 6 is greater than 5."
        $output | Should -Contain "Value 7 is greater than 5."
        $output | Should -Contain "Value 8 is greater than 5."
        $output | Should -Contain "Value 9 is greater than 5."
        $output | Should -Contain "Value 10 is greater than 5."
    }

    It "Should output the original list correctly" {
        $output = Use-GenericList
        $output | Should -Contain "Original list: 1 2 3 4 5 6 7 8 9 10"
    }
}



