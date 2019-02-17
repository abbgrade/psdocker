function Search-Image {

    <#

    .SYNOPSIS

    Search the Docker Hub for images

    .DESCRIPTION

    Wraps the command [docker search](https://docs.docker.com/engine/reference/commandline/search/).

    .PARAMETER Term

    Specifies the search term.

    .PARAMETER Limit

    Specifies the maximum number of results.
    If the limit is $null or 0 the docker default (25) is used instead.

    .PARAMETER Timeout

    Specifies the number of seconds to wait for the command to finish.

    .PARAMETER IsAutomated

    Returns only images with automated build.

    .PARAMETER IsOfficial

    Returns only official images.

    .PARAMETER MininumStars

    Returns only images with at least specified stars.

    .OUTPUTS

    Returns objects of type `Image` that has the following properties:
    - Name
    - Description
    - Stars
    - IsAutomated
    - IsOfficial

    .EXAMPLE

    PS C:\> Search-DockerImage 'nanoserver' -Limit 2

    Name        : microsoft/nanoserver
    Description : The official Nano Server base image
    Stars       : 479
    IsAutomated : False
    IsOfficial  : False

    Name        : nanoserver/iis
    Description : Nano Server + IIS. Updated on 08/21/2018 -- Version: 10.0.14393.2312
    Stars       : 42
    IsAutomated : False
    IsOfficial  : False

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
        $Timeout = 30,

        [Parameter(Mandatory=$false)]
        [switch]
        $IsAutomated,

        [Parameter(Mandatory=$false)]
        [switch]
        $IsOfficial,

        [Parameter(Mandatory=$false)]
        [int]
        $MinimumStars
    )

    # prepare arugments
    $arguments = New-Object System.Collections.ArrayList

    $arguments.Add( 'search' ) | Out-Null
    $arguments.Add( '--no-trunc' ) | Out-Null
    $arguments.Add( '--format="{{json .}}"' ) | Out-Null

    if ( $Limit ) {
        $arguments.Add( "--limit $Limit" ) | Out-Null
    }

    if ( $IsOfficial ) {
        $arguments.Add( "--filter `"is-official=true`"" ) | Out-Null
    }

    if ( $IsAutomated ) {
        $arguments.Add( "--filter `"is-automated=true`"" ) | Out-Null
    }

    if ( $MinimumStars ) {
        $arguments.Add( "--filter `"stars=$MinimumStars`"" ) | Out-Null
    }

    $arguments.Add( $Term ) | Out-Null

    Invoke-ClientCommand `
        -ArgumentList $arguments `
        -Timeout $Timeout `
        -JsonOutput |
    Foreach-Object {
        New-Object -Type Image -Property @{
            Name = $_.Name
            Description = $_.Description
            Stars = [int] $_.Stars
            IsOfficial = $_.IsOfficial
            IsAutomated = $_.IsAutomated
        }
    } | Write-Output
}
