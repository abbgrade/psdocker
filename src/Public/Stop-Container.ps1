function Stop-Container {

    <#

    .SYNOPSIS Stop container

    .DESCRIPTION
    Wraps the docker command [stop](https://docs.docker.com/engine/reference/commandline/stop/).

    .PARAMETER Name
    Specifies the name of the container to stop.

    .PARAMETER Timeout
    Specifies the timeout of the docker client command.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 10
    )

    Invoke-ClientCommand 'stop', $Name -Timeout $Timeout
    Write-Verbose "Docker container removed."
}