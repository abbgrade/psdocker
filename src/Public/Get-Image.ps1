Register-ArgumentCompleter -CommandName Get-DockerImage -ParameterName Repository -ScriptBlock $RepositoryCompleter
Register-ArgumentCompleter -CommandName Get-DockerImage -ParameterName Tag -ScriptBlock $TagCompleter

function Get-Image {

    <#

    .SYNOPSIS
    Get Docker images.

    .DESCRIPTION
    Returns locally available Docker images, optionally filtered by repository and tag.
    Wraps the Docker CLI `image ls` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Get-DockerImage.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/image_ls/

    .OUTPUTS
    Image: Returns an Image object for each image matching the parameters.

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    Get-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' |
        Format-List Repository,Tag,Id,Size

    Pulls the image if needed, then returns its local image information.
    Captured output (the image ID may change when the tag is updated):
    Repository : mcr.microsoft.com/powershell
    Tag        : latest
    Id         : sha256:810c4f1e0c9d23022c3ec18c50a6205ee4b60766f1739d329b2948df1fd7d5b0
    Size       : 489MB

    #>

    [CmdletBinding()]
    param (
        # Specifies the repository to filter the images on.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [Alias( 'Name' )]
        [ValidateNotNullOrEmpty()]
        [string] $Repository,

        # Specifies the tag to filter the images on.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Tag,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter( Mandatory = $false )]
        [int] $Timeout = 10
    )

    process {

        $arguments = New-Object System.Collections.ArrayList
        $arguments.Add( '--no-trunc' ) | Out-Null
        $arguments.Add( '--format="{{json .}}" ') | Out-Null

        if ( $Repository ) {
            if ( $Tag ) {
                $arguments.Add( $Repository + ':' + $Tag ) | Out-Null
            }
            else {
                $arguments.Add( $Repository ) | Out-Null
            }
        }

        $imageDescription = if ( $Repository ) {
            if ( $Tag ) { "$Repository`:$Tag" } else { "repository '$Repository'" }
        } else {
            'all images'
        }
        Write-Verbose "Retrieving Docker images for $imageDescription."

        Invoke-ClientCommand 'image ls', $arguments -Timeout $Timeout -JsonOutput |
            ForEach-Object {
                New-Object -TypeName Image -Property @{
                    Repository = $_.Repository
                    Tag        = switch ( $_.Tag ) { '<none>' { $null } default { $_ } }
                    Id         = $_.ID
                    CreatedAt  = $_.CreatedAt
                    Size       = $_.Size
                } | Write-Output
            } | Write-Output

    }
}
