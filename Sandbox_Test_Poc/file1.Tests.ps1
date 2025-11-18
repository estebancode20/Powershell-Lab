Describe "Add-Numbers" {

    BeforeAll {
        . "$PSScriptRoot\file1.ps1"
    }

    It "returns the sum of two numbers" {
        Add-Numbers -A 2 -B 3 | Should -Be 5
    }
}
