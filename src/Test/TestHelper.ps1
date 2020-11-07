
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } ),
    [string] $ModuleManifestPath = "$PSScriptRoot\..\PSDocker.psd1"
)

Import-Module "$PSScriptRoot\..\PSDocker.psd1" -Force

$version = Get-DockerVersion
$testConfig = New-Object -Type PsObject -Property $(
    switch ( $version.Server.Engine.OSArch ) {
        'windows/amd64' {
            @{
                Image = New-Object PsObject -Property @{
                    Repository = 'microsoft/nanoserver'
                    Tag = 'latest'
                    Name = 'microsoft/nanoserver:latest'
                }
                PrintCommand = 'powershell -c Write-Host'
                PowershellCommand = 'powershell -c '
                MountPoint = 'C:\volume'
            } | Write-Output
        }
        'linux/amd64' {
            @{
                Image = New-Object PsObject -Property @{
                    Repository = 'microsoft/powershell'
                    Tag = 'latest'
                    Name = 'microsoft/powershell:latest'
                }
                PrintCommand = 'echo'
                PowershellCommand = 'pwsh -c '
                MountPoint = '/tmp/volume'
            } | Write-Output
        }
        default {
            Write-Error "Missing test for $_"
        }
    }
)
