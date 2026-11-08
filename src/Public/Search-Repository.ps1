function Search-Repository {

    <#

    .SYNOPSIS
    Search Docker Hub repositories.

    .DESCRIPTION
    Searches Docker Hub and returns repository details. Results can be filtered by
    official status, automated builds, and minimum star count.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Search-DockerRepository.html

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
    # Prerequisites: Docker CLI is installed and can access Docker Hub.
    Search-DockerRepository -Term 'hello-world' -Limit 5 -IsOfficial | Format-List

    Searches for official repositories matching hello-world.
    Captured output (search results and popularity values can change):
    Name        : hello-world
    Description : Hello World! (an example of minimal Dockerization)
    Stars       : 0
    IsAutomated : False
    IsOfficial  : True

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
