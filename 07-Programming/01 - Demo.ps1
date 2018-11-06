$VMName = $ENV:COMPUTERNAME

## Exploring and learning how to find ANYTHING with PowerShell

$computerInfo = Get-CimInstance Win32_ComputerSystem -ComputerName $VMName 

$computerInfo | Get-Member

$computerInfo | Select *

# You might be tempted to do this
function Get-BeardXPS {
    Param ($VMName)

    $computerInfo = Get-CimInstance Win32_ComputerSystem -ComputerName $VMName 

    Write-Host "Domain is $($computerInfo.Domain)"
    Write-Host "Manufacturer is $($computerInfo.Manufacturer)"
    Write-Host "Model is $($computerInfo.Model)"
    Write-Host "Total Physical Memory is $($computerInfo.TotalPhysicalMemory)"
    Write-Host "Number Of Logical Processors is $($computerInfo.NumberOfLogicalProcessors)"
}

Get-BeardXPS -VMName CEA1513
#Install-Module dbatools -Scope CurrentUser
# but the beauty of PowerShell is objects and 

Get-BeardXPS -VMName CEA1513 | ConvertTo-Csv
Get-BeardXPS -VMName CEA1513 | ConvertTo-Json
Get-BeardXPS -VMName CEA1513 | ConvertTo-Xml

Get-BeardXPS -VMName CEA1513 | Write-DbaDataTable -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Table CompInfo -AutoCreateTable

Invoke-DbaQuery -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Query "SELECT * FROM CompInfo"
Invoke-DbaQuery -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Query "DROP TABLE CompInfo"


# ah maybe we need output

function Get-BeardXPS {
    Param ($VMName)

    $computerInfo = Get-CimInstance Win32_ComputerSystem -ComputerName $VMName 

    Write-Output "Domain is $($computerInfo.Domain)"
    Write-Output "Manufacturer is $($computerInfo.Manufacturer)"
    Write-Output "Model is $($computerInfo.Model)"
    Write-Output "Total Physical Memory is $($computerInfo.TotalPhysicalMemory)"
    Write-Output "Number Of Logical Processors is $($computerInfo.NumberOfLogicalProcessors)"
}

Get-BeardXPS -VMName CEA1513

# but

Get-BeardXPS -VMName ROB-XPS | ConvertTo-Csv
Get-BeardXPS -VMName ROB-XPS | ConvertTo-Json
Get-BeardXPS -VMName ROB-XPS | ConvertTo-Xml

Get-BeardXPS -VMName ROB-XPS | Write-DbaDataTable -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Table CompInfo -AutoCreateTable

Invoke-DbaQuery -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Query "SELECT * FROM CompInfo"
Invoke-DbaQuery -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Query "DROP TABLE CompInfo"


# much better to return an object 

function Get-BeardXPS {
    Param ($VMName)

    $computerInfo = Get-CimInstance Win32_ComputerSystem -ComputerName $VMName 

    [PSCustomObject]@{
        Domain                    = $computerInfo.Domain
        Manufacturer              = $computerInfo.Manufacturer
        Model                     = $computerInfo.Model
        TotalPhysicalMemory       = $computerInfo.TotalPhysicalMemory
        NumberOfLogicalProcessors = $computerInfo.NumberOfLogicalProcessors
    }
}

clear

Get-BeardXPS -VMName CEA1513

clear

# then

Get-BeardXPS -VMName CEA1513 | ConvertTo-Csv

clear

Get-BeardXPS -VMName CEA1513 | ConvertTo-Json

clear

Get-BeardXPS -VMName CEA1513 | ConvertTo-Xml

clear

Get-BeardXPS -VMName ROB-XPS | Write-DbaDataTable -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Table CompInfo -AutoCreateTable


Invoke-DbaQuery -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Query "SELECT * FROM CompInfo"

Invoke-DbaQuery -SqlInstance $ENV:COMPUTERNAME -Database tempdb -Query "DROP TABLE CompInfo"

## CmdletBinding

# I have seen code like this

function Get-BeardFilesFromBackupLocationInDatabase {
    switch ($ENV:COMPUTERNAME) {
        'ROB-XPS' { Get-ChildItem C:\MSSQL\BACKUP\ROB-XPS\BeardTest\FULL }
        'JumpBox' { Get-ChildItem  C:\SQLBackups\BeardTest}
    }
}

function Restore-BeardDatabase {
    Param ($SQLInstance,
        [switch]$WhatIf,
        [switch]$Confirm
    )

    $BackupFiles = Get-BeardFilesFromBackupLocationInDatabase

    if ($WhatIf) {
        Write-Host "We will be restoring $Backupfiles to $SQLInstance"
    }
    if ($Confirm) {
        Read-Host "Press a key to restore $BackupFiles to $SQLInstance"
    }
}

Restore-BeardDatabase -SQLInstance ROB-XPS -WhatIf

Restore-BeardDatabase -SQLInstance ROB-XPS -Confirm

function Restore-BeardDatabase {
    [CmdletBinding(SupportsShouldProcess)]
    Param ($SQLInstance
    )
    $BackupFiles = Get-BeardFilesFromBackupLocationInDatabase

    if ($PSCmdlet.ShouldProcess("$SQLInstance" , "$BackupFiles restoring to ")) {
       # $SQLInstance
    }
}
