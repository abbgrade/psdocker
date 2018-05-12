function New-Container {

    param (
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Image,

        [Hashtable]
        $Environment,

        [hashtable]
        $Ports,

        [switch]
        $Detach
    )

    $arguments = New-Object System.Collections.ArrayList

    $arguments.Add( 'run' ) | Out-Null

    if ( $Name ) {
        $arguments.Add( "--name $Name" ) | Out-Null
    }

    if ( $Environment ) {
        foreach ( $item in $Environment.GetEnumerator() ) {
            $arguments.Add( "-e `"$( $item.Name)=$( $item.Value )`"") | Out-Null
        }
    }

    if ( $Ports ) {
        foreach ( $item in $Ports.GetEnumerator() ) {
            $arguments.Add( "-p $( $item.Name):$( $item.Value )") | Out-Null
        }
    }

    if ( $Detach ) {
        $arguments.Add( '-d' ) | Out-Null
    }

    $arguments.Add( $Image ) | Out-Null

    Invoke-DockerCLI -ArgumentList $arguments

    Write-Debug "Docker container created."
}