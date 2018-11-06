# Script to set up Mirroring

#Setup some basic variables
$ServerPrimaryName = $SQLMirror1
$ServerSecondaryName = $SQLMirror2

#Let's do multiple databases
$Databases = ("Sales", "SalesArchive")

#Both SQL Server instances should have read/write to here
$FileShare = $NetworkShare

#Get all dbs onto the same log:
foreach ($db in $Databases) {
    $fullBak = "$FileShare\$db" + "_full.bak"
    $Logtrn = "$FileShare\$db" + "_log.trn"
    Backup-DbaDatabase -SqlInstance $ServerPrimaryName -Database $db -BackupFileName $fullBak 
    Backup-DbaDatabase -SqlInstance $ServerPrimaryName -Database $db -Type Log -BackupFileName  $Logtrn 
}
$FileShare | Restore-DbaDatabase -SqlInstance $ServerSecondaryName -WithReplace -NoRecovery 
#Now we need to create a TCP Mirroring EndPoint on each Server
$ServerPrimary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerPrimaryName)
$ServerSecondary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerSecondaryName)
 
$EPName = "DBMirror-PS"
$EPPort = 7022

$PrimaryEP = New-Object Microsoft.SqlServer.Management.SMO.Endpoint -ArgumentList $ServerPrimary, $EPName
$PrimaryEP.ProtocolType = [Microsoft.SqlServer.Management.SMO.ProtocolType]::Tcp  
$PrimaryEP.EndpointType = [Microsoft.SqlServer.Management.SMO.EndpointType]::DatabaseMirroring  
$PrimaryEP.Protocol.Tcp.ListenerPort = $EPPort  
$PrimaryEP.Payload.DatabaseMirroring.ServerMirroringRole = [Microsoft.SqlServer.Management.SMO.ServerMirroringRole]::All  

$PrimaryEP.Create()
$PrimaryEP.Start()

$SecondaryEP =  New-Object Microsoft.SqlServer.Management.SMO.Endpoint -ArgumentList $ServerSecondary, $EPName
$SecondaryEP.ProtocolType = [Microsoft.SqlServer.Management.Smo.ProtocolType]::Tcp
$SecondaryEP.EndpointType = [Microsoft.SqlServer.Management.Smo.EndpointType]::DatabaseMirroring
$SecondaryEP.Protocol.Tcp.ListenerPort = $EPPort
$SecondaryEP.Payload.DatabaseMirroring.ServerMirroringRole = [Microsoft.SqlServer.Management.Smo.ServerMirroringRole]::Partner
$SecondaryEP.Create()
$SecondaryEP.Start()

$ServerPrimary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerPrimaryName)
$ServerSecondary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerSecondaryName)
 
$PrimaryPartner = "TCP://" + $ServerPrimary.Information.FullyQualifiedNetName + ":" + $EPPort
$SecondaryPartner = "TCP://" + $ServerSecondary.Information.FullyQualifiedNetName + ":" + $EPPort

foreach ($db in $Databases) {

   ## Doesnt work :-(
    #$ServerSecondary.Databases[$db].MirroringPartner = $PrimaryPartner
    #$ServerSecondary.Databases[$db].alter()
    #$ServerPrimary.Databases[$db].MirroringPartner = $SecondaryPartner
    #$ServerPrimary.Databases[$db].alter()
    $query = "ALTER DATABASE $db SET PARTNER = '$PrimaryPartner' "
    Invoke-DbaSqlQuery -SqlInstance $SQLMirror2 -Database master -Query $query  
    $query = "ALTER DATABASE $db SET PARTNER = '$SecondaryPartner' "
    Invoke-DbaSqlQuery -SqlInstance $SQLMirror1 -Database master -Query $query  
}

