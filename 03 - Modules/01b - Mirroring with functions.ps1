
function Create-Endpoint {
    Param (
        $SqlInstance,
        $EndpointName,
        $EndpointPort
    )

    $SmoObject = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SqlInstance)

    $EP = New-Object Microsoft.SqlServer.Management.SMO.Endpoint -ArgumentList $SmoObject, $EndpointName
    $EP.ProtocolType = [Microsoft.SqlServer.Management.SMO.ProtocolType]::Tcp  
    $EP.EndpointType = [Microsoft.SqlServer.Management.SMO.EndpointType]::DatabaseMirroring  
    $EP.Protocol.Tcp.ListenerPort = $EndpointPort  
    $EP.Payload.DatabaseMirroring.ServerMirroringRole = [Microsoft.SqlServer.Management.SMO.ServerMirroringRole]::All  

    $EP.Create()
    $EP.Start()
}

function Start-Mirroring {
    Param (
        $SQLInstance1,
        $SQLInstance2,
        $DatabaseName,
        $EndpointPort
    )

    ## Doesnt work :-(
    # $SmoObject1 = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SqlInstance1)
    # $SmoObject2 = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SqlInstance2)

    # $SmoObject1.Databases[$DatabaseName].MirroringPartner = "TCP://" + $SmoObject2.NetName + ":" + $EndpointPort 
    # $SmoObject1.Databases[$DatabaseName].alter()
    $Instance1 = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLInstance1)
    $Instance2 = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLInstance2)

    $Partner = "TCP://" + $Instance2.Information.FullyQualifiedNetName + ":" + $EndpointPort

    $query = "ALTER DATABASE $DatabaseName SET PARTNER = '$Partner' "
    Invoke-DbaSqlQuery -SqlInstance $SQLInstance1 -Database master -Query $query  
}

$Databases = "Sales", "SalesArchive"

$ServerPrimary = $SQLMirror1
$ServerSecondary = $SQLMirror2

$EndpointPort = 7022

$FileShare = $NetworkShare

Create-Endpoint -SqlInstance $ServerPrimary -EndpointName 'Function-Endpoint' -EndpointPort $EndpointPort
Create-Endpoint -SqlInstance $ServerSecondary -EndpointName 'Function-Endpoint' -EndpointPort $EndpointPort

foreach ($db in $Databases) {
    $fullBak = "$FileShare\$db" + "_full.bak"
    $Logtrn = "$FileShare\$db" + "_log.trn"
    Backup-DbaDatabase -SqlInstance $ServerPrimary -Database $db -BackupFileName $fullBak 
    Backup-DbaDatabase -SqlInstance $ServerPrimary -Database $db -Type Log -BackupFileName  $Logtrn 
}

$FileShare | Restore-DbaDatabase -SqlInstance $ServerSecondary -WithReplace -NoRecovery 

foreach ($db in $Databases) {
    Start-Mirroring -SQLInstance1 $ServerSecondary -SQLInstance2 $ServerPrimary -DatabaseName $db -EndpointPort $EndpointPort
    Start-Mirroring -SQLInstance1 $ServerPrimary -SQLInstance2 $ServerSecondary -DatabaseName $db -EndpointPort $EndpointPort
}