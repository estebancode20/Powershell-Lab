# Load the script
BeforeAll { . "$PSScriptRoot\file4.ps1" }

Describe "Add-Numbers" {

    It "returns correct sum for 2 + 3" {
        $result = Add-Numbers -A 2 -B 3
        $result | Should -Be 5
    }

    It "returns correct sum for 0 + 5" {
        $result = Add-Numbers -A 0 -B 5
        $result | Should -Be 5
    }

}

Describe "Subtract-Numbers" {

    It "returns correct difference for 5 - 3" {
        $result = Subtract-Numbers -A 5 -B 3
        $result | Should -Be 2
    }

    It "returns negative result for 3 - 5" {
        $result = Subtract-Numbers -A 3 -B 5
        $result | Should -Be -2
    }

}
