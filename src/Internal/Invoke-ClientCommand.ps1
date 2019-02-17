function Invoke-ClientCommand {

    <#

    .SYNOPSIS Invokes a docker client command

    .PARAMETER ArgumentList
    Specifies the arguments that are passed to the docker client.
    All arguments are casted to string.

    .PARAMETER Timeout
    Specifies a timeout in seconds for the command.

    .PARAMETER StringOutput
    Specifies if the output should be returned as string.

    .PARAMETER TableOutput
    Specifies if the output should be returned as table.
    The value is a hashtable that specifies the column mapping
    beween docker output and the properties of the result objects.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]
        $ArgumentList,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [int]
        $Timeout,

        [Parameter(Mandatory=$false)]
        [switch]
        $StringOutput,

        [Parameter(Mandatory=$false)]
        [hashtable]
        $TableOutput,

        [Parameter(Mandatory=$false)]
        [switch]
        $JsonOutput
    )

    # Configure process
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.Filename = "docker"
    $process.StartInfo.Arguments = $ArgumentList
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.RedirectStandardError = $true
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.CreateNoWindow = $true

    # Connect output events
    $standardOutputBuffer = New-Object System.Collections.SortedList
    $standardErrorBuffer = New-Object System.Collections.SortedList

    $EventAction = {
        if ( -not [String]::IsNullOrEmpty( $EventArgs.Data )) {
            $Event.MessageData.Add( $event.EventIdentifier, $EventArgs.Data ) | Out-Null
            Write-Verbose $EventArgs.Data
        }
    }

    $outputEvent = Register-ObjectEvent -InputObject $process `
        -EventName 'OutputDataReceived' -Action $EventAction -MessageData $standardOutputBuffer
    $errorEvent = Register-ObjectEvent -InputObject $process `
        -EventName 'ErrorDataReceived' -Action $EventAction -MessageData $standardErrorBuffer

    try {
        $processCall = "$( $process.StartInfo.FileName ) $( $process.StartInfo.Arguments )"
        if ( $processCall.Length -ge 250 ) { $processCall = "$( $processCall.Substring(252) )..." }
        Write-Verbose "Process started: $processCall"

        $process.Start() | Out-Null
        $process.BeginOutputReadLine()
        $process.BeginErrorReadLine()

        # Wait for exit
        if ( $Timeout ) {
            $process.WaitForExit( $Timeout * 1000 ) | Out-Null
        }
        $process.WaitForExit() | Out-Null # Ensure streams are flushed

        Write-Verbose "Process exited (code $( $process.ExitCode )) after $( $process.TotalProcessorTime )."
    } catch {
        throw
    } finally {
        Unregister-Event -SourceIdentifier $outputEvent.Name
        Unregister-Event -SourceIdentifier $errorEvent.Name
    }

    # Process output
    if ( $standardOutputBuffer.Count  ) {
        if ( $StringOutput ) {
            $standardOutput = $standardOutputBuffer.Values -join "`r`n"
            Write-Verbose "Process output: $standardOutput"
            Write-Output $standardOutput
        } elseif ( $JsonOutput ) {
            $standardOutputBuffer.Values | ConvertFrom-Json | Write-Output
        } elseif ( $TableOutput ) {
            Convert-ToTable -Content $standardOutputBuffer.Values -Columns $TableOutput | Write-Output
        }
    } else {
        Write-Verbose "No process output"
    }

    # process error
    if ( $standardErrorBuffer.Count -or $process.ExitCode ) {
        foreach ( $line in $standardErrorBuffer.Values ) {
            if ( $line ) {
                Write-Warning "Process error: $line" -ErrorAction 'Continue'
            }
        }
        throw "Proccess failed ($processCall) after $( $process.TotalProcessorTime )."
    } else {
        Write-Verbose "No process error output"
    }
    if ( $process.TotalProcessorTime.TotalSeconds -ge $Timeout ) {
        throw "Process timed out ($processCall) after $( $process.TotalProcessorTime )."
    }
}
