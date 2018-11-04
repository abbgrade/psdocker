function Install-Image {

    <#

    .SYNOPSIS Install image

    .Description
    Installs a docker image in the service from a repository.
    Wraps the docker command [pull](https://docs.docker.com/engine/reference/commandline/pull/).

    .EXAMPLE
    C:\PS> Install-DockerImage -Name 'microsoft/nanoserver'

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