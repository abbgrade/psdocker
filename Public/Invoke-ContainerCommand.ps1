function Invoke-ContainerCommand {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Command
    )

    $container = Get-Container -Name $Name
    Write-Debug "Container status is $( $container.Status )."

    Invoke-ClientCommand 'exec', $Name, "'$Command'"
    Write-Debug "Command on Docker container executed."
}