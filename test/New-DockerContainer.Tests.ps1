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
            # Arrange
            $image = $global:TestConfig.Image.Name
            $environment = @{ "A" = 1; "B" = "C" }

            # Act
            $container = New-DockerContainer -Image $image -Environment $environment

            # Assert
            $container.Image | Should -Be $global:TestConfig.Image.Name

            # Cleanup
            $container | Remove-DockerContainer
        }

        It 'accepts Get-Image as parameter' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository
            $tag = $global:TestConfig.Image.Tag

            # Act
            $container = Get-DockerImage -Repository $repository -Tag $tag | New-DockerContainer

            # Assert
            $container.Image | Should -Be $global:TestConfig.Image.Name

            # Cleanup
            $container | Remove-DockerContainer
        }

        It 'supports a name, terminal, and command arguments' {
            # Arrange
            $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"

            # Act
            $container = New-DockerContainer `
                -Image $global:TestConfig.Image.Name `
                -Name $name `
                -Terminal `
                -ArgumentList $global:TestConfig.ContainerCommand

            # Assert
            $container.Name | Should -Be $name

            # Cleanup
            $container | Remove-DockerContainer
        }

        It 'mounts a volume' {

            # Arrange
            $testSharePath = Join-Path ( Get-Item 'TestDrive:\' ).FullName 'volume'
            New-Item -Path $testSharePath -ItemType Directory | Out-Null
            if ( $global:TestConfig.PathSeparator -eq '\' ) {
                Grant-TestContainerReadAccess -Path $testSharePath
            }
            $testText = 'lorem ipsum'
            Set-Content ( Join-Path $testSharePath 'test.txt' ) -Value $testText

            $containerFilePath = $global:TestConfig.MountPoint.TrimEnd([char[]]@('\', '/')) +
                $global:TestConfig.PathSeparator + 'test.txt'

            # Act
            $container = Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag |
            New-DockerContainer -Volumes @{ $testSharePath = $global:TestConfig.MountPoint } -Detach -Interactive

            # Assert
            ( @() + $container ).Count | Should -Be 1

            # Act
            $fileContents = Invoke-DockerCommand -Name $container.Name `
                -Command $global:TestConfig.ReadFileCommand `
                -ArgumentList $containerFilePath `
                -StringOutput

            # Assert
            $fileContents | Should -Be $testText

            # Cleanup
            Remove-DockerContainer -Name $container.Name -Force
        }

        It 'Removes with -Remove' {
            # Arrange
            $previousCount = ( Get-DockerContainer ).Count

            # Act
            New-DockerContainer -Image $global:TestConfig.Image.Name -Remove

            # Assert
            ( Get-DockerContainer ).Count | Should -Be $previousCount
        }
    }
}
