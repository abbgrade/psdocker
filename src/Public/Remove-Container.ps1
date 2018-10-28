function Remove-Container {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [switch]
        $Force,

        [Parameter(Mandatory=$false)]
        [int]
        $TimeoutMS = 10 * 1000
    )

    if ( $Force ) {
        Stop-Container -Name $Name
    }

    Invoke-ClientCommand 'rm', $Name -TimeoutMS $TimeoutMS
    Write-Verbose "Docker container removed."
}