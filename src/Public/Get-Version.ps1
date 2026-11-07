function Get-Version {

    <#

    .SYNOPSIS
    Get version information

    .DESCRIPTION
    Returns version information of the docker client and service.
    Wraps the command `docker version`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/version/

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
        # Specifies the number of seconds to wait for the command to finish.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int] $Timeout = 1
    )

    Write-Verbose 'Retrieving Docker client and server version information.'
    $versionOutput = & docker version --format "{{json .}}" 2>&1
    $dockerExitCode = $LASTEXITCODE
    if ( $dockerExitCode -ne 0 -or -not $versionOutput ) {
        $diagnosticOutput = ($versionOutput | Out-String).Trim()
        if ( -not $diagnosticOutput ) {
            $diagnosticOutput = '<no output>'
        }
        Write-Verbose "docker version exited with code $dockerExitCode. Captured output: $diagnosticOutput"
        Write-Error 'docker version did not return a valid result.'
        return
    }

    $dockerVersion = ($versionOutput | Out-String) | ConvertFrom-Json
    if ( -not $dockerVersion ) {
        $diagnosticOutput = ($versionOutput | Out-String).Trim()
        Write-Verbose "docker version returned output that could not be parsed as JSON: $diagnosticOutput"
        Write-Error 'docker version output could not be parsed as JSON.'
        return
    }

    $client = [pscustomobject]@{
        Version = $dockerVersion.Client.Version
        Goversion = $dockerVersion.Client.GoVersion
        Experimental = $dockerVersion.Client.Experimental
        APIversion = $dockerVersion.Client.ApiVersion
        Gitcommit = $dockerVersion.Client.GitCommit
        Built = $dockerVersion.Client.BuildTime
        OSArch = "$($dockerVersion.Client.Os)/$($dockerVersion.Client.Arch)"
    }

    $engine = $dockerVersion.Server.Components | Where-Object { $_.Name -eq 'Engine' } | Select-Object -First 1
    $serverEngine = [pscustomobject]@{
        Version = if ( $engine ) { $engine.Version } else { $dockerVersion.Server.Version }
        Goversion = if ( $engine ) { $engine.Details.GoVersion } else { $dockerVersion.Server.GoVersion }
        Experimental = if ( $engine ) { $engine.Details.Experimental } else { $dockerVersion.Server.Experimental }
        APIversion = if ( $engine ) { $engine.Details.ApiVersion } else { $dockerVersion.Server.ApiVersion }
        Gitcommit = if ( $engine ) { $engine.Details.GitCommit } else { $dockerVersion.Server.GitCommit }
        Built = if ( $engine ) { $engine.Details.BuildTime } else { $dockerVersion.Server.BuildTime }
        OSArch = "$($dockerVersion.Server.Os)/$($dockerVersion.Server.Arch)"
    }

    $server = [pscustomobject]@{
        Version = $dockerVersion.Server.Version
        Goversion = $dockerVersion.Server.GoVersion
        Experimental = $dockerVersion.Server.Experimental
        APIversion = $dockerVersion.Server.ApiVersion
        Gitcommit = $dockerVersion.Server.GitCommit
        Built = $dockerVersion.Server.BuildTime
        OSArch = "$($dockerVersion.Server.Os)/$($dockerVersion.Server.Arch)"
        Engine = $serverEngine
    }

    [pscustomobject]@{
        Client = $client
        Server = $server
    } | Write-Output
}
