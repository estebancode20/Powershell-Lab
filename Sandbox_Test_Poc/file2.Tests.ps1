Describe "Multiply-Numbers" {

    BeforeAll {
        # Load the function
        . "$PSScriptRoot\file2.ps1"
    }

    Context "When multiplying two numbers" {

        It "returns the correct product for positive numbers" {
            $result = Multiply-Numbers -A 3 -B 4
            $result | Should -Be 12
        }

        It "returns 0 if one number is 0" {
            $result = Multiply-Numbers -A 0 -B 5
            $result | Should -Be 0
        }

        It "returns a negative number if one input is negative" {
            $result = Multiply-Numbers -A -3 -B 4
            $result | Should -Be -12
        }

    }

}
