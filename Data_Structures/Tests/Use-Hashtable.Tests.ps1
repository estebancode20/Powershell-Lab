Describe "Use-Hashtable" {

    BeforeAll {
        . "$PSScriptRoot\..\Use-Hashtable1.0.ps1"
    }

    It "outputs all keys with values correctly" {
        $user = @{ Name = "Alice"; Age = 30; Role = "Admin"; Department = "IT" }
        $result = Use-Hashtable -UserInfo $user
        $result | Should -Contain "Name: Alice"
        $result | Should -Contain "Age: 30"
        $result | Should -Contain "Role: Admin"
        $result | Should -Contain "Department: IT"
    }

    It "outputs message for keys with null value" {
        $user = @{ Name = "Bob"; Department = $null }
        $result = Use-Hashtable -UserInfo $user
        $result | Should -Contain "Name: Bob"
        $result | Should -Contain "Department has no value."
    }

    It "throws an error if input is not a hashtable" {
        { Use-Hashtable -UserInfo @("a", "b") } | Should -Throw
    }

}
