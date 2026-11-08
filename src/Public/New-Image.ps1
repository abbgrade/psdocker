function New-Image {

    <#

    .SYNOPSIS
    Build a Docker image.

    .DESCRIPTION
    Builds an image from a Dockerfile in the specified build context.
    Supports -WhatIf and -Confirm. Wraps the Docker CLI `build` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/New-DockerImage.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/build/

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    $repository = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    $buildContext = Join-Path $env:TEMP $repository
    New-Item -Path $buildContext -ItemType Directory | Out-Null
    Set-Content -Path (Join-Path $buildContext 'Dockerfile') -Value 'FROM mcr.microsoft.com/powershell:latest'
    New-DockerImage -Repository $repository -Path $buildContext
    Get-DockerImage -Repository $repository -Tag 'latest' |
        Format-List Repository,Tag,Id,Size
    Uninstall-DockerImage -Name "$repository`:latest" -Force
    Remove-Item -Path $buildContext -Recurse -Force

    Creates a temporary build context, builds the image, verifies it, then removes the image and context.
    The build command itself produces no PowerShell output; Get-DockerImage returns the image.
    Captured output (temporary repository name redacted):
    Repository : psdocker-example-...
    Tag        : latest
    Id         : sha256:6b12245d294980267796ce1828c74dfb0991ba46e412d372417b0ddc89d31652
    Size       : 489MB

    .EXAMPLE
    $buildContext = Join-Path $env:TEMP "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    New-Item -Path $buildContext -ItemType Directory | Out-Null
    New-DockerImage -Repository 'psdocker-example' -Path $buildContext -WhatIf
    Remove-Item -Path $buildContext -Recurse -Force

    Shows the build operation without building an image, then removes the temporary context.
    Captured output:
    What if: Performing the operation "Build Docker image" on target "psdocker-example:latest".

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # Specifies the repository name for the image to build.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName = $true )]
        [Alias( 'Name' )]
        [ValidateNotNullOrEmpty()]
        [string] $Repository,

        # Specifies the tag to apply to the image. Defaults to 'latest'.
        [Parameter( ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Tag = 'latest',

        # Specifies the directory containing the Dockerfile and build context.
        [Parameter( ValueFromPipelineByPropertyName = $true )]
        [ValidateScript({ $_.Exists })]
        [System.IO.DirectoryInfo] $Path,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter()]
        [int] $Timeout = 10
    )

    process {
        $arguments = New-Object System.Collections.ArrayList
        $arguments.Add("-t $( $Repository ):$Tag") | Out-Null
        $arguments.Add("$Path") | Out-Null

        Write-Verbose "Building Docker image '$Repository`:$Tag' from '$Path'."
        if ( $PSCmdlet.ShouldProcess( "$Repository`:$Tag", 'Build Docker image' ) ) {
            Invoke-ClientCommand "build", $arguments -Timeout $Timeout | Write-Output
        }
    }
}
