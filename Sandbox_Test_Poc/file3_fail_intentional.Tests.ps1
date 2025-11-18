Describe "Multiply-Numbers" {

    BeforeAll {
        # Load the function
        . "$PSScriptRoot\file3.ps1"
    }

    Context "Basic multiplication tests" {

        It "returns correct product for 2*3" {
            $result = Multiply-Numbers -A 2 -B 3
            $result | Should -Be 6  # pass
        }

        It "returns 0 when multiplying by 0" {
            $result = Multiply-Numbers -A 5 -B 0
            $result | Should -Be 0  #  pass
        }

        It "returns 10 for 2*5 (will fail)" {
            $result = Multiply-Numbers -A 2 -B 5
            $result | Should -Be 11  #  fail
        }

    }

}
