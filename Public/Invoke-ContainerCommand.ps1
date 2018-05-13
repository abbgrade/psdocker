function Invoke-ContainerCommand {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Command
    )

    Invoke-ClientCommand 'exec', $Name, $Command
    Write-Debug "Command on Docker container executed."
}