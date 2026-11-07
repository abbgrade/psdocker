Register-ArgumentCompleter -CommandName Get-DockerCommand -ParameterName Name -ScriptBlock $ContainerNameCompleter

function Invoke-Command {

    <#

    .SYNOPSIS
    Invoke command

    .DESCRIPTION
    Invokes a command on a docker container.
    Wraps the docker `exec` command.

    .LINK
    https://docs.docker.com/engine/reference/commandline/exec/

    .OUTPUTS
    System.string: Returns a string if the parameter StringOutput is set.

    .EXAMPLE
    PS C:\> $container = New-DockerContainer -Image 'microsoft/iis' -Detach
    PS C:\> Invoke-DockerCommand -Name $container.Name -Command 'hostname' -StringOutput
    88eb8fa9c07f

    #>

    [CmdletBinding()]
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

    Invoke-ClientCommand 'exec', $arguments `
        -StringOutput:$StringOutput `
        -Timeout $Timeout |
    Write-Output

    Write-Verbose "Command on Docker container executed."
}
