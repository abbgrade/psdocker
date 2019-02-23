function Get-Container {

    <#

    .SYNOPSIS
    Get docker container

    .DESCRIPTION
    Returns references to docker containers of a docker service.
    It can be filtered by name and status.
    Wraps the command `docker ps`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/ps/

    .PARAMETER Running
    Specifies if only running containers should be returned.

    .PARAMETER Latest
    Specifies if only the latest created container should be returned.

    .PARAMETER Name
    Specifies if only the container with the given name should be returned.

    .PARAMETER Timeout
    Specifies the number of seconds to wait for the command to finish.

    .OUTPUTS
    Container:  It returns a `Container` object for each container matching the parameters.

    .EXAMPLE
    PS C:\> New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer' | Out-Null
    PS C:\> Get-DockerContainer -Name 'mycontainer'
    Image       : microsoft/nanoserver
    Ports       :
    Command     : "c:\\windows\\system32\\cmd.exe"
    Created     : 13 seconds ago
    Name        : mycontainer
    ContainerID : 1c3bd73d25552b41a677a99a15a9326ba72123096f9e10c3d36f72fb90e57f16
    Status      : Exited (0) 5 seconds ago

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [switch] $Running,

        [Parameter(Mandatory=$false)]
        [switch] $Latest,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int] $Timeout = 1
    )

    $arguments = New-Object System.Collections.ArrayList

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
    $arguments.Add( '--format="{{json .}}"' ) | Out-Null

    Invoke-ClientCommand 'ps', $arguments `
        -Timeout $Timeout `
        -JsonOutput |
    ForEach-Object {
        New-Object -TypeName Container -Property @{
            Command = $_.Command
            CreatedAt = $_.CreatedAt
            Id = $_.ID
            Image = $_.Image
            Labels = $_.Labels -split ','
            LocalVolumes = $_.LocalVolumes -split ','
            Mounts = $_.Mounts -split ','
            Names = $_.Names -split ','
            Networks = $_.Networks -split ','
            Ports = $_.Ports
            RunningFor = $_.RunningFor
            Size = $_.Size
            Status = $_.Status
        } | Write-Output
    } | Write-Output
}
