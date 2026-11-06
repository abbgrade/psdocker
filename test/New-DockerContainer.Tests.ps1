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

            $testSharePath = ( Get-Item 'TestDrive:\' ).FullName
            $testText = 'lorem ipsum'
            Set-Content "$testSharePath\test.txt" -Value $testText

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
