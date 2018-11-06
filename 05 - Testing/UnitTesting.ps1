if (-not (Get-PSDrive -Name UnitTest -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name UnitTest -PSProvider FileSystem -Root '.\Slides-and-Demos\05 - Testing'
}

Set-Location UnitTest:\

## You have a requirement that every time a SQL Instance is required as a 
## parameter it should be SQLInstance


$Test = @"

. .\New-BeardFunction.ps1

Describe "Testing New-BeardFunction" {
    Context "Input" {
        It "Should have a SQLInstance parameter" {
            (Get-Command New-BeardFunction).Parameters['SQLInstance'] | Should -Not -BeNullOrEmpty
        }
    }
}

"@

Set-Content .\Unit.Tests.ps1 -Value $test

## Then we run the test using Invoke-Pester (Which will run all of the *.Tests.ps1)

Invoke-Pester 

## Good that failed

## Lets fix that

$code = @"
function New-BeardFunction{
    Param(`$SQLInstance)
}
"@

Set-Content .\New-BeardFunction.ps1 -Value $code

## Now we test the script again

Invoke-Pester

## and that is the process that you follow

## Write a test
## Run the Test and make sure that it fails
## Write the code
## Run the test to make sure that it passes

## Lets add some more tests - We will test our code execution

## If we have use a Database parameter it should call get-DbaDatabase

$test = @"
. .\New-BeardFunction.ps1

Describe "Testing New-BeardFunction" {
    Context "Input" {
        It "Should have a SQLInstance parameter" {
            (Get-Command New-BeardFunction).Parameters['SQLInstance'] | Should -Not -BeNullOrEmpty
        }
        It "Should have a Database parameter" {
            (Get-Command New-BeardFunction).Parameters['Database'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Execution" {
        Mock Get-DbaDatabase {}
        It "When the Database Parameter is used the Get-DbaDatabase function should be called" {
            New-BeardFunction -SQLInstance Dummy -Database Dummy 

            `$assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 1
                'Exactly'     = `$true
            }
            Assert-MockCalled @assertMockParams
        }
    }
}
"@
Set-Content .\Unit.Tests.ps1 -Value $test

## Then we run the test using Invoke-Pester (Which will run all of the *.Tests.ps1)

Invoke-Pester 

## Good that failed

## Lets write some code to fix it

$code = @"
function New-BeardFunction{
    Param(`$SQLInstance,`$Database)

    if(`$Database){
        `$DbSize = (Get-DbaDatabase -SqlInstance `$SQLInstance -Database `$Database).Size
    }

    [PSCustomObject] @{
        SQLInstance = `$SQLInstance
        Database = `$Database
        Size = `$dbSize
    }
}
"@

Set-Content .\New-BeardFunction.ps1 -Value $code

## Now we test the script again

Invoke-Pester

## Maybe we want to make sure that the Get-DbaDatabase function is NOT
## called when the parameter is not used

$test = @"
. .\New-BeardFunction.ps1

Describe "Testing New-BeardFunction" {
    Context "Input" {
        It "Should have a SQLInstance parameter" {
            (Get-Command New-BeardFunction).Parameters['SQLInstance'] | Should -Not -BeNullOrEmpty
        }
        It "Should have a Database parameter" {
            (Get-Command New-BeardFunction).Parameters['Database'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Execution" {
        Mock Get-DbaDatabase {}
        It "When the Database Parameter is used the Get-DbaDatabase function should be called" {
            New-BeardFunction -SQLInstance Dummy -Database Dummy 

            `$assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 1
                'Exactly'     = `$true
            }
            Assert-MockCalled @assertMockParams
        }
        It "When the Database Parameter is not used the Get-DbaDatabase function should not be called" {
            New-BeardFunction -SQLInstance Dummy

            `$assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 0
                'Exactly'     = `$true
            }
            Assert-MockCalled @assertMockParams
        }
    }
}
"@
Set-Content .\Unit.Tests.ps1 -Value $test

## Then we run the test using Invoke-Pester (Which will run all of the *.Tests.ps1)

Invoke-Pester 

## Hmmm

## This is a scope thing let's fix it


$test = @"
. .\New-BeardFunction.ps1

Describe "Testing New-BeardFunction" {
    Context "Input" {
        It "Should have a SQLInstance parameter" {
            (Get-Command New-BeardFunction).Parameters['SQLInstance'] | Should -Not -BeNullOrEmpty
        }
        It "Should have a Database parameter" {
            (Get-Command New-BeardFunction).Parameters['Database'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Execution" {
        Mock Get-DbaDatabase {}
        It "When the Database Parameter is used the Get-DbaDatabase function should be called" {
            New-BeardFunction -SQLInstance Dummy -Database Dummy 

            `$assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 1
                'Exactly'     = `$true
            }
            Assert-MockCalled @assertMockParams
        }
        It "When the Database Parameter is not used the Get-DbaDatabase function should not be called" {
            New-BeardFunction -SQLInstance Dummy

            `$assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 0
                'Exactly'     = `$true
                'Scope'       = 'It'
            }
            Assert-MockCalled @assertMockParams
        }
    }
}
"@
Set-Content .\Unit.Tests.ps1 -Value $test

## Then we run the test using Invoke-Pester (Which will run all of the *.Tests.ps1)

Invoke-Pester 

## WHY would we do this ?

## Imagine William - William is a new member of the team and writes some new
## code for the function. He is used to using instance instead of SqlInstance
## When he changes the code and runs the test

$code = @"
function New-BeardFunction{
    Param(`$Instance,`$Database)

    if(`$Database){
        `$DbSize = (Get-DbaDatabase -SqlInstance `$Instance -Database `$Database).Size
    }

    [PSCustomObject] @{
        SQLInstance = `$Instance
        Database = `$Database
        Size = `$dbSize
    }
}
"@

Set-Content .\New-BeardFunction.ps1 -Value $code

Invoke-Pester

## So now William gets errors

## It would be much better if we could inform him Why in the test


$test = @"
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

            `$assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 1
                'Exactly'     = `$true
            }
            Assert-MockCalled @assertMockParams |Should -BeTrue -Because "This parameter will use the Get-DBaDatabase function"
        }
        It "When the Database Parameter is not used the Get-DbaDatabase function should not be called" {
            New-BeardFunction -SQLInstance Dummy

            `$assertMockParams = @{
                'CommandName' = 'Get-DbaDatabase'
                'Times'       = 0
                'Exactly'     = `$true
                'Scope'       = 'It'
            }
            Assert-MockCalled @assertMockParams |Should -BeTrue -Because "This parameter will use the Get-DBaDatabase function"
        }
    }
}
"@
Set-Content .\Unit.Tests.ps1 -Value $test

## Then we run the test using Invoke-Pester (Which will run all of the *.Tests.ps1)

Invoke-Pester 