function Invoke-Command {

    <#

    .SYNOPSIS Invoke command

    .DESCRIPTION
    Invokes a command on a docker container.
    Wraps the docker command [exec](https://docs.docker.com/engine/reference/commandline/exec/).

    .PARAMETER Name
    Specifies the name of the docker container to run the command on.

    .PARAMETER Command
    Specifies the command to run on the docker container.

    .PARAMETER ArgumentList
    Specifies the list of arguments of the command.

    .PARAMETER Timeout
    Specifies the timout of the docker client command.

    .PARAMETER StringOutput
    Specifies if the output of the container command should be returned as string.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Command,

        [Parameter(Mandatory=$false)]
        [string[]]
        $ArgumentList,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 30,

        [Parameter(Mandatory=$false)]
        [switch]
        $StringOutput
    )

    [string[]] $arguments = @( 'exec', $Name, $Command ) + $( if ( $ArgumentList ) { $ArgumentList } )

    Invoke-ClientCommand `
        -ArgumentList $arguments `
        -StringOutput:$StringOutput `
        -Timeout $Timeout

    Write-Verbose "Command on Docker container executed."
}