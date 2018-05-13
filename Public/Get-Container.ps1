function Get-Container {

    param (
        [switch]
        $Running,

        [switch]
        $Latest
    )

    $arguments = New-Object System.Collections.ArrayList

    $arguments.Add( 'ps' ) | Out-Null

    if ( $Running -eq $false ) {
        $arguments.Add( '--all' ) | Out-Null
    }

    if ( $Latest ) {
        $arguments.Add( '--latest' ) | Out-Null
    }

    # $arguments.Add( '--no-trunc' ) | Out-Null

    Invoke-ClientCommand -ArgumentList $arguments -TableOutput -ColumnNames @{
        'CONTAINER ID' = 'ContainerID'
        'IMAGE' = 'Image'
        'COMMAND' = 'Command'
        'CREATED' = 'Created'
        'STATUS' = 'Status'
        'PORTS' = 'Ports'
        'NAMES' = 'Name'
    }
    Write-Debug "Docker container removed."
}