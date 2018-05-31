function Install-Image {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Image,

        [int]
        $TimeoutMS = $null
    )

    Invoke-ClientCommand "pull", $Image -TimeoutMS $TimeoutMS
    Write-Debug "Docker image '$Image' pulled."
}