function New-Container {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Image,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $Environment,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $Ports,

        [Parameter(Mandatory=$false)]
        [int]
        $TimeoutMS = 30 * 1000,

        [Parameter(Mandatory=$false)]
        [switch]
        $Detach,

        [Parameter(Mandatory=$false)]
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
    $container = Get-Container -Latest -TimeoutMS $TimeoutMS
    if ( -not $container.Name ) {
        throw "Failed to create container"
    }
    Write-Verbose "Docker container '$( $container.Name )' created."

    # return result
    $container
}