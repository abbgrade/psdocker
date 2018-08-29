function Remove-Container {
    [CmdletBinding()]
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

    Invoke-ClientCommand 'rm', $Name -TimeoutMS $TimeoutMS
    Write-Debug "Docker container removed."
}