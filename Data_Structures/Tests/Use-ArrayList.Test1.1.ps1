Describe "Use-ArrayList" {

    BeforeAll {
        ."$PSScriptRoot\..\Use-ArrayList1.1.ps1"
    }

    It "Final list should contain PowerShell, C#, Go, Rust but not Python" {
        $finalList = Use-ArrayList

        $finalList | Should -Contain "PowerShell"
        $finalList | Should -Contain "C#"
        $finalList | Should -Contain "Go"
        $finalList | Should -Contain "Rust"
        $finalList | Should -Not -Contain "Python"
    }
}
