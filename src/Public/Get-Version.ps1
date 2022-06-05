function Get-Version {

    <#

    .SYNOPSIS
    Get version information

    .DESCRIPTION
    Returns version information of the docker client and service.
    Wraps the command `docker version`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/version/

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
        [int] $Timeout = 1
    )

    $versionOutput = Invoke-ClientCommand 'version' -Timeout $Timeout -StringOutput
    if ( -Not $versionOutput ) {
        Write-Error 'docker version did not return a output.'
        return
    }

    $output = $versionOutput.Split( [Environment]::NewLine )

    $dockerVersionTable = @{}
    $stack = New-Object System.Collections.Stack
    $stack.Push( $dockerVersionTable )

    $previousDepth = 0
    $previousKey = $null
    foreach ( $line in $output ) {
        switch -Wildcard ( $line ) {
            "" {}
            Default {
                $key, $value = $line -split ':', 2
                $depth = 0
                foreach ( $item in $key.ToCharArray() ) {
                    if ( $item -eq ' ' ) {
                        $depth = $depth + 1
                    } else {
                        break
                    }
                }

                $key = $key.Trim()
                $value = $value.Trim()

                if ( $previousDepth -gt $depth ) {
                    $stack.Pop() | Out-Null
                }
                if ( $previousDepth -lt $depth ) {
                    $node = @{
                        $key = $value
                    }
                    $stack.Peek()[$previousKey] = $node
                    $stack.Push( $node )
                } else {
                    $stack.Peek()[$key] = $value
                }

                $previousKey = $key
                $previousDepth = $depth
            }
        }
    }

    function ConvertTo-PsObject {
        param (
            [hashtable] $Value
        )

        foreach ( $key in @( $Value.Keys ) ) {
            $plainKey = $key.Replace('/', '').Replace(' ', '')
            $temp = $Value[$key]
            $Value.Remove($key)
            $Value[$plainKey] = $temp
        }

        foreach ( $key in $Value.Keys | Where-Object { $Value[$_].GetType() -eq @{}.GetType() } ) {
            $Value[$key] = ConvertTo-PsObject $Value[$key]
        }

        New-Object PSObject -Property $Value | Write-Output
    }

    ConvertTo-PsObject $dockerVersionTable | Write-Output
}
