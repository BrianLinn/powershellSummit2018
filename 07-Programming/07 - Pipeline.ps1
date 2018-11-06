# Lets write a function to get the size of a directory
function Get-DirectoryFileSize {
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$Directory)
	
    if (Test-Path -Path $Directory) {
        (Get-ChildItem -Path $Directory -File).ForEach{$size += $_.Length}
        [PSCustomObject]@{'Directory' = $Directory; 'SizeInGB' = $size / 1GB; 'SizeInMB' = $size / 1MB}	
    }
    else {
        Write-Error "Cannot find directory: $Directory"
    }
}

Get-DirectoryFileSize -Directory C:\temp

## But if we want to pipe into this

Get-Item 'C:\temp' | Get-DirectoryFileSize

Get-ChildItem -Path C:\Temp -Directory  | Get-DirectoryFileSize

## Simply add this to the parameter

function Get-DirectoryFileSize {
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Directory)
	
    if (Test-Path -Path $Directory) {
        (Get-ChildItem -Path $Directory -File).ForEach{$size += $_.Length}
        [PSCustomObject]@{'Directory' = $Directory; 'SizeInGB' = [Math]::Round($size / 1GB, 2); 'SizeInMB' = [Math]::Round($size / 1MB, 2)}
    }
    else {
        Write-Error "Cannot find directory: $Directory"
    }
}

Get-DirectoryFileSize -Directory C:\temp

## But if we want to pipe into this

Get-Item 'C:\temp' | Get-DirectoryFileSize


## Simples

## BUT

## Lets create another folder called Temp1

New-Item C:\Temp1 -ItemType Directory

## and fill it with some files (I have skipped the 30 biggest files)

$files = Get-ChildItem C:\temp | Sort-Object Length -Descending | Select-Object -Skip 30 -First 10

$Files | Copy-Item -Destination C:\Temp1

## Now we want 2 directories

Get-DirectoryFileSize -Directory C:\temp, C:\temp1 

Get-Item C:\temp, C:\temp1 | Get-DirectoryFileSize

## Hmmm we only have the last value Lets change the parameter to take a collection


function Get-DirectoryFileSize {
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Directory)
	
    if (Test-Path -Path $Directory) {
        (Get-ChildItem -Path $Directory -File).ForEach{$size += $_.Length}
        [PSCustomObject]@{'Directory' = $Directory; 'SizeInGB' = [Math]::Round($size / 1GB, 2); 'SizeInMB' = [Math]::Round($size / 1MB, 2)}
    }
    else {
        Write-Error "Cannot find directory: $Directory"
    }
}

Get-DirectoryFileSize -Directory C:\temp, C:\temp1 

# that doesnt work - how about piping

Get-Item C:\temp, C:\temp1 | Get-DirectoryFileSize

# that is definitely not doing what we want :-(

# Lets add a foreach - that will sort it

function Get-DirectoryFileSize {
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Directory)
    
    foreach ($Dir in $Directory) {
        if (Test-Path -Path $Dir) {
            (Get-ChildItem -Path $Dir -File).ForEach{$size += $_.Length}
            [PSCustomObject]@{'Directory' = $Dir ; 'SizeInGB' = [Math]::Round($size / 1GB, 2); 'SizeInMB' = [Math]::Round($size / 1MB, 2)}
        }
        else {
            Write-Error "Cannot find directory: $Dir"
        }
    }
}

Get-DirectoryFileSize -Directory C:\temp, C:\temp1 

# ok that works - how about piping

Get-Item C:\temp, C:\temp1 | Get-DirectoryFileSize

# nope

<#
Here's where the BEGIN, PROCESS, and END blocks are required.

When a function has BEGIN, PROCESS, and END blocks:

The BEGIN block runs once, before the first item in the collection.
The END block also runs once, after every item in the collection has been processes.
The PROCESS block runs once for each item in the collection.
When a script doesn't have BEGIN, PROCESS, and END blocks, the entire function is considered to be an END block 
and it runs after the last item in the collection. 

So, to manage an array that's piped to the function, we need to add BEGIN, PROCESS, and END blocks.
#>


function Get-DirectoryFileSize {
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Directory)
    
    BEGIN {}
    PROCESS {
        foreach ($Dir in $Directory) {
            $size = 0 # we also need to reset the size variable
            if (Test-Path -Path $Dir) {
                (Get-ChildItem -Path $Dir -File).ForEach{$size += $_.Length}
                [PSCustomObject]@{'Directory' = $Dir ; 'SizeInGB' = [Math]::Round($size / 1GB, 2); 'SizeInMB' = [Math]::Round($size / 1MB, 2)}
            }
            else {
                Write-Error "Cannot find directory: $Dir"
            }
        }
    }
    End {}
}

Get-DirectoryFileSize -Directory C:\temp, C:\temp1 

# ok that works - how about piping

Get-Item C:\temp, C:\temp1 | Get-DirectoryFileSize


## Bingo :-)