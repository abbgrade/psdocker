function Invoke-ContainerCommand {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Command,

        [string[]]
        $Arguments
    )

    $container = Get-Container -Name $Name
    Write-Debug "Container status is '$( $container.Status )'."

    Invoke-ClientCommand 'exec', $Name, ( @() + $Command + $Arguments )
    Write-Debug "Command on Docker container executed."
}