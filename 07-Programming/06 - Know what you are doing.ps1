#region 
cd 'GIT:\PassSummit2018-Precon\Slides-and-Demos\07-Programming\'
$x = Get-Content test.txt

$x[0]

$x = Get-Content test.txt -Raw

$x[0]

#endregion

#region
$GetContent = Measure-Command {
    $x = Get-Content test.txt
    $x -replace "t","x" | Out-File new.txt
}

rm .\new.txt

$GetContentForEach = Measure-Command {
    ForEach ($line in (Get-Content test.txt)) {
        $line -replace "\d","x" | Out-File new.txt -Append
      }
}

rm .\new.txt

$StreamReader = Measure-Command {
    $filepath = Get-Childitem -Path test.txt
    $file = New-Object System.IO.StreamReader($filepath)
    while ($line = $file.ReadLine()) {
        $line -replace "\d","x" | Out-File new.txt -Append
    }
    $file.close()
}

rm .\new.txt

#endregion

#region Results
Write-Output "Get Content Milliseconds = $($GetContent.Milliseconds)"

Write-Output "Get Content For Each Milliseconds = $($GetContentForeach.Milliseconds)"

Write-Output "Stream Reader Milliseconds = $($StreamReader.Milliseconds)"

#endregion

<#

There is a MUCH cooler way of showing the difference between command runs

This is using 

$Runtime = [System.Diagnostics.Stopwatch]::StartNew()
$Runtime.Stop()

and Adam Driscolls Universal Dashboard @adamdriscoll

https://ironmansoftware.com/universal-dashboard

and code from Josh King @WindosNZ demo'd at the PowerShell Summit
#>

#region Being Verbose Saves Time

$Control = {
    $Services = Service | ? Status -eq Running | select -F 5
}

$Variation = {
    $Services = Get-Service | Where-Object Status -eq Running | Select-Object -First 5
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Verbosity is quicker'

#endregion

#region Pipelines
$Control = {
    Get-ChildItem -Path C:\temp | where Length -gt 5000
}

$Variation = {
    (Get-ChildItem -Path C:\temp).where({$_.Length -gt 5000})
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Pipelines'

#endregion

#region Going Loopy

$Control = {
    $TotalLength = 0

    Get-ChildItem -Path C:\temp\ | foreach {
        $TotalLength += $_.Length
    }
}

$Variation = {
    $TotalLength = 0

    $Items = Get-ChildItem -Path C:\temp\

    foreach ($Item in $Items) {
        $TotalLength += $Item.Length
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Loops'

#endregion

#region Going Loopier

$Control = {
    $TotalLength = 0

    $Items = Get-ChildItem -Path C:\temp\

    foreach ($Item in $Items) {
        $TotalLength += $Item.Length
    }
}

$Variation = {
    $TotalLength = 0

    $Items = Get-ChildItem -Path C:\temp\

    $Items.ForEach{
        $TotalLength += $Item.Length
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Loops - Methods'

#endregion

#region Use Naked .NET

$Control = {
    foreach ($i in 1..1000) {
        New-Guid
    }
}

$Variation = {
    foreach ($i in 1..1000) {
        [guid]::NewGuid()
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Naked .NET'

#endregion


#region Becoming a Collector

$Control = {
    $Collection = @()

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
        $Collection += $Random.Next(0,1000)
    }
}

$Variation = {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
        $Collection.Add($Random.Next(0,1000))
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Collections'

#endregion

#region Becoming a Hoarder

$Control = {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
        $Collection.Add($Random.Next(0,1000))
    }
}

$Variation = {
    $Random = New-Object -TypeName System.Random

    $Collection = foreach ($i in 1..1000) {
        $Random.Next(0,1000)
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Collections Continued'

#endregion

#region Get a (PoshRS)Job!

$Control = {
    $Targets = @('8.8.8.8','8.8.4.4','9.9.9.9','stuff.co.nz')

    foreach ($Target in $Targets) {
        $Response = Test-Connection -ComputerName $Target -Count 2 -Quiet

        [PSCustomObject] @{
            Host = $Target
            Online = $Response
        }
    }
}

$Variation = {
    $Targets = @('8.8.8.8','8.8.4.4','9.9.9.9','stuff.co.nz')

    $Targets | Start-RSJob -Name {$_} -ScriptBlock {
        $Response = Test-Connection -ComputerName $_ -Count 2 -Quiet

        [PSCustomObject] @{
            Host = $_
            Online = $Response
        }
    } | Wait-RSJob | Receive-RSJob
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Parallel Job' -Iterations 5
#endregion

Get-UDDashboard | Stop-UDDashboard