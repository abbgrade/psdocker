function Invoke-ContainerCommand {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Command,

        [string[]]
        $Arguments,

        [int]
        $TimeoutMS = $null,

        [switch]
        $StringOutput
    )

    $container = Get-Container -Name $Name
    Write-Debug "Container status is '$( $container.Status )'."

    Invoke-ClientCommand -ArgumentList ( @( 'exec', $Name, $Command ) + $Arguments ) -StringOutput:$StringOutput -TimeoutMS $TimeoutMS
    Write-Debug "Command on Docker container executed."
}