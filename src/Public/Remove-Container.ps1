Register-ArgumentCompleter -CommandName Remove-DockerContainer -ParameterName Name -ScriptBlock $ContainerNameCompleter

function Remove-Container {

    <#

    .SYNOPSIS
    Remove a Docker container.

    .DESCRIPTION
    Removes a container, optionally stopping it first with -Force.
    Supports -WhatIf and -Confirm. Wraps the Docker CLI `rm` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Remove-DockerContainer.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/rm/

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    $name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') | Out-Null
    Remove-DockerContainer -Name $name -Force

    Creates a temporary container, then removes it by name.
    Captured output:
    No output. The container is removed.

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    $name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    $container = New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity')
    $container | Remove-DockerContainer -Force

    Creates a temporary container, then stops and removes it through the pipeline.
    Captured output:
    No output. Matching containers are stopped and removed.

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
