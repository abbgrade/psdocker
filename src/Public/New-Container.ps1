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
        # Specifies the name of the new container. If not specified, a name will be generated.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Specifies the name of the image to create the container from.
        [Parameter( Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Image' )]
        [string] $ImageName,

        # Specifies the environment variables to use during container creation.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Environment,

        # Specifies the port mappings for the created container.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Ports,

        # Specifies the volumes to mount, mapping host paths to container paths.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Volumes,

        # Specifies the number of seconds to wait for the command to finish.
        [Parameter( Mandatory = $false )]
        [int] $Timeout = 30,

        # Specifies the timeout of the Docker client for the container lookup after creation.
        [Parameter( Mandatory = $false )]
        [int] $StatusTimeout = 1,

        # Runs the container without a connection to the client shell.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [switch] $Detach,

        # Connects the container's standard input to the client.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [switch] $Interactive,

        # Allocates a pseudo-TTY.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [switch] $Terminal,

        # Automatically removes the container when it exits.
        [Parameter( Mandatory = $false )]
        [switch] $Remove,

        # Returns the Docker command output as a string.
        [Parameter( Mandatory = $false )]
        [switch] $StringOutput,

        # Specifies the command and arguments to run in the container.
        [Parameter( Mandatory = $false )]
        [string[]] $ArgumentList
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

        if ( $Terminal ) {
            $arguments.Add( '--tty' ) | Out-Null
        }

        if ( $Remove ) {
            $arguments.Add( '--rm' ) | Out-Null
        }

        $arguments.Add( $ImageName ) | Out-Null

        if ( $ArgumentList ) {
            $arguments.AddRange( $ArgumentList )
        }

        # create container
        Invoke-ClientCommand 'run', $arguments -StringOutput:$StringOutput -Timeout $Timeout

        if ( -Not $Remove ) {
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
}
