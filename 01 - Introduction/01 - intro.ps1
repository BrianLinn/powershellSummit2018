Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#BI
$WindowTitle = "Introduction"
$NoBanner = $True
#/B

#H WELCOME TO PASS SUMMIT

#BI
$Host.UI.RawUI.ForegroundColor = 'Yellow'
$Host.UI.RawUI.BackgroundColor = 'DarkGreen'
cls
$WindowTitle = "Introduction"
$NoBanner = $True
Write-Output "Hello !!!!"
""
#/B

#BI
$Host.UI.RawUI.ForegroundColor = 'Cyan'
$Host.UI.RawUI.BackgroundColor = 'DarkMagenta'
cls
$WindowTitle = "Introduction"
$NoBanner = $True
Write-Output "Hello !!!!"
""
Write-Output "We are going to have a great day"
#/B

#BI
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.UI.RawUI.BackgroundColor = 'DarkBlue'
cls
$WindowTitle = "Introduction"
$NoBanner = $True
Write-Output "Hello !!!!"
""
Write-Output "We are going to have a great day"
#/B

#CY How did we do that ?
#
#CY We will learn a whole load of things today
#
#CY First up - Who Am I ? 
#B

#/B

#BI
Function WhoAmI {
    Param(
        [switch]$Name,
        [switch]$Contact,
        [switch]$Work,
        [switch]$CommunitySQL,
        [switch]$CommunityPowerShell,
        [switch]$OpenSource,
        [switch]$Fun
    )
    $Host.UI.RawUI.ForegroundColor = 'White'
$Host.UI.RawUI.BackgroundColor = 'LightBlue'
    if($Name){
        Write-Output ""
        Write-Output "      First Name      -       Rob"
        Write-Output "      Surname         -       Sewell"
        Write-Output ""        
    }
    if($Contact){
        Write-Output ""        
        Write-Output "      Twitter         -       @SQLDBAWithBeard"
        Write-Output "      Email           -       mrrobsewell@outlook.com"
        Write-Output "      Blog            -       https://sqldbawithabeard.com"
        Write-Output "      GitHub          -       github.com/SQLDBAWithABeard"
        Write-Output "      LinkedIn        -       LINKEDINURL"
        Write-Output ""        
    }
    if($Work){
        Write-Output ""        
        Write-Output "      I love to work with PowerShell and CI/CD solutions to automate things"        
        Write-Output ""        
        Write-Output "      I usually work with Data Platform Solutions"
        Write-Output ""        
        Write-Output "      I also take training sessions"        
        Write-Output ""                                
        Write-Output "      Available for hire  -   RobSewell.Info"                                
        Write-Output ""                                
    }
    if($CommunitySQL){
        Write-Output ""        
        Write-Output "      Organiser     -       SQL South West User Group"        
        Write-Output ""        
        Write-Output "      Organiser     -       PASS VG DevOps"        
        Write-Output ""        
        Write-Output "      Volunteer     -       SQL Saturdays"        
        Write-Output "      Volunteer     -       SQLBits"        
        Write-Output ""        
        Write-Output "      Speaker       -       User Groups - Local and Virtual"        
        Write-Output "      Speaker       -       SQL Saturdays"        
        Write-Output "                                      Exeter"        
        Write-Output "                                      Manchester - PreCon"        
        Write-Output "                                      Cambridge"        
        Write-Output "                                      Dublin"        
        Write-Output "                                      Vienna - PreCon"        
        Write-Output "                                      Slovenia"        
        Write-Output "                                      Reykjavik - PreCon"        
        Write-Output "                                      Holland"        
        Write-Output "                                      Finland"        
        Write-Output "                                      Gothenburg"        
        Write-Output "                                      Oslo - PreCon"      
        Write-Output "      Speaker       -       SQLRelay"                  
        Write-Output "                                      Reading"        
        Write-Output "                                      Nottingham"        
        Write-Output "                                      Leeds"        
        Write-Output "                                      Birmingham"        
        Write-Output "                                      Bristol"        
        Write-Output "              ALL IN ONE WEEK!!!"        
        Write-Output ""        
        Write-Output "      Speaker       -       Techorama       - Antwerp"        
        Write-Output "      Speaker       -       DataMinds       - Ghent - PreCon"        
        Write-Output "      Speaker       -       MSCloudSummit   - Paris - PreCon"        
        Write-Output ""                                
        Write-Output "      Speaker       -       SQLBits - PreCon"                
        Write-Output ""                
    }
    if($CommunityPowerShell){
        Write-Output ""        
        Write-Output "      Organiser     -       PowerShell Conference Europe"
        Write-Output "                                                       2016"        
        Write-Output "                                                       2017"        
        Write-Output "                                                       2018"         
        Write-Output "                                                       2019"         
        Write-Output ""        
        Write-Output "      Organiser     -       PSDay.UK"        
        Write-Output ""        
        Write-Output "      Speaker       -       PowerShell Conference Europe"        
        Write-Output "                                                       2016"        
        Write-Output "                                                       2017"        
        Write-Output "                                                       2018"        
        Write-Output ""        
        Write-Output "      Speaker       -       PowerShell Conference Asia"        
        Write-Output "                                                       2016"        
        Write-Output "                                                       2017"        
        Write-Output ""             
        Write-Output "      Speaker       -       PowerShell Saturday/Monday/Day"        
        Write-Output "                                                       London"        
        Write-Output "                                                       Stuttgart"        
        Write-Output "                                                       Munich"        
        Write-Output ""        
        Write-Output "      Speaker       -       PowerShell User Groups"        
        Write-Output "                                                  UK/Germany/Holland"        
        Write-Output ""        
        
    }
    if($OpenSource){
        Write-Output ""                
        Write-Output "      Contributor               -       dbatools"           
        Write-Output ""                             
        Write-Output "      Contributor/Founder       -       dbareports"                
        Write-Output ""                        
        Write-Output "      Contributor/Founder       -       dbachecks"                
        Write-Output ""                
        Write-Output "      Contributor               -       OpenQueryStore"                
        Write-Output ""                
    }
    if($Fun){
        Write-Output ""                        
        Write-Output "      When I am not staring at a screen"                        
        Write-Output "      I like to fly my drone"                        
        Write-Output "      and play cricket - It's a little bit like baseball!!"                        
        Write-Output ""                        
        Write-Output "      We are going to have some fun"                        
        Write-Output ""                        
        Write-Output "      This is not Lecture :-)"                        
        Write-Output ""                        
        Write-Output "      Ask Questions whenever you want to"                        
        Write-Output ""                        
        Write-Output "      Be considerate of your peers - Mobiles on silent please"                        
        Write-Output ""                                             
        Write-Output "      NOTE - I use the Queen's English - sorry if the spelling is annoying :-)"                        
    }
}
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.UI.RawUI.BackgroundColor = 'DarkBlue'
cls
#/B
#H                              WHO IS ROB ?

WhoAmI -Name

WhoAmI -Contact

cls
#H                              WHAT DOES ROB DO ?

WhoAmI -Work

cls
#H                              ROB's Community Engagements?

WhoAmI -CommunitySQL

cls
#H                              ROB's Community Engagements?

WhoAmI -CommunityPowerShell

cls 
#H                              ROB's Community Engagements?

WhoAmI -OpenSource

cls 
#H                              What Else?

WhoAmI -Fun

cls

#BI
$Host.UI.RawUI.ForegroundColor = 'DarkBlue'
$Host.UI.RawUI.BackgroundColor = 'Yellow'
cls
$WindowTitle = "Every One Sitting Comfortably ?"
$NoBanner = $True
#/B
#H                              I am Very Sorry
#H                
#BI
Write-Output "I Apologise (with an s!) I speak and write the Queen's English!"
""
Write-Output "Let's Begin"

#/B