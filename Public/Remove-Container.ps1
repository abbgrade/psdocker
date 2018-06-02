function Remove-Container {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [switch]
        $Force,

        [int]
        $TimeoutMS = 10000
    )

    if ( $Force ) {
        Stop-Container -Name $Name
    }

    Invoke-ClientCommand -TimeoutMS:$TimeoutMS 'rm', $Name
    Write-Debug "Docker container removed."
}