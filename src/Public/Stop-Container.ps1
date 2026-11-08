Register-ArgumentCompleter -CommandName Stop-DockerContainer -ParameterName Name -ScriptBlock $ContainerNameCompleter

function Stop-Container {

    <#

    .SYNOPSIS
    Stop a Docker container.

    .DESCRIPTION
    Stops a running container. Supports -WhatIf and -Confirm.
    Wraps the Docker CLI `stop` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Stop-DockerContainer.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/stop/

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    $name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') | Out-Null
    Stop-DockerContainer -Name $name
    Remove-DockerContainer -Name $name

    Creates a temporary container, stops it, then removes it.
    Captured output:
    No output. The container is stopped.

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
