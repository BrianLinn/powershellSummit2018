try {
    ## put your code in here

    # It MUST be a Terminating Error to hit the catch
}
catch {
    # Put your response to the error here
}

## Must be a terminating error

try {
    Get-ChildItem c:\ItsNotThere -ErrorAction Stop
}
catch {
    Write-PSFHostColor "There was an error" -DefaultColor Red
}

# because this isn't a terminating error

# we can force this in two ways

# using -ErrorAction Stop

try {
    Get-ChildItem c:\ItsNotThere -ErrorAction Stop
}
catch {
    Write-PSFHostColor "There was an error" -DefaultColor Red
}

# or by setting erroractionpreferences to Stop

$ErrorActionPreference = 'Stop'

try {
    Get-ChildItem c:\ItsNotTHere -ErrorAction Stop
}
catch {
    Write-PSFHostColor "There was an error" -DefaultColor Red
}

# Dont forget to clear it

$ErrorActionPreference = 'SilentlyContinue'

# Confusingly Get-ChildItem is none-terminating for none existing

# But Get-AdComputer IS terminating!

$VMName = 'ItIsNotThere'

Get-ADComputer -Identity $VMName 

try {
    Get-ADComputer -Identity $VMName 
}
catch {
    Write-PSFHostColor "There was an error" -DefaultColor Red
}

# So how do we tell if it is terminating or not?
# I dont have a good answer to that!

## Lets catch a specific error

## create a folder and add specific permissions to it

## create a folder and add specific permissions to it

$folder = 'C:\temp\LockedDownBackUp'
New-Item $folder -ItemType Directory
(0..5) | ForEach-Object { New-Item -Path $folder -Name $PSItem -ItemType File }

Get-ChildItem $folder

$acl = Get-Acl $folder

# BE CAREFUL - This is locking your own user account out
$User = whoami
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$User", "Read", "ContainerInherit, ObjectInherit", "None", "Deny")

$acl.AddAccessRule($rule)
Set-Acl -path $folder $acl

# Now open Powershell and run

Get-ChildItem C:\temp\LockedDownBackUp

# You need to know what the exception type is 

$error[0].Exception.Gettype().FullName

function CanIaccess {
    Param($folder)

    try {
        Get-ChildItem $folder -ErrorAction Stop
    }
    catch [System.UnauthorizedAccessException] {
        Write-PSFHostColor "I am not allowed in " 
    }
    catch [System.Management.Automation.ItemNotFoundException] {
        Write-PSFHostColor "It Isnt there " 
    }
    catch {
        Write-PSFHostColor "Failed for a different reason" 
    }
}
#Install-Module PSFramework -Scope CurrentUser
CanIaccess -folder C:\temp\LockedDownBackUp
CanIaccess -folder C:\temp\NotThere