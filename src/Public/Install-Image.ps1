function Install-Image {

    <#

    .SYNOPSIS
    Install image

    .Description
    Installs a docker image in the service from a repository.
    Wraps the command `docker pull`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/pull/

    .LINK
    Uninstall-Image

    .PARAMETER Registry
    Specifies the registry that contains the repository or image.

    .PARAMETER Repository
    Specifies the name of the repository of the image to install.

    .PARAMETER Tag
    Specifies the tag of the image to install.

    .PARAMETER AllTags
    Specifies if the images for all tags should be installed.

    .PARAMETER Digest
    Specifies the digest of the specific image that should be installed.

    .PARAMETER Timeout
    Specifies the number of seconds to wait for the command to finish.

    .OUTPUTS
    Image: Returns `Image` objects for the images that are installed and match the parameter.

    .EXAMPLE
    PS C:\> Install-DockerImage -Name 'microsoft/nanoserver'

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Registry,

        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Name', 'ImageName' )]
        [string] $Repository,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Tag,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [switch] $AllTags,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Digest,

        [Parameter( ValueFromPipelineByPropertyName = $true )]
        [int] $Timeout = 5 * 60
    )

    [string] $query = ''

    if ( $Registry ) {
        $query = "$Registry/"
    }

    $query += $Repository

    if ( $Tag ) {
        $query += ":$Tag"
    }

    if ( $Digest ) {
        $query += "@$Digest"
    }

    $arguments = New-Object System.Collections.ArrayList
    $arguments.Add( $query ) | Out-Null

    if ( $AllTags ) {
        $arguments.Insert( '--all-tags', 0 ) | Out-Null
    }

    Invoke-ClientCommand 'pull', $arguments -Timeout $Timeout
    Write-Verbose "Docker image '$query' pulled."

    Get-Image -Name $query | Write-Output
}
