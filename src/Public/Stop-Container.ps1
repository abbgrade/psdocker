function Stop-Container {

    <#

    .SYNOPSIS
    Stop container

    .DESCRIPTION
    Wraps the command `docker stop`.

    .LINK https://docs.docker.com/engine/reference/commandline/stop/

    .PARAMETER Name
    Specifies the name of the container to stop.

    .PARAMETER Timeout
    Specifies the number of seconds to wait for the command to finish.

    .EXAMPLE
    PS C:\> $container = New-DockerContainer -Image 'microsoft/nanoserver'
    PS C:\> $container | Stop-DockerContainer

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [int] $Timeout = 10
    )

    Invoke-ClientCommand 'stop', $Name -Timeout $Timeout
    Write-Verbose "Docker container removed."
}
