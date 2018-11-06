# Script to set up Mirroring for $SQLMirror1 and $SQLMirror2 for dbs "Sales", "SalesArchive"


Import-Module 'PASSSUMMIT:\slides-and-demos\03 - Modules\MirroringModule.psm1'

$Databases = "Sales", "SalesArchive"

$ServerPrimary = $SQLMirror1
$ServerSecondary = $SQLMirror2

$FileShare = $NetworkShare

$EndpointPort = 7022

$newBeardSQLEndpointSplat = @{
    SqlInstance = $ServerPrimary
    EndpointName = 'Module-Endpoint'
    EndpointPort = $EndpointPort
}
New-BeardSQLEndpoint  @newBeardSQLEndpointSplat
New-BeardSQLEndpoint  -SqlInstance $ServerSecondary -EndpointName 'Module-Endpoint' -EndpointPort $EndpointPort


$Databases.ForEach{
    $fullBak = "$FileShare\$psitem" + "_full.bak"
    $Logtrn = "$FileShare\$psitem" + "_log.trn"
    Backup-DbaDatabase -SqlInstance $ServerPrimary -Database $psitem -BackupFileName $fullBak 
    Backup-DbaDatabase -SqlInstance $ServerPrimary -Database $psitem -Type Log -BackupFileName  $Logtrn 
}

$FileShare | Restore-DbaDatabase -SqlInstance $ServerSecondary -WithReplace -NoRecovery 

$Databases.ForEach{
    Start-BeardSQLMirroring -SQLInstance1 $ServerSecondary -SQLInstance2 $ServerPrimary -DatabaseName $psitem -EndpointPort $EndpointPort
    Start-BeardSQLMirroring -SQLInstance1 $ServerPrimary -SQLInstance2 $ServerSecondary -DatabaseName $psitem -EndpointPort $EndpointPort
}