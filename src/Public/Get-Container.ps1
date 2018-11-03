function Get-Container {

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
        $TimeoutMS = 1000
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
        -TimeoutMS $TimeoutMS `
        -TableOutput `
        -ColumnNames @{
            'CONTAINER ID' = 'ContainerID'
            'IMAGE' = 'Image'
            'COMMAND' = 'Command'
            'CREATED' = 'Created'
            'STATUS' = 'Status'
            'PORTS' = 'Ports'
            'NAMES' = 'Name'
    }
}