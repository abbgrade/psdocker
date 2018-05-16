function Invoke-ContainerCommand {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Command
    )

    Get-Container -Name $Name

    Invoke-ClientCommand 'exec', $Name, $Command
    Write-Debug "Command on Docker container executed."
}