function Install-Image {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Image,

        [Parameter(Mandatory=$false)]
        [int]
        $TimeoutMS = 5 * 60 * 1000
    )

    Invoke-ClientCommand "pull", $Image -TimeoutMS $TimeoutMS
    Write-Verbose "Docker image '$Image' pulled."
}