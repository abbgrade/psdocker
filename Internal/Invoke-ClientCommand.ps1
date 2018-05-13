function Invoke-ClientCommand {

    param (
        [string[]]
        $ArgumentList,

        [int]
        $TimeoutMS = $null,

        [switch]
        $TableOutput
    )

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.Filename = "docker"
    $process.StartInfo.Arguments = $ArgumentList
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.RedirectStandardError = $true
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.CreateNoWindow = $true

    $standardOutputBuffer = New-Object System.Text.StringBuilder
    $standardErrorBuffer = New-Object System.Text.StringBuilder

    Unregister-Event -SourceIdentifier StdOutEvent -ErrorAction "SilentlyContinue"
    Register-ObjectEvent -InputObject $process -SourceIdentifier StdOutEvent -Action {
        $event.MessageData.AppendLine( $eventArgs.Data )
    } -MessageData $standardOutputBuffer -EventName 'OutputDataReceived' | Out-Null

    Unregister-Event -SourceIdentifier StdErrEvent -ErrorAction "SilentlyContinue"
    Register-ObjectEvent -InputObject $process -SourceIdentifier StdErrEvent -Action {
        $event.MessageData.AppendLine( $eventArgs.Data )
    } -MessageData $standardErrorBuffer -EventName 'ErrorDataReceived' | Out-Null

    Write-Verbose "Process started: $( $process.StartInfo.FileName ) $( $process.StartInfo.Arguments )"
    $process.Start() | Out-Null
    $process.BeginOutputReadLine()
    $process.BeginErrorReadLine()

    [bool] $timeout = $false
    if (( -not $TimeoutMS ) -or $process.WaitForExit( $TimeoutMS )) {
        $process.WaitForExit() # Ensure streams are flushed

        Write-Verbose "Process exited"
    } else {
        $timeout = $true

        Write-Verbose "Process timed out"
    }

    if ( $standardOutputBuffer.Length ) {
        $output = $standardOutputBuffer.ToString()
        foreach ( $line in $output.Split([Environment]::NewLine) ) {
            if ( $line ) {
                Write-Debug $line
            }
        }
        if ( $TableOutput ) {
            Convert-ToTable -Content $output
        }
    }
    if ( $standardErrorBuffer.Length ) {
        foreach ( $line in $standardErrorBuffer.ToString().Split([Environment]::NewLine)) {
            if ( $line ) {
                Write-Error $line
            }
        }
    }

    if ( $timeout ) {
        throw "Process timed out"
    }
}