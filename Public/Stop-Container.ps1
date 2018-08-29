function Stop-Container {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    Invoke-ClientCommand 'stop', $Name
    Write-Debug "Docker container removed."
}