Import-Module 'GIT:\PassSummit2018-Preon\slides-and-demos\03 - Modules\MirroringModule.psm1'

Get-Module MirroringModule

Get-Command -Module MirroringModule

Get-Help New-BeardSQLEndpoint -Detailed
Get-Help Start-BeardSQLMirroring -Detailed

$Databases = '',''

$ServerPrimary = ''
$ServerSecondary = ''

$EndpointPort = 7022

New-BeardSQLEndpoint  -SqlInstance $ServerPrimary -EndpointName 'Module-Endpoint' -EndpointPort $EndpointPort
New-BeardSQLEndpoint  -SqlInstance $ServerSecondary -EndpointName 'Module-Endpoint' -EndpointPort $EndpointPort

$Databases.ForEach{
    Backup-DbaDatabase -SqlInstance $ServerPrimary -Database $Psitem -BackupFileName $FileShare+$Psitem+"_full.bak"
    Backup-DbaDatabase -SqlInstance $ServerPrimary -Database $Psitem -BackupFileName  $FileShare+$Psitem+"_log.trn"
    Restore-DbaDatabase -SqlInstance $ServerSecondary -Database $Psitem -Path $FileShare+$Psitem+"_full.bak" -NoRecovery -WithReplace
    Restore-DbaDatabase -SqlInstance $ServerSecondary -Database $Psitem -Path $FileShare+$Psitem+"_log.trn" -NoRecovery -WithReplace
}

Start-BeardSQLMirroring -SQLInstance1 $ServerPrimary -SQLInstance2 $ServerSecondary -EndpointPort $EndpointPort
Start-BeardSQLMirroring -SQLInstance1 $ServerSecondary -SQLInstance2 $ServerPrimary -EndpointPort $EndpointPort