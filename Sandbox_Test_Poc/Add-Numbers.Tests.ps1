Describe "Add-Numbers" {

    BeforeAll {
        . "$PSScriptRoot\..\Add-Numbers.ps1"
    }

    It "Should return 5 when adding 2 and 3" {
        $result = Add-Numbers -A 2 -B 3
        $result | Should -Be 5
    }

    It "Should return 0 when adding -2 and 2" {
        $result = Add-Numbers -A -2 -B 2
        $result | Should -Be 0
    }
}
