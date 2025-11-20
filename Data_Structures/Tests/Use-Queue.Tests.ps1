Describe "Use-Queue" {

    BeforeAll {
    . "$PSScriptRoot\..\Use-Queue1.0.ps1"
}


    It "processes all items in the queue in order" {
        $result = Use-Queue

        $result | Should -Contain "Processing: Task1"
        $result | Should -Contain "Processing: Task2"
        $result | Should -Contain "Processing: Task3"

        # Ensure correct order
        $result[0] | Should -Be "Processing: Task1"
        $result[1] | Should -Be "Processing: Task2"
        $result[2] | Should -Be "Processing: Task3"
    }

    It "throws no errors when running" {
        { Use-Queue } | Should -Not -Throw
    }
}
