function Install-Image {

    <#

    .SYNOPSIS Install image

    .Description
    Installs a docker image in the service from a repository.
    Wraps the docker command [pull](https://docs.docker.com/engine/reference/commandline/pull/).

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Image,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 5 * 60
    )

    Invoke-ClientCommand "pull", $Image -Timeout $Timeout
    Write-Verbose "Docker image '$Image' pulled."
}