function Get-Version {

    <#

    .SYNOPSIS
    Get Docker client and server version information.

    .DESCRIPTION
    Returns version details for the Docker client and server, including engine information.
    Wraps the Docker CLI `version` command.

    .LINK
    https://abbgrade.github.io/psdocker/docs/Get-DockerVersion.html

    .LINK
    https://docs.docker.com/engine/reference/commandline/version/

    .OUTPUTS
    PSCustomObject: Contains Client and Server version information.

    .EXAMPLE
    # Prerequisite: Docker CLI is installed and the Docker daemon is running.
    $version = Get-DockerVersion
    $version.Server | Format-List

    Gets client and server version details, then displays the server information.
    Captured output from Docker Engine 29.9.2:
    Version  : 29.9.2
    Goversion : go1.26.10
    APIversion : 1.56
    Gitcommit : 0367cbe
    Built     : 2026-10-20T18:45:02.000000000+00:00
    OSArch   : linux/amd64
    Engine   : @{Version=29.9.2; Goversion=go1.26.10; Experimental=false; APIversion=1.56; Gitcommit=0367cbe; Built=Tue Oct 20 19:45:02 2026; OSArch=linux/amd64}

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
