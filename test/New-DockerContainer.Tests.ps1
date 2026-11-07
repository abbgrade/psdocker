#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'New-DockerContainer' {
    Context 'installed Image' {
        BeforeAll {
            $global:TestConfig.Image | Install-DockerImage
        }

        It 'does not throw' {
            $container = New-DockerContainer -Image $global:TestConfig.Image.Name -Environment @{"A" = 1; "B" = "C"}
            $container.Image | Should -Be $global:TestConfig.Image.Name

            $container | Remove-DockerContainer
        }

        It 'accepts Get-Image as parameter' {
            $container = Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag | New-DockerContainer
            $container.Image | Should -Be $global:TestConfig.Image.Name

            $container | Remove-DockerContainer
        }

        It 'supports a name, terminal, and command arguments' {
            $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
            $container = New-DockerContainer `
                -Image $global:TestConfig.Image.Name `
                -Name $name `
                -Terminal `
                -ArgumentList $global:TestConfig.ContainerCommand

            $container.Name | Should -Be $name
            $container | Remove-DockerContainer
        }

        It 'mounts a volume' {

            $testSharePath = Join-Path ( Get-Item 'TestDrive:\' ).FullName 'volume'
            New-Item -Path $testSharePath -ItemType Directory | Out-Null
            if ( $global:TestConfig.PathSeparator -eq '\' ) {
                $acl = Get-Acl $testSharePath
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
                Set-Acl -Path $testSharePath -AclObject $acl
            }
            $testText = 'lorem ipsum'
            Set-Content ( Join-Path $testSharePath 'test.txt' ) -Value $testText

            $containerFilePath = $global:TestConfig.MountPoint.TrimEnd([char[]]@('\', '/')) +
                $global:TestConfig.PathSeparator + 'test.txt'
            $container = Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag |
            New-DockerContainer -Volumes @{ $testSharePath = $global:TestConfig.MountPoint } -Detach -Interactive

            # test if new container returns one element
            ( @() + $container ).Count | Should -Be 1

            Invoke-DockerCommand -Name $container.Name `
                -Command $global:TestConfig.ReadFileCommand `
                -ArgumentList $containerFilePath `
                -StringOutput |
            Should -Be $testText

            Remove-DockerContainer -Name $container.Name -Force
        }

        It 'Removes with -Remove' {
            $previousCount = ( Get-DockerContainer ).Count
            New-DockerContainer -Image $global:TestConfig.Image.Name -Remove

            ( Get-DockerContainer ).Count | Should -Be $previousCount
        }
    }
}
