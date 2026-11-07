. $PSScriptRoot\UnitTestSetup.ps1

Import-Module $ModuleManifestPath -Force

$version = Get-DockerVersion -ErrorAction Stop
$global:TestConfig = New-Object -Type PsObject -Property $(
    switch ( $version.Server.Engine.OSArch ) {
        'windows/amd64' {
            $windowsVersion = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
            $image = [ordered] @{
                Repository = 'mcr.microsoft.com/windows/nanoserver'
                Tag = Get-WindowsContainerImageTag `
                    -ProductName $windowsVersion.ProductName `
                    -BuildNumber $windowsVersion.CurrentBuildNumber `
                    -ReleaseId $windowsVersion.ReleaseId
            }
            $image.Name = $image.Repository + ':' + $image.Tag
            @{
                Image = [PSCustomObject] $image
                PrintCommand = 'cmd /c echo'
                EnvironmentCommand = 'cmd.exe'
                EnvironmentArguments = @('/c', 'echo', '%A%')
                KeepAliveCommand = @('ping', '-t', '127.0.0.1')
                ReadFileCommand = 'cmd /c type'
                ContainerCommand = @('cmd.exe', '/c', 'echo', 'psdocker')
                PathSeparator = '\'
                MountPoint = 'C:\volume'
            } | Write-Output
        }
        'linux/amd64' {
            $image = [ordered] @{
                Repository = 'mcr.microsoft.com/powershell'
                Tag = 'latest'
            }
            $image.Name = $image.Repository + ':' + $image.Tag
            @{
                Image = [PSCustomObject] $image
                PrintCommand = 'echo'
                EnvironmentCommand = 'printenv'
                EnvironmentArguments = @('A')
                KeepAliveCommand = @('sleep', 'infinity')
                ReadFileCommand = 'cat'
                ContainerCommand = @('echo', 'psdocker')
                PathSeparator = '/'
                MountPoint = '/tmp/volume'
            } | Write-Output
        }
        default {
            Write-Error "Missing test for $($version.Server.Engine.OSArch)"
        }
    }
)
