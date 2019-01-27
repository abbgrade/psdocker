function Stop-Container {

    <#

    .SYNOPSIS

    Stop container

    .DESCRIPTION

    Wraps the command [docker stop](https://docs.docker.com/engine/reference/commandline/stop/).

    .PARAMETER Name

    Specifies the name of the container to stop.

    .PARAMETER Timeout

    Specifies the number of seconds to wait for the command to finish.

    .EXAMPLE

    PS C:\> New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer' | Out-Null
    PS C:\> Stop-DockerContainer -Name 'mycontainer'

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