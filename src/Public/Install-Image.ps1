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
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Registry,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Tag,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [switch] $AllTags,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Digest,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [int] $Timeout = 5 * 60
    )

    [string] $query = ''

    if ( $Registry ) {
        $query = "$Registry/"
    }

    $query += $Name

    if ( $Tag ) {
        $query += ":$Tag"
    }

    if ( $Digest ) {
        $query += "@$Digest"
    }

    $arguments = @( $query )

    if ( $AllTags ) {
        $arguments = @( '--all-tags' ) + $arguments
    }

    Invoke-ClientCommand "pull", $arguments -Timeout $Timeout
    Write-Verbose "Docker image '$query' pulled."
}
