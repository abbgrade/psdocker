function New-Image {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory, ValueFromPipelineByPropertyName = $true )]
        [Alias( 'Name' )]
        [ValidateNotNullOrEmpty()]
        [string] $Repository,

        [Parameter( ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Tag = 'latest',

        [Parameter( ValueFromPipelineByPropertyName = $true )]
        [ValidateScript({ $_.Exists })]
        [System.IO.DirectoryInfo] $Path,

        [Parameter()]
        [int] $Timeout = 10
    )

    process {
        $arguments = New-Object System.Collections.ArrayList
        $arguments.Add("-t $( $Repository ):$Tag") | Out-Null
        $arguments.Add("$Path") | Out-Null

        Invoke-ClientCommand "build", $arguments -Timeout $Timeout | Write-Output
    }
}
