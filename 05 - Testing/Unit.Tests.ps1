. .\New-BeardFunction.ps1

Describe "Testing New-BeardFunction" {
    Context "Input" {
        It "Should have a SQLInstance parameter" {
            (Get-Command New-BeardFunction).Parameters['SQLInstance'] | Should -Not -BeNullOrEmpty -Because "Our company policy is to use SQLInstance as the parameter name for a SQL Instance"
        }
        It "Should have a Database parameter" {
            (Get-Command New-BeardFunction).Parameters['Database'] | Should -Not -BeNullOrEmpty -Because "This parameter is required to name the database"
        }
    }

    Context "Execution" {
        Mock Get-DbaDatabase {}
        It "When the Database Parameter is used the Get-DbaDatabase function should be called" {
            New-BeardFunction -SQLInstance Dummy -Database Dummy 

            $assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 1
                'Exactly'     = $true
            }
            Assert-MockCalled @assertMockParams |Should -BeTrue -Because "This parameter will use the Get-DBaDatabase function"
        }
        It "When the Database Parameter is not used the Get-DbaDatabase function should not be called" {
            New-BeardFunction -SQLInstance Dummy

            $assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 0
                'Exactly'     = $true
                'Scope'       = 'It'
            }
            Assert-MockCalled @assertMockParams |Should -BeTrue -Because "This parameter will use the Get-DBaDatabase function"
        }
    }
}
