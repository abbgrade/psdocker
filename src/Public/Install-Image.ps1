function Install-Image {

    <#

    .SYNOPSIS

    Install image

    .Description

    Installs a docker image in the service from a repository.
    Wraps the command [docker pull](https://docs.docker.com/engine/reference/commandline/pull/).

    .PARAMETER Name

    Specifies the name of the repository of the image to install.

    .PARAMETER Timeout

    Specifies the number of seconds to wait for the command to finish.

    .EXAMPLE

    PS C:\> Install-DockerImage -Name 'microsoft/nanoserver'

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 5 * 60
    )

    Invoke-ClientCommand "pull", $Name -Timeout $Timeout
    Write-Verbose "Docker image '$Name' pulled."
}