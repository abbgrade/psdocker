Register-ArgumentCompleter -CommandName Remove-DockerContainer -ParameterName Name -ScriptBlock $ContainerNameCompleter

function Remove-Container {

    <#

    .SYNOPSIS
    Remove container

    .DESCRIPTION
    Removes a docker container from the service.
    Wraps the command `docker rm`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/rm/

    .EXAMPLE
    PS C:\> New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer' | Out-Null
    PS C:\> Remove-DockerContainer -Name 'mycontainer'

    .EXAMPLE
    PS C:\> $container = New-DockerContainer -Image 'microsoft/nanoserver'
    PS C:\> $container | Remove-DockerContainer

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # Specifies the name of the container that should be removed.
        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Specifies if the container should be stopped before removal.
        [Parameter( Mandatory = $false )]
        [switch] $Force,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter( Mandatory = $false )]
        [int] $Timeout = 10,

        # Specifies the timeout of the Docker client command for the stop operation.
        [Parameter( Mandatory = $false )]
        [int] $StopTimeout = 10
    )

    process {

        if ( $PSCmdlet.ShouldProcess( $Name, 'Remove Docker container' ) ) {
            if ( $Force ) {
                Stop-Container -Name $Name -Timeout $StopTimeout -Confirm:$false
            }

            Invoke-ClientCommand 'rm', $Name -Timeout $Timeout
            Write-Verbose "Docker container '$Name' removed."
        }

    }
}
