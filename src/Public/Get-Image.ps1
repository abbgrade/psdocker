Register-ArgumentCompleter -CommandName Get-DockerImage -ParameterName Repository -ScriptBlock $RepositoryCompleter
Register-ArgumentCompleter -CommandName Get-DockerImage -ParameterName Tag -ScriptBlock $TagCompleter

function Get-Image {

    <#

    .SYNOPSIS
    Get docker image

    .DESCRIPTION
    Wraps the command `docker image ls`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/image_ls/

    .OUTPUTS
    Image: Returns a `Image` object for each object matching the parameters.

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
