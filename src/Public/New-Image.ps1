function New-Image {

    <#

    .SYNOPSIS
    Build a docker image.

    .DESCRIPTION
    Builds a docker image from a Dockerfile and context directory.
    Wraps the command `docker build`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/build/

    .EXAMPLE
    PS C:\> New-DockerImage -Repository 'myapp' -Tag 'latest' -Path 'C:\\src\\myapp'

    #>

    [CmdletBinding()]
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
        Invoke-ClientCommand "build", $arguments -Timeout $Timeout | Write-Output
    }
}
