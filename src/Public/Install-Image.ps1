Register-ArgumentCompleter -CommandName Install-DockerImage -ParameterName Repository -ScriptBlock $RepositoryCompleter
Register-ArgumentCompleter -CommandName Install-DockerImage -ParameterName Tag -ScriptBlock $TagCompleter

function Install-Image {

    <#

    .SYNOPSIS
    Pull a Docker image.

    .DESCRIPTION
    Pulls an image from a registry and returns matching local image information.
    Supports -WhatIf and -Confirm. Wraps the Docker CLI `pull` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Install-DockerImage.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/pull/

    .OUTPUTS
    Image: Returns Image objects for the pulled image matching the specified parameters.

    .EXAMPLE
    # Prerequisites: Docker is running and can access the image registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' |
        Format-List Repository,Tag,Id,Size

    Pulls the latest PowerShell image.
    Captured output (the image ID may change when the tag is updated):
    Repository : mcr.microsoft.com/powershell
    Tag        : latest
    Id         : sha256:810c4f1e0c9d23022c3ec18c50a6205ee4b60766f1739d329b2948df1fd7d5b0
    Size       : 489MB

    .EXAMPLE
    # Does not require the image to be present or pulled.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -WhatIf

    Shows the pull operation without downloading the image.
    Captured output:
    What if: Performing the operation "Pull Docker image" on target "mcr.microsoft.com/powershell".

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # Specifies the registry that contains the repository or image.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Registry,

        # Specifies the name of the repository of the image to install.
        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Name', 'ImageName' )]
        [string] $Repository,

        # Specifies the tag of the image to install.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Tag,

        # Specifies if the images for all tags should be installed.
        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [switch] $AllTags,

        # Specifies the digest of the specific image that should be installed.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Digest,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter( ValueFromPipelineByPropertyName = $true )]
        [int] $Timeout = 5 * 60
    )

    process {

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

        if ( $PSCmdlet.ShouldProcess( $query, 'Pull Docker image' ) ) {
            Invoke-ClientCommand 'pull', $arguments -Timeout $Timeout
            Write-Verbose "Docker image '$query' pulled."

            Get-Image -Name $query | Write-Output
        }

    }
}
