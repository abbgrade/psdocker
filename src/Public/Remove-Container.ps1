function Remove-Container {

    <#

    .SYNOPSIS
    Remove container

    .DESCRIPTION
    Removes a docker container from the service.
    Wraps the command `docker rm`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/rm/

    .PARAMETER Name
    Specifies the name of the container, that should be removed.

    .PARAMETER Force
    Specifies if the container should be stopped before removal.

    .PARAMETER Timeout
    Specifies the number of seconds to wait for the command to finish.

    .PARAMETER StopTimeout
    Specifies the timeout of the docker client command for the stop operation.

    .EXAMPLE
    PS C:\> New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer' | Out-Null
    PS C:\> Remove-DockerContainer -Name 'mycontainer'

    .EXAMPLE
    PS C:\> $container = New-DockerContainer -Image 'microsoft/nanoserver'
    PS C:\> $container | Remove-DockerContainer

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter( Mandatory = $false )]
        [switch] $Force,

        [Parameter( Mandatory = $false )]
        [int] $Timeout = 10,

        [Parameter( Mandatory = $false )]
        [int] $StopTimeout = 10
    )

    process {

        if ( $Force ) {
            Stop-Container -Name $Name -Timeout $StopTimeout
        }

        Invoke-ClientCommand 'rm', $Name -Timeout $Timeout
        Write-Verbose "Docker container removed."

    }
}
