
## Start with a Plaster Module
## This is a template framework to reduce you from creating all the usual scaffolding
## This is mine

## Take a look at the PlasterManifest.xml Thats where the magic happens

cd Git:\PlasterTemplate
code-insiders . 

## You can find mine here https://github.com/SQLDBAWithABeard/PlasterTemplate

## Then create your module

$ModuleName = 'BeardAnalysis'
$Description = "This is a demo module for demoing Plaster and TDD with Pester and CI with VSTS to the PowerShell Gallery"

$plaster = @{
    TemplatePath = "GIT:\PlasterTemplate" #(Split-Path $manifestProperties.Path)
    DestinationPath = "Git:\$ModuleName"
    FullName = "Rob Sewell"
    ModuleName = $ModuleName
    ModuleDesc = $Description
    Version = '0.9.27'
    GitHubUserName = "SQLDBAWithABeard"
    GitHubRepo = $ModuleName
    }
    If(!(Test-Path $plaster.DestinationPath))
    {
    New-Item -ItemType Directory -Path $plaster.DestinationPath
    }
    Invoke-Plaster @plaster -Verbose

    ## lets have a look what has been created

    cd Git:\$ModuleName
    code-insiders . 

    ## Publish to GitHub using this function from Jeff Hicks to create a repo

    . Git:\Functions\New-GitHubRepository.ps1

    $Repo = New-GitHubRepository -Name $ModuleName -Description $Description

    Start-Process $Repo.URL

    git init
    git add *
    git commit -m "Added framework using Plaster Template"
    git remote add origin $Repo.Clone
    ## publish branch
    git push --set-upstream origin master
