Register-ArgumentCompleter -CommandName Get-DockerCommand -ParameterName Name -ScriptBlock $ContainerNameCompleter

function Invoke-Command {

    <#

    .SYNOPSIS
    Run a command in a Docker container.

    .DESCRIPTION
    Runs a command in an existing container and optionally returns its output as a string.
    Supports -WhatIf and -Confirm. Wraps the Docker CLI `exec` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Invoke-DockerCommand.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/exec/

    .OUTPUTS
    System.String: Returns command output when -StringOutput is specified.

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    $containerName = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    $container = New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $containerName -Detach -ArgumentList @('sleep','infinity')
    Invoke-DockerCommand -Name $container.Name -Command 'echo' -ArgumentList 'hello' -StringOutput
    Remove-DockerContainer -Name $container.Name -Force

    Creates a temporary container, runs echo in it, then removes the container.
    Captured output:
    hello

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # Specifies the name of the Docker container to run the command on.
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Specifies the command to run in the Docker container.
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Command,

        # Specifies the arguments to pass to the command.
        [Parameter( Mandatory = $false )]
        [string[]] $ArgumentList,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter( Mandatory = $false )]
        [int] $Timeout = 30,

        # Returns the container command output as a string.
        [Parameter( Mandatory = $false )]
        [switch] $StringOutput
    )

    $arguments = New-Object System.Collections.ArrayList
    $arguments.Add( $Name ) | Out-Null
    $arguments.Add( $Command ) | Out-Null

    if ( $ArgumentList ) {
        $arguments.AddRange( $ArgumentList )
    }

    Write-Verbose "Executing a command in Docker container '$Name'."
    if ( $PSCmdlet.ShouldProcess( $Name, "Run command '$Command' in Docker container" ) ) {
        Invoke-ClientCommand 'exec', $arguments `
            -StringOutput:$StringOutput `
            -Timeout $Timeout |
        Write-Output

        Write-Verbose "Command on Docker container executed."
    }
}
