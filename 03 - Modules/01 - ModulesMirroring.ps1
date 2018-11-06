#Load variables
. .\setup\vars.ps1 

# You can write scripts
Import-Module '.\slides-and-demos\03 - Modules\Cleanup.psm1' -DisableNameChecking

Open-EditorFile '.\slides-and-demos\03 - Modules\01a - Setup Mirroring.ps1' 

# Works really well

& '.\slides-and-demos\03 - Modules\01a - Setup Mirroring.ps1'

## Lets Check it

Check-MirroringStatus 

# We can look in SSMS if you like :-)

# Remove it

Remove-MirroringScript

# We want to use functions so that we can re-use our code

Open-EditorFile '.\slides-and-demos\03 - Modules\01b - Mirroring with functions.ps1'

# Lets Check it

Check-MirroringStatus 

# Remove it

Remove-MirroringFunction

# Thats very cool but you are still CTRL C and V ing to copy those functions around when you want to re-use your code

# So we can create a psm1 file and import it as a module

Open-EditorFile 'PASSSUMMIT:\slides-and-demos\03 - Modules\MirroringModule.psm1'

Import-Module 'PASSSUMMIT:\slides-and-demos\03 - Modules\MirroringModule.psm1'

Get-Module MirroringModule

Get-Command -Module MirroringModule

Get-Help New-BeardSQLEndpoint -Detailed
Get-Help Start-BeardSQLMirroring -Detailed

## and create a mirror

Open-EditorFile 'PassSummit:\slides-and-demos\03 - Modules\01c - SetUp Mirroring With psm1.ps1'

# Lets Check it

Check-MirroringStatus 

# Remove it

Remove-MirroringPsm1

# Time for alittle trick that you will like

Open-EditorFile 'PassSummit:\slides-and-demos\03 - Modules\02 - Splatting.ps1'