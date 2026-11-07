Register-ArgumentCompleter -CommandName Stop-DockerContainer -ParameterName Name -ScriptBlock $ContainerNameCompleter

function Stop-Container {

    <#

    .SYNOPSIS
    Stop container

    .DESCRIPTION
    Wraps the command `docker stop`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/stop/

    .EXAMPLE
    PS C:\> $container = New-DockerContainer -Image 'microsoft/nanoserver'
    PS C:\> $container | Stop-DockerContainer

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # Specifies the name of the container to stop.
        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter( Mandatory = $false )]
        [int] $Timeout = 10
    )

    process {

        if ( $PSCmdlet.ShouldProcess( $Name, 'Stop Docker container' ) ) {
            Invoke-ClientCommand 'stop', $Name -Timeout $Timeout
            Write-Verbose "Docker container '$Name' stopped."
        }

    }
}
