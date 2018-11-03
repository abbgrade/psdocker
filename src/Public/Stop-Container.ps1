function Stop-Container {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [int]
        $TimeoutMS = 10 * 1000
    )

    Invoke-ClientCommand 'stop', $Name -TimeoutMS $TimeoutMS
    Write-Verbose "Docker container removed."
}