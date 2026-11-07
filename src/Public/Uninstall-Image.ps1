Register-ArgumentCompleter -CommandName Uninstall-DockerImage -ParameterName Name -ScriptBlock $ImageNameCompleter

function Uninstall-Image {

    <#

    .SYNOPSIS
    Remove docker image

    .DESCRIPTION
    Wraps the docker command `docker image rm`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/image_rm/

    .LINK
    Install-Image

    .EXAMPLE
    PS C:\> Get-DockerImage -Repository 'microsoft/powershell' | Uninstall-DockerImage

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # Specifies the name of the image to be removed.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [Alias( 'Image', 'ImageName' )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Removes the image even if a container is using it.
        [Parameter( Mandatory = $false )]
        [switch] $Force = $false,

        # Prevents removal of untagged parent images.
        [Parameter( Mandatory = $false )]
        [switch] $NoPrune = $false,

        # Specifies how long to wait for the command to finish.
        [Parameter( Mandatory = $false )]
        [int] $Timeout = 10
    )

    process {

        $arguments = New-Object System.Collections.ArrayList

        if ( $Force ) {
            $arguments.Add( '--force' ) | Out-Null
        }

        if ( $NoPrune ) {
            $arguments.Add( '--no-prune' ) | Out-Null
        }

        $arguments.Add( $Name ) | Out-Null

        if ( $PSCmdlet.ShouldProcess( $Name, 'Remove Docker image' ) ) {
            Invoke-ClientCommand 'image rm', $arguments -Timeout $Timeout
            Write-Verbose "Docker image '$Name' removed."
        }

    }
}
