function Get-Version {

    <#

    .SYNOPSIS

    Get version information

    .DESCRIPTION

    Returns version information of the docker client and service.
    Wraps the command [docker version](https://docs.docker.com/engine/reference/commandline/version/).

    .PARAMETER Timeout

    Specifies the number of seconds to wait for the command to finish.

    .EXAMPLE

    PS C:\> $version = Get-DockerVersion
    PS C:\> $version.Client
    Version      : 18.06.1-ce
    Goversion    : go1.10.3
    Experimental : false
    APIversion   : 1.38
    Gitcommit    : e68fc7a
    Built        : Tue Aug 21 17:21:34 2018
    OSArch       : windows/amd64

    PS C:\> $version.Server
    Version      : 18.06.1-ce
    Built        : Tue Aug 21 17:36:40 2018
    Experimental : false
    Goversion    : go1.10.3
    APIversion   : 1.38 (minimum version 1.24)
    Gitcommit    : e68fc7a
    Engine:      :
    OSArch       : windows/amd64

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $Timeout = 1
    )

    $output = (
        Invoke-ClientCommand "version" -Timeout $Timeout -StringOutput
    ).Split( [Environment]::NewLine )

    $dockerVersionTable = @{
        'Client' = @{}
        'Server' = @{}
    }

    $component = $null
    foreach ( $line in $output ) {
        switch -Wildcard ( $line ) {
            "" {}
            "Client:*" { $component = 'Client' }
            "Server:*" { $component = 'Server' }
            Default {
                if ( -not $component ) {
                    throw "unexpected response from 'docker version'"
                } else {
                    $key, $value = $line -Split ':  ' | ForEach-Object { $_.Trim() }
                    $componentVersionTable = $dockerVersionTable[$component]
                    $componentVersionTable.Add($key.Replace('/', '').Replace(' ', ''), $value)
                }
            }
        }
    }

    New-Object PSObject -Property @{
        Client = ( New-Object PSObject -Property $dockerVersionTable['Client'] )
        Server = ( New-Object PSObject -Property $dockerVersionTable['Server'] )
    }

}