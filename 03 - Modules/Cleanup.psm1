function Check-MirroringStatus {
    $ServerPrimary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror1)
    $ServerSecondary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror2)
    $primaryDB1 = $ServerPrimary.Databases['Sales']
    $primaryDB2 = $ServerPrimary.Databases['SalesArchive']

    # We can look in SSMS if you like :-)

    Write-Output "Sales database mirroring status is $($primaryDB1.MirroringStatus)"
    Write-Output "SalesArchive database mirroring status is $($primaryDB2.MirroringStatus)"
}

function Remove-MirroringScript {
    $ServerPrimary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror1)
    $ServerSecondary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror2)
    
    $primaryDB1 = $ServerPrimary.Databases['Sales']
    $primaryDB2 = $ServerPrimary.Databases['SalesArchive']

    $primaryDB1.ChangeMirroringState([Microsoft.SqlServer.Management.Smo.MirroringOption]::Off)
    $primaryDB2.ChangeMirroringState([Microsoft.SqlServer.Management.Smo.MirroringOption]::Off)
    
    $ServerPrimary.Endpoints['DBMirror-PS'].Drop() 
    $ServerSecondary.Endpoints['DBMirror-PS'].Drop() 

    $session = New-PSSession $SQLMirror2.Split('\')[0]
    Invoke-Command -Session $session -ScriptBlock {Restart-Service 'MSSQL$Mirror'}
    $session | Remove-PSSession
    
    Get-ChildItem $NetworkShare | Remove-Item -Force
}

function Remove-MirroringFunction {
    $ServerPrimary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror1)
    $ServerSecondary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror2)
    
    $primaryDB1 = $ServerPrimary.Databases['Sales']
    $primaryDB2 = $ServerPrimary.Databases['SalesArchive']

    $primaryDB1.ChangeMirroringState([Microsoft.SqlServer.Management.Smo.MirroringOption]::Off)
    $primaryDB2.ChangeMirroringState([Microsoft.SqlServer.Management.Smo.MirroringOption]::Off)

    $ServerPrimary.Endpoints['Function-Endpoint'].Drop() 
    $ServerSecondary.Endpoints['Function-Endpoint'].Drop() 

    $session = New-PSSession $SQLMirror2.Split('\')[0]
    Invoke-Command -Session $session -ScriptBlock {Restart-Service 'MSSQL$Mirror'}
    $session | Remove-PSSession

    Get-ChildItem $NetworkShare | Remove-Item -Force
}

function Remove-MirroringPsm1 {
    $ServerPrimary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror1)
    $ServerSecondary = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($SQLMirror2)

    $primaryDB1 = $ServerPrimary.Databases['Sales']
    $primaryDB2 = $ServerPrimary.Databases['SalesArchive']

    $primaryDB1.ChangeMirroringState([Microsoft.SqlServer.Management.Smo.MirroringOption]::Off)
    $primaryDB2.ChangeMirroringState([Microsoft.SqlServer.Management.Smo.MirroringOption]::Off)

    $ServerPrimary.Endpoints['Module-Endpoint'].Drop() 
    $ServerSecondary.Endpoints['Module-Endpoint'].Drop() 

    $session = New-PSSession $SQLMirror2.Split('\')[0]
    Invoke-Command -Session $session -ScriptBlock {Restart-Service 'MSSQL$Mirror'}
    $session | Remove-PSSession

    Get-ChildItem $NetworkShare | Remove-Item -Force
}