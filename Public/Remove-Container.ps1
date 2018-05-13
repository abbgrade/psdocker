function Remove-Container {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    Invoke-DockerCLI 'rm', $Name
    Write-Debug "Docker container removed."
}