# Use the variables to tell which host you are running on so that you can do things like

function Use-DiffPS {
    if ($IsCoreCLR) {
        Import-Module SqlServer
        if ($IsWindows) {
            Write-PSFHostColor -String "This is Windows and Version 6" -DefaultColor DarkBlue
            (Get-ChildItem SQLSERVER:\SQL\Rob-XPS\DEFAULT\Databases).Name | Select-Object -First 5
        }
        elseif ($IsLinux) {
            Write-PSFHostColor -String "This is Linux and Version 6" -DefaultColor DarkYellow
            Write-PSFHostColor -String "But running pwsh in WSL on Windows really doesnt work with sqlserver module!!" -DefaultColor DarkYellow
           # Get-ChildItem SQLSERVER:\SQL\Rob-XPS\DEFAULT\Databases 
        }
    }
    else {
        Write-PSFHostColor -String "This is Version 5" -DefaultColor DarkMagenta
        (Get-DbaDatabase -SqlInstance ROB-XPS).Name | Select -first 5
    }
}

# Switch to PowerShell 6 and load module

Use-DiffPS

# then type this into the console and copy and paste the function
bash

pwsh

# Then exit out and change to WIndows 5.1 and run the function again

# It's pretty easy really
