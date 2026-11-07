
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

function Grant-TestContainerReadAccess {
    param (
        [Parameter(Mandatory)][string] $Path
    )

    $acl = Get-Acl $Path
    $worldSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-1-0')
    $readRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
        $worldSid,
        [System.Security.AccessControl.FileSystemRights]::ReadAndExecute,
        [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
            [System.Security.AccessControl.InheritanceFlags]::ObjectInherit,
        [System.Security.AccessControl.PropagationFlags]::None,
        [System.Security.AccessControl.AccessControlType]::Allow
    )
    $acl.SetAccessRule($readRule)
    Set-Acl -Path $Path -AclObject $acl
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
                ContainerCommand = @('cmd.exe', '/c', 'echo', 'psdocker')
                PathSeparator = '\'
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
                ContainerCommand = @('echo', 'psdocker')
                PathSeparator = '/'
                MountPoint = '/tmp/volume'
            } | Write-Output
        }
        default {
            Write-Error "Missing test for $_"
        }
    }
)
