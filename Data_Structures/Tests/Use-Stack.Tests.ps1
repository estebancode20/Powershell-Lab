Describe "Use-Stack" {

    BeforeAll {
    . "$PSScriptRoot\..\Use-Stack1.0.ps1"
    }

    It "pops items in LIFO order and handles the middle item" {
        $result = Use-Stack

        # Expected LIFO pop order: 5,4,3,2,1
        $result[0] | Should -Be "Popped: 5"
        $result[1] | Should -Be "Popped: 4"
        $result[2] | Should -Be "Middle item reached: 3"
        $result[3] | Should -Be "Popped: 2"
        $result[4] | Should -Be "Popped: 1"
    }

    It "does not throw" {
        { Use-Stack } | Should -Not -Throw
    }
}
