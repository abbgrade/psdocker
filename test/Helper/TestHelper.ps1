
param (
    [string] $ModuleManifestPath = "$PSScriptRoot\..\..\src\psdocker.psd1"
)

function Get-WindowsContainerImageTag {
    param (
        [Parameter(Mandatory)][string] $ProductName,
        [Parameter(Mandatory)][int] $BuildNumber,
        [Parameter(Mandatory)][string] $ReleaseId
    )

    if ($ProductName -notlike 'Windows Server*') {
        return $ReleaseId
    }

    switch ($BuildNumber) {
        14393 { 'ltsc2016' }
        17763 { 'ltsc2019' }
        20348 { 'ltsc2022' }
        26100 { 'ltsc2025' }
        default { $ReleaseId }
    }
}

Import-Module $ModuleManifestPath -Force

$version = Get-DockerVersion -ErrorAction Stop
$global:TestConfig = New-Object -Type PsObject -Property $(
    switch ( $version.Server.Engine.OSArch ) {
        'windows/amd64' {

            $local:windowsVersion = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
            $local:image = [ordered] @{
                Repository = 'mcr.microsoft.com/windows/nanoserver'
                Tag = Get-WindowsContainerImageTag `
                    -ProductName $windowsVersion.ProductName `
                    -BuildNumber $windowsVersion.CurrentBuildNumber `
                    -ReleaseId $windowsVersion.ReleaseId
            }
            $local:image.Name = $local:image.Repository + ':' + $local:image.Tag
            @{
                Image = [PSCustomObject] $local:image
                PrintCommand = 'cmd /c echo'
                ReadFileCommand = 'cmd /c type'
                MountPoint = 'C:\volume'
            } | Write-Output
        }
        'linux/amd64' {
            $local:image = [ordered] @{
                Repository = 'mcr.microsoft.com/powershell'
                Tag = 'latest'
            }
            $local:image.Name = $local:image.Repository + ':' + $local:image.Tag
            @{
                Image = [PSCustomObject] $local:image
                PrintCommand = 'echo'
                ReadFileCommand = 'cat'
                MountPoint = '/tmp/volume'
            } | Write-Output
        }
        default {
            Write-Error "Missing test for $_"
        }
    }
)
