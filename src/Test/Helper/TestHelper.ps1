
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } ),
    [string] $ModuleManifestPath = "$PSScriptRoot\..\..\PSDocker.psd1"
)

Import-Module $ModuleManifestPath -Force

$version = Get-DockerVersion
$global:TestConfig = New-Object -Type PsObject -Property $(
    switch ( $version.Server.Engine.OSArch ) {
        'windows/amd64' {

            $local:image = [ordered] @{
                Repository = 'mcr.microsoft.com/windows/nanoserver'
                Tag = [string] (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
            }
            $local:image.Name = $local:image.Repository + ':' + $local:image.Tag
            @{
                Image = [PSCustomObject] $local:image
                PrintCommand = 'powershell -c Write-Host'
                PowershellCommand = 'powershell -c '
                MountPoint = 'C:\volume'
            } | Write-Output
        }
        'linux/amd64' {
            $local:image = [ordered] @{
                Repository = 'microsoft/powershell'
                Tag = 'latest'
                Name = 'microsoft/powershell:latest'
            }
            $local:image.Name = $local:image.Repository + ':' + $local:image.Tag
            @{
                Image = [PSCustomObject] $local:image
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
