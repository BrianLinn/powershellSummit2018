## One of my favourite things in VS Code

# No longer do you need to have scrolling lines of code with parameter after parameter
# Its easy to write with intellisense but its hard to read and it's hard to alter

# take this for an example

Restore-DbaDatabase -SqlInstance $Instance -SqlCredential $cred -Path $path -DatabaseName $Databases -DestinationDataDirectory $DestDataDir -DestinationLogDirectory $destlogDir -WithReplace 

# Be much easier if it looks like this

$restoreDbaDatabaseSplat = @{
    SqlCredential            = $cred
    Path                     = $path
    SqlInstance              = $Instance
    DestinationLogDirectory  = $destlogDir
    DestinationDataDirectory = $DestDataDir
    DatabaseName             = $Databases
    WithReplace              = $true
}
Restore-DbaDatabase @restoreDbaDatabaseSplat 

# Now before someone says what about using the backtick for new lines

# First problem - got to type it out 

# Alter this to use backticks and show the second problem

Restore-DbaDatabase -SqlInstance $Instance -SqlCredential $cred -Path $path  -DatabaseName $Databases  -DestinationDataDirectory $DestDataDir -DestinationLogDirectory $destlogDir -WithReplace 









# So luckily the PSScriptAnalyzer Rule in VS COde will show us but in other editors are you going to notice a space after a backtick

## This is so much easier

## Install this module

Install-Module EditorServicesCommandSuite -Scope CurrentUser

# Create a profile if you dont have one

if (-not (Test-Path $profile)) {
    New-Item -ItemType File -Path $profile
}

# Add this to your profile

Import-Module EditorServicesCommandSuite
Import-EditorCommand -Module EditorServicesCommandSuite

## Then you can do this

# Put your cursor on the line F1 - type add to get the Show Additional Commands
# Hit Enter - Type Splat - Hit Enter

Restore-DbaDatabase -SqlInstance $Instance -SqlCredential $cred -Path $path  -DatabaseName $Databases  -DestinationDataDirectory $DestDataDir -DestinationLogDirectory $destlogDir -WithReplace

# Magic :-)
