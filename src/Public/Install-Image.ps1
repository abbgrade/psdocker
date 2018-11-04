function Install-Image {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Image,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 5 * 60
    )

    Invoke-ClientCommand "pull", $Image -Timeout $Timeout
    Write-Verbose "Docker image '$Image' pulled."
}