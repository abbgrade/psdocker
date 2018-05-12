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
    if ( $Name ) { $arguments.Add( "--name $Name" ) | Out-Null }
    foreach ( $item in $Environment ) { $arguments.Add( $item ) | Out-Null }
    foreach ( $item in $Ports ) { $arguments.Add( $item ) | Out-Null }
    if ( $Detach ) { $arguments.Add( '-d' ) | Out-Null }
    $arguments.Add( $Image ) | Out-Null

    Invoke-DockerCLI -ArgumentList $arguments

    Write-Debug "Docker container created."
}