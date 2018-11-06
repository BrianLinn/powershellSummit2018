<#
.SYNOPSIS
Creates a mirroring Endpoint

.DESCRIPTION
Sets up and starts a Mirroring endpoint on the SQL Instance specified

.PARAMETER SqlInstance
The SQL Instance to add the endpoint

.PARAMETER EndpointName
The name of the Endpoint

.PARAMETER EndpointPort
The port the Endpoint will use

.EXAMPLE
New-BeardSQLEndpoint -SQLInstance SQL0 -EndpointName ModuleEndpoint -EndpointPort 7022

Creates a mirroring endpoint called Module Endpoint using port 7022 on Instance SQL0

.NOTES
Created the function - RMS - 28-07-2018
#>
function New-BeardSQLEndpoint {
    Param (
        [string]$SqlInstance,
        [string]$EndpointName,
        [int]$EndpointPort
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

<#
.SYNOPSIS
Starts Mirroring for a database

.DESCRIPTION
Starts mirroring for a database on two SQL Instances

.PARAMETER SQLInstance1
The Primary Instance for the database

.PARAMETER SQLInstance2
The Secondary Instance for the database

.PARAMETER DatabaseName
The database to set up mirroring for

.PARAMETER EndpointPort
The Port that the mirroring endpoint is using

.EXAMPLE
Start-BeardSQLMirroring -SQLInstance1 SQL0 -SQLInstance2 SQL1 -Database Sales -EndpointPort 7022

.NOTES
Created function - RMS 28-07-2018
#>  
function Start-BeardSQLMirroring {
    Param (
        [string]$SQLInstance1,
        [string]$SQLInstance2,
        [string]$DatabaseName,
        [int]$EndpointPort
    )

    ## Doesnt work with SQL2017  :-(
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
