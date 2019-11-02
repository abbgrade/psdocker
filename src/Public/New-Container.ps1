Register-ArgumentCompleter -CommandName New-DockerContainer -ParameterName Image -ScriptBlock $ImageNameCompleter


function New-Container {

    <#

    .SYNOPSIS
    New container

    .DESCRIPTION
    Creates a new container in the docker service.
    Wraps the command `docker run`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/run/

    .PARAMETER Name
    Specifies the name of the new container.
    If not specified, a name will be generated.

    .PARAMETER Image
    Specifies the name if the image to create the container based on.

    .PARAMETER Environment
    Specifies the environment variables that are used during the container creation.

    .PARAMETER Ports
    Specifies the portmapping of the created container.

    .PARAMETER Volumes
    Specifies the volumes to mount as a hashmap,
    where the key is the path on the host and the value the path in the container.

    .PARAMETER Timeout
    Specifies the number of seconds to wait for the command to finish.

    .PARAMETER StatusTimeout
    Specifies the timeout of the docker client for the container lookup after creation.

    .PARAMETER Detach
    Specifies if the container should be detached.
    That means to run the container without connection to the client shell.

    .PARAMETER Interactive
    Specifies if the container should be interactive.
    That means to connect the standard-in stream of container and client.

    .OUTPUTS
    Container: Returns a Container object for the created container.

    .EXAMPLE
    PS C:\> New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer'
    Image       : microsoft/nanoserver
    Ports       :
    Command     : "c:\\windows\\system32\\cmd.exe"
    Created     : 14 seconds ago
    Name        : mycontainer
    ContainerID : 1a0b70cfcfba78e46468dbfa72b0b36fae4c30282367482bc348b5fcee0b85d3
    Status      : Exited (0) 1 second ago

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Image' )]
        [string] $ImageName,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Environment,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Ports,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Volumes,

        [Parameter( Mandatory = $false )]
        [int] $Timeout = 30,

        [Parameter( Mandatory = $false )]
        [int] $StatusTimeout = 1,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [switch] $Detach,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [switch] $Interactive
    )

    process {

        # prepare arugments
        $arguments = New-Object System.Collections.ArrayList

        if ( $Name ) {
            $arguments.Add( "--name $Name" ) | Out-Null
        }

        if ( $Environment ) {
            foreach ( $item in $Environment.GetEnumerator() ) {
                $arguments.Add( "--env `"$( $item.Name)=$( $item.Value )`"") | Out-Null
            }
        }

        if ( $Ports ) {
            foreach ( $item in $Ports.GetEnumerator() ) {
                $arguments.Add( "--publish $( $item.Name):$( $item.Value )") | Out-Null
            }
        }

        if ( $Volumes ) {
            foreach ( $volume in $Volumes.GetEnumerator() ) {
                $arguments.Add( "--volume $( $volume.Name ):$( $volume.Value )" ) | Out-Null
            }
        }

        if ( $Detach ) {
            $arguments.Add( '--detach' ) | Out-Null
        }

        if ( $Interactive ) {
            $arguments.Add( '--interactive' ) | Out-Null
        }

        $arguments.Add( $ImageName ) | Out-Null

        # create container
        Invoke-ClientCommand 'run', $arguments -Timeout $Timeout

        # check container
        $container = Get-Container -Latest -Timeout $StatusTimeout
        if ( -not $container.Name ) {
            Write-Error "Failed to create container"
        }
        Write-Verbose "Docker container '$( $container.Name )' created."

        # return result
        Write-Output $container

    }
}
