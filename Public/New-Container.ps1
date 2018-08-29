function New-Container {
    [CmdletBinding()]
    param (
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Image,

        [hashtable]
        $Environment,

        [hashtable]
        $Ports,

        [int]
        $TimeoutMS = $null,

        [switch]
        $Detach,

        [switch]
        $Interactive
    )

    # prepare arugments
    $arguments = New-Object System.Collections.ArrayList

    $arguments.Add( 'run' ) | Out-Null

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

    if ( $Detach ) {
        $arguments.Add( '--detach' ) | Out-Null
    }

    if ( $Interactive ) {
        $arguments.Add( '--interactive' ) | Out-Null
    }

    $arguments.Add( $Image ) | Out-Null

    # create container
    Invoke-ClientCommand -ArgumentList $arguments -TimeoutMS $TimeoutMS

    # check container
    $container = Get-Container -Latest
    if ( -not $container.Name ) {
        throw "Failed to create container"
    }
    Write-Debug "Docker container '$( $container.Name )' created."

    # return result
    $container
}