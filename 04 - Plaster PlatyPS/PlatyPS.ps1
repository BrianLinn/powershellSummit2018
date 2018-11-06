
$Params = @{
    Module       = 'dbachecks'
    Force        = $true
    OutputFolder = "c:\temp\docs"
    NoMetadata   = $true
}
explorer C:\temp\docs
New-MarkdownHelp @Params