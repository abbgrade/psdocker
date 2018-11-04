function Get-Container {

    <#

    .SYNOPSIS Get docker container

    .DESCRIPTION
    Returns references to docker containers of a docker service.
    It can be filtered by name and status.
    Wraps the docker command [ps](https://docs.docker.com/engine/reference/commandline/ps/).

    .PARAMETER Running
    Specifies if only running containers should be returned.

    .PARAMETER Latest
    Specifies if only the latest created container should be returned.

    .PARAMETER Name
    Specifies if only the container with the given name should be returned.

    .PARAMETER Timeout
    Specifies the timeout of the docker client command.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [switch]
        $Running,

        [Parameter(Mandatory=$false)]
        [switch]
        $Latest,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $Timeout = 1
    )

    $arguments = New-Object System.Collections.ArrayList

    $arguments.Add( 'ps' ) | Out-Null

    if ( $Running -eq $false ) {
        $arguments.Add( '--all' ) | Out-Null
    }

    if ( $Latest ) {
        $arguments.Add( '--latest' ) | Out-Null
    }

    if ( $Name ) {
        $arguments.Add( "--filter name=$Name" ) | Out-Null
    }

    $arguments.Add( '--no-trunc' ) | Out-Null

    Invoke-ClientCommand `
        -ArgumentList $arguments `
        -Timeout $Timeout `
        -TableOutput @{
            'CONTAINER ID' = 'ContainerID'
            'IMAGE' = 'Image'
            'COMMAND' = 'Command'
            'CREATED' = 'Created'
            'STATUS' = 'Status'
            'PORTS' = 'Ports'
            'NAMES' = 'Name'
    }
}