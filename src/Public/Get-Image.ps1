function Get-Image {

    <#

    .SYNOPSIS Get docker image

    .DESCRIPTION
    Wraps the docker command [image ls](https://docs.docker.com/engine/reference/commandline/image_ls/).

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
    }
}