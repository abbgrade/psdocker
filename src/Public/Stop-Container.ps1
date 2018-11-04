function Stop-Container {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 10
    )

    Invoke-ClientCommand 'stop', $Name -Timeout $Timeout
    Write-Verbose "Docker container removed."
}