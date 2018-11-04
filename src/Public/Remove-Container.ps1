function Remove-Container {

    <#

    .SYNOPSIS Remove container

    .DESCRIPTION
    Removes a docker container from the service.
    Wraps the docker command [rm](https://docs.docker.com/engine/reference/commandline/rm/).

    .PARAMETER Name
    Specifies the name of the container, that should be removed.

    .PARAMETER Force
    Specifies if the container should be stopped before removal.

    .PARAMETER Timeout
    Specifies the timeout of the docker client command for the removal.

    .PARAMETER StopTimeout
    Specifies the timeout of the docker client command for the stop operation.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [switch]
        $Force,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 10,

        [Parameter(Mandatory=$false)]
        [int]
        $StopTimeout = 10
    )

    if ( $Force ) {
        Stop-Container -Name $Name -Timeout $StopTimeout
    }

    Invoke-ClientCommand 'rm', $Name -Timeout $Timeout
    Write-Verbose "Docker container removed."
}