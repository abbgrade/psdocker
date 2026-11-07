function Search-Repository {

    <#

    .SYNOPSIS
    Search the Docker Hub for repositories

    .DESCRIPTION
    Wraps the command `docker search`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/search/

    .OUTPUTS
    Repository: Returns objects of type `Repository` that has the following properties:
    - Name
    - Description
    - Stars
    - IsAutomated
    - IsOfficial

    .EXAMPLE
    PS C:\> Search-DockerRepository 'nanoserver' -Limit 2

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
        # Specifies the search term.
        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Term,

        # Specifies the maximum number of results. If 0, Docker's default limit (25) is used.
        [Parameter( Mandatory = $true )]
        [int] $Limit,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter( Mandatory = $false )]
        [int] $Timeout = 30,

        # Returns only repositories with automated builds.
        [Parameter( Mandatory = $false )]
        [switch] $IsAutomated,

        # Returns only official repositories.
        [Parameter( Mandatory = $false )]
        [switch] $IsOfficial,

        # Returns only repositories with at least this many stars.
        [Parameter( Mandatory = $false )]
        [int] $MinimumStars
    )

    process {

        # prepare arugments
        $arguments = New-Object System.Collections.ArrayList
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

        $searchDescription = "Searching Docker Hub repositories for '$Term'"
        if ( $IsOfficial ) {
            $searchDescription += ', official only'
        }
        if ( $IsAutomated ) {
            $searchDescription += ', automated builds only'
        }
        if ( $MinimumStars ) {
            $searchDescription += ", at least $MinimumStars stars"
        }
        if ( $Limit ) {
            $searchDescription += " (limit $Limit)"
        }
        Write-Verbose "$searchDescription."

        Invoke-ClientCommand 'search', $arguments `
            -Timeout $Timeout `
            -JsonOutput |
        Foreach-Object {
            New-Object -Type Repository -Property @{
                Name = $_.Name
                Description = $_.Description
                Stars = [int] $_.Stars
                IsOfficial = $_.IsOfficial
                IsAutomated = $_.IsAutomated
            }
        } | Write-Output

    }
}
