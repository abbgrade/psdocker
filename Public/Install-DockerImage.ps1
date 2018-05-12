function Install-DockerImage {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Image
    )

    Invoke-DockerCLI "pull", $Image
    Write-Debug "Docker image '$Image' pulled."
}