# An easy way of doing some logging

# Use PSFramework

function Do-SomeLogging {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param([switch]$throw)

    Write-PSFMessage -Message "I am starting - This is only for debugging" -Level Debug
    if ($PSCmdlet.ShouldProcess("Something" , "I will do a thing")) {
       # Something
        try {
            Write-PSFMessage -Message "The try is starting - This is only for debugging" -Level Debug
            Write-PSFMessage -Message "I will be doing something - so I want to tell you about it" -Level Output
            if($throw){
                Write-PSFMessage -Message "I threw - This is only for debugging when I throw" -Level Debug
                Write-PSFMessage -Message "I am going to throw - so I want to tell you about it" -Level Output
                Throw "Oh NO I failed big time"
            }
        }
        catch {
            Write-PSFMessage -Message "I hit the catch this is the error $_ - This is only for debugging when an error is caught" -Level Debug
            Write-PSFMessage -Message "I tried but I failed" -Level Critical
        }
    }
}

Do-SomeLogging

Get-PSFMessage -Last 1

Do-SomeLogging -throw

Get-PSFMessage -Last 1 | fl

Get-PSFMessage -Level Debug -Last 1


    # Grab the function names and place them in a string without this function name in there

    switch ($MessageType) {
        INFO { 
            $ScriptName = (((Get-PSCallStack).Where{$_.Command -ne 'Write-Logging'}.Location) -join '-').ToString()
        }
        Default {
            $ScriptName = ((Get-PSCallStack).Where{$_.Command -ne 'Write-Logging'} | ConvertTo-Json -Depth 1).ToString()
        }
    }
    $Message = $Message.Replace("'","''")
    $Query = "EXEC build.LogMessage @BuildID={0}, @Functions='{1}', @Message='{2}', @MessageType='{3}'" -f $BuildID, $ScriptName, $Message, $MessageType;
    Invoke-DbaQuery -SQLInstance $SQLINstance -Query $Query |Out-Null
