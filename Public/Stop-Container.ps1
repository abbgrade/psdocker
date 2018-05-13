function Stop-Container {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    Invoke-DockerCLI 'stop', $Name
    Write-Debug "Docker container removed."
}