function Remove-Container {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [switch]
        $Force
    )

    if ( $Force ) {
        Stop-Container -Name $Name
    }

    Invoke-DockerCLI 'rm', $Name
    Write-Debug "Docker container removed."
}