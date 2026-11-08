Register-ArgumentCompleter -CommandName Uninstall-DockerImage -ParameterName Name -ScriptBlock $ImageNameCompleter

function Uninstall-Image {

    <#

    .SYNOPSIS
    Remove a Docker image.

    .DESCRIPTION
    Removes a local image, optionally forcing removal or preventing removal of
    untagged parent images. Supports -WhatIf and -Confirm.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Uninstall-DockerImage.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/image_rm/

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    $repository = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    $buildContext = Join-Path $env:TEMP $repository
    New-Item -Path $buildContext -ItemType Directory | Out-Null
    Set-Content -Path (Join-Path $buildContext 'Dockerfile') -Value 'FROM mcr.microsoft.com/powershell:latest'
    New-DockerImage -Repository $repository -Path $buildContext
    Get-DockerImage -Repository $repository -Tag 'latest' |
        Uninstall-DockerImage -Force
    Remove-Item -Path $buildContext -Recurse -Force

    Builds a uniquely named temporary image, then removes it through the pipeline.
    Captured output:
    No output. The image is removed.
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
