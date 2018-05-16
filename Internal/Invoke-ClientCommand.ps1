function Invoke-ClientCommand {

    param (
        [string[]]
        $ArgumentList,

        [int]
        $TimeoutMS = $null,

        [switch]
        $TableOutput,

        [hashtable]
        $ColumnNames
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
            Write-Verbose $EventArgs.Data -Verbose
        }
    }

    $outputEvent = Register-ObjectEvent -InputObject $process `
        -EventName 'OutputDataReceived' -Action $EventAction -MessageData $standardOutputBuffer
    $errorEvent = Register-ObjectEvent -InputObject $process `
        -EventName 'ErrorDataReceived' -Action $EventAction -MessageData $standardErrorBuffer

    try {
        $processCall = "$( $process.StartInfo.FileName ) $( $process.StartInfo.Arguments )"
        if ( $processCall.Length -ge 250 ) { $processCall = "$( $processCall.Substring(252) )..." }
        Write-Debug "Process started: $processCall"

        $process.Start() | Out-Null
        $process.BeginOutputReadLine()
        $process.BeginErrorReadLine()

        # Wait for exit
        [bool] $timeout = $false
        if (( -not $TimeoutMS ) -or $process.WaitForExit( $TimeoutMS )) {
            $process.WaitForExit() # Ensure streams are flushed
            Write-Debug "Process exited (code $( $process.ExitCode ))"
        } else {
            $timeout = $true
        }
    } catch {
        throw
    } finally {
        Unregister-Event -SourceIdentifier $outputEvent.Name
        Unregister-Event -SourceIdentifier $errorEvent.Name
    }

    # Process output

    if ( $standardOutputBuffer.Count ) {
        if ( $TableOutput ) {
            Convert-ToTable -Content $standardOutputBuffer.Values -ColumnNames $ColumnNames
        }
    }

    if ( $standardErrorBuffer.Count -or $process.ExitCode ) {
        foreach ( $line in $standardErrorBuffer.Values ) {
            if ( $line ) {
                Write-Warning $line
            }
        }
        throw "Proccess failed ($processCall)"
    }

    if ( $timeout ) {
        throw "Process timed out ($processCall)"
    }
}