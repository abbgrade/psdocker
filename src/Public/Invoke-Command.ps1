function Invoke-Command {

    <#

    .SYNOPSIS
    Invoke command

    .DESCRIPTION
    Invokes a command on a docker container.
    Wraps the docker `command exec`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/exec/

    .PARAMETER Name
    Specifies the name of the docker container to run the command on.

    .PARAMETER Command
    Specifies the command to run on the docker container.

    .PARAMETER ArgumentList
    Specifies the list of arguments of the command.

    .PARAMETER Timeout
    Specifies the number of seconds to wait for the command to finish.

    .PARAMETER StringOutput
    Specifies if the output of the container command should be returned as string.

    .OUTPUTS
    System.string: Returns a string if the parameter StringOutput is set.

    .EXAMPLE
    PS C:\> $container = New-DockerContainer -Image 'microsoft/iis' -Detach
    PS C:\> Invoke-DockerCommand -Name $container.Name -Command 'hostname' -StringOutput
    88eb8fa9c07f

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Command,

        [Parameter( Mandatory = $false )]
        [string[]] $ArgumentList,

        [Parameter( Mandatory = $false )]
        [int] $Timeout = 30,

        [Parameter( Mandatory = $false )]
        [switch] $StringOutput
    )

    [string[]] $arguments = @( 'exec', $Name, $Command ) + $( if ( $ArgumentList ) { $ArgumentList } )

    Invoke-ClientCommand `
        -ArgumentList $arguments `
        -StringOutput:$StringOutput `
        -Timeout $Timeout |
    Write-Output

    Write-Verbose "Command on Docker container executed."
}
