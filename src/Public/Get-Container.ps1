Register-ArgumentCompleter -CommandName Get-DockerContainer -ParameterName Name -ScriptBlock $ContainerNameCompleter

function Get-Container {

    <#

    .SYNOPSIS
    Get Docker containers.

    .DESCRIPTION
    Returns container information and can filter by running state, latest container,
    or name. Wraps the Docker CLI `ps` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Get-DockerContainer.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/ps/

    .OUTPUTS
    Container: Returns a Container object for each container matching the parameters.

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    $name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') | Out-Null
    Get-DockerContainer -Running -Name $name | Format-List Id,Name,Image,Status
    Remove-DockerContainer -Name $name -Force

    Creates a temporary running container, lists it, then removes it.
    Captured output (temporary container ID and generated name redacted):
    Id     : <redacted>
    Name   : psdocker-example-...
    Image  : mcr.microsoft.com/powershell:latest
    Status : Up Less than a second

    .EXAMPLE
    # Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
    $name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
    Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
    New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') | Out-Null
    Get-DockerContainer -Name $name | Format-List Id,Name,Image,Status
    Remove-DockerContainer -Name $name -Force

    Finds a container by name, then removes the temporary container.
    Captured output (temporary container ID and generated name redacted):
    Id     : <redacted>
    Name   : psdocker-example-...
    Image  : mcr.microsoft.com/powershell:latest
    Status : Up Less than a second

    #>

    [CmdletBinding()]
    param (
        # Specifies if only running containers should be returned.
        [Parameter(Mandatory=$false)]
        [switch] $Running,

        # Specifies if only the latest created container should be returned.
        [Parameter(Mandatory=$false)]
        [switch] $Latest,

        # Specifies if only the container with the given name should be returned.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Specifies the number of seconds to wait for the command to finish.
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

    $filters = @()
    if ( $Running ) {
        $filters += 'running containers'
    }
    if ( $Latest ) {
        $filters += 'latest container'
    }
    if ( $Name ) {
        $filters += "name '$Name'"
    }
    $filterDescription = if ( $filters.Count ) { " matching $($filters -join ', ')" } else { '' }
    Write-Verbose "Retrieving Docker containers$filterDescription."

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
