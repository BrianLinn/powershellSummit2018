#region Create a share
$ShareName = 'BeardPSRepository'
$Path = '\\jumpbox\' + $ShareName
$ShareFolder = 'C:\BeardPSRepository'
$Full = 'THEBEARD\Domain Admins'
$Change = 'THEBEARD\Domain Users'
$Read = 'EveryOne'
if (-not (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue)) {
    if (-not (Test-Path $ShareFolder)) {
        New-Item $ShareFolder -ItemType Directory
    }

    $newSMBShareSplat = @{
        Name         = $ShareName
        FullAccess   = $Full
        ChangeAccess = $Change
        Path         = $ShareFolder
        Description  = "Location for the Beard PowerShell Repository"
        ReadAccess   = $Read
    }
    New-SMBShare @newSMBShareSplat -Verbose
}
#endregion

#region Register the repository
$repo = @{
    Name = 'BeardRepository'
    SourceLocation = $Path
    PublishLocation = $Path
    InstallationPolicy = 'Trusted'
}
Register-PSRepository @repo

Get-PSRepository

#endregion

Get-Module Pester -ListAvailable 
Import-Module Pester -RequiredVersion 4.3.1
Publish-Module -Name Pester -RequiredVersion 4.3.1 -Repository BeardRepository -Verbose

Explorer C:\BeardPSRepository

Find-Module -Repository BeardRepository

Remove-Module Pester
Install-Module -Name Pester -Repository BeardRepository -Verbose