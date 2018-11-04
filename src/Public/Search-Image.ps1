function Search-Image {

    <#

    .SYNOPSIS Search the Docker Hub for images

    .DESCRIPTION
    Wraps the docker command [search](https://docs.docker.com/engine/reference/commandline/search/).

    .PARAMETER Term
    Specifies the search term.

    .PARAMETER Limit
    Specifies the maximum number of results.
    If the limit is $null or 0 the docker default (25) is used instead.

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Term,

        [Parameter(Mandatory=$true)]
        [int]
        $Limit,

        [Parameter(Mandatory=$false)]
        [int]
        $TimeoutMS = 30 * 1000
    )

    # prepare arugments
    $arguments = New-Object System.Collections.ArrayList

    $arguments.Add( 'search' ) | Out-Null

    if ( $Limit ) {
        $arguments.Add( "--limit $Limit" ) | Out-Null
    }

    $arguments.Add( $Term ) | Out-Null

    $resultTable = Invoke-ClientCommand -ArgumentList $arguments -TimeoutMS $TimeoutMS -TableOutput -ColumnNames @{
        'NAME' = 'Name'
        'DESCRIPTION' = 'Description'
        'STARS' = 'Stars'
        'OFFICIAL' = 'IsOfficial'
        'AUTOMATED' = 'IsAutomated'
    } | Foreach-Object {
        New-Object -Type PsObject -Property @{
            Name = $_.Name
            Description = $_.Description
            Stars = [int] $_.Stars
            IsOfficial = switch($_.IsOfficial) { '[OK]' { $true } default { $false }}
            IsAutomated = switch($_.IsAutomated) { '[OK]' { $true } default { $false }}
        }
    }

    Write-Output $resultTable
}