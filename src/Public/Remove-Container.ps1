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
        $Timeout = 10
    )

    if ( $Force ) {
        Stop-Container -Name $Name
    }

    Invoke-ClientCommand 'rm', $Name -Timeout $Timeout
    Write-Verbose "Docker container removed."
}