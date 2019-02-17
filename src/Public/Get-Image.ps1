function Get-Image {

    <#

    .SYNOPSIS

    Get docker image

    .DESCRIPTION

    Wraps the command [docker image ls](https://docs.docker.com/engine/reference/commandline/image_ls/).

    .PARAMETER Repository

    Specifies the repository to filter the images on.

    .PARAMETER Tag

    Specifies the tag to filter the images on.

    .PARAMETER Timeout

    Specifies the number of seconds to wait for the command to finish.

    .EXAMPLE

    PS C:\> Get-DockerImage -Repository 'microsoft/powershell'
    Created    : 2 weeks ago
    ImageId    : sha256:4ebab174c7292440d4d7d5e5e61d3cd4487441d3f49df0b656ccc81d2a0e4489
    Size       : 364MB
    Tag        : latest
    Repository : microsoft/powershell

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Repository,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Tag,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 10
    )

    $arguments = New-Object System.Collections.ArrayList
    $arguments.Add('image')
    $arguments.Add('ls')
    $arguments.Add('--no-trunc')

    if ( $Repository ) {
        if ( $Tag ) {
            $arguments.Add( $Repository + ':' + $Tag )
        } else {
            $arguments.Add( $Repository )
        }
    }

    Invoke-ClientCommand $arguments -Timeout $Timeout -TableOutput @{
        'REPOSITORY' = 'Repository'
        'TAG' = 'Tag'
        'IMAGE ID' = 'ImageId'
        'CREATED' = 'Created'
        'SIZE' = 'Size'
    } | Write-Output
}
