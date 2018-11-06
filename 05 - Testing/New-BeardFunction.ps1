function New-BeardFunction{
    Param($Instance,$Database)

    if($Database){
        $DbSize = (Get-DbaDatabase -SqlInstance $Instance -Database $Database).Size
    }

    [PSCustomObject] @{
        SQLInstance = $Instance
        Database = $Database
        Size = $dbSize
    }
}
