function Invoke-ClientCommand {

    param (
        [string[]]
        $ArgumentList,

        [int]
        $TimeoutMS = $null,

        [switch]
        $TableOutput
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
    $standardOutputBuffer = New-Object System.Text.StringBuilder
    $standardErrorBuffer = New-Object System.Text.StringBuilder

    Unregister-Event -SourceIdentifier StdOutEvent -ErrorAction SilentlyContinue
    Register-ObjectEvent -InputObject $process -SourceIdentifier StdOutEvent -Action {
        $event.MessageData.AppendLine( $eventArgs.Data )
    } -MessageData $standardOutputBuffer -EventName 'OutputDataReceived' | Out-Null

    Unregister-Event -SourceIdentifier StdErrEvent -ErrorAction SilentlyContinue
    Register-ObjectEvent -InputObject $process -SourceIdentifier StdErrEvent -Action {
        $event.MessageData.AppendLine( $eventArgs.Data )
    } -MessageData $standardErrorBuffer -EventName 'ErrorDataReceived' | Out-Null

    $processCall = "$( $process.StartInfo.FileName ) $( $process.StartInfo.Arguments )"
    if ( $processCall.Length -ge 250 ) {
        $processCall = "$( $processCall.Substring(252) )..."
    }
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

    # Process output
    if ( $standardOutputBuffer.Length ) {
        $output = $standardOutputBuffer.ToString()
        foreach ( $line in $output.Split([Environment]::NewLine) ) {
            if ( $line ) {
                Write-Verbose $line
            }
        }
        if ( $TableOutput ) {
            Convert-ToTable -Content $output
        }
    }
    $standardError = $standardErrorBuffer.ToString().Trim()
    if ( $standardError.Length -or $process.ExitCode ) {
        foreach ( $line in $standardError.Split([Environment]::NewLine)) {
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