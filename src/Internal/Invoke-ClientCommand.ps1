function Invoke-ClientCommand {

    <#

    .SYNOPSIS Invokes a docker client command

    #>

    [CmdletBinding()]
    param (
        # Arguments to pass to the docker client; all values are cast to strings.
        [Parameter(Mandatory=$true)]
        [string[]]
        $ArgumentList,

        # Maximum time to wait for the command, in seconds.
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [int]
        $Timeout,

        # Return the command output as a single string.
        [Parameter(Mandatory=$false)]
        [switch]
        $StringOutput,

        # Map Docker output columns to properties in the result objects.
        [Parameter(Mandatory=$false)]
        [hashtable]
        $TableOutput,

        # Parse Docker output as JSON.
        [Parameter(Mandatory=$false)]
        [switch]
        $JsonOutput
    )

    # Configure process
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.Filename = 'docker'
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
        Write-Verbose 'No process output'
    }

    # A successful command may write progress or diagnostic output to stderr.
    if ( $process.ExitCode ) {
        foreach ( $line in $standardErrorBuffer.Values ) {
            if ( $line ) {
                Write-Warning "Process error: $line" -ErrorAction 'Continue'
            }
        }
        Write-Error "Proccess failed ($processCall) after $( $process.TotalProcessorTime )."
    } elseif ( -not $standardErrorBuffer.Count ) {
        Write-Verbose 'No process error output'
    }
    if ( $Timeout -gt 0 -and $process.TotalProcessorTime.TotalSeconds -ge $Timeout ) {
        Write-Error "Process timed out ($processCall) after $( $process.TotalProcessorTime )."
    }
}
