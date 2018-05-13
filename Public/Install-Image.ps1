function Install-Image {

    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Image
    )

    Invoke-ClientCommand "pull", $Image
    Write-Debug "Docker image '$Image' pulled."
}