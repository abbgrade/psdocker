#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'New-DockerContainer' -Tag IntegrationTest {

    BeforeAll {
        . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
    }
    Context 'installed Image' {
        BeforeAll {
            $global:TestConfig.Image | Install-DockerImage
        }

        BeforeEach {
            $script:CreatedContainer = $null
            $script:CreatedContainerName = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
        }

        AfterEach {
            if ( Get-DockerContainer -Name $script:CreatedContainerName -ErrorAction SilentlyContinue ) {
                Remove-DockerContainer -Name $script:CreatedContainerName -Force -ErrorAction Continue
            }
        }

        It 'does not throw' {
            # Arrange
            $image = $global:TestConfig.Image.Name
            $environment = @{ "A" = 1; "B" = "C" }

            # Act
            $script:CreatedContainer = New-DockerContainer -Image $image -Name $script:CreatedContainerName `
                -Environment $environment -Detach -ArgumentList $global:TestConfig.KeepAliveCommand

            # Assert
            $script:CreatedContainer.Image | Should -Be $global:TestConfig.Image.Name
            $output = Invoke-DockerCommand -Name $script:CreatedContainer.Name `
                -Command $global:TestConfig.EnvironmentCommand `
                -ArgumentList $global:TestConfig.EnvironmentArguments `
                -StringOutput -ErrorAction Stop
            $output | Should -Be '1'
        }

        It 'accepts Get-Image as parameter' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository
            $tag = $global:TestConfig.Image.Tag

            # Act
            $script:CreatedContainer = Get-DockerImage -Repository $repository -Tag $tag |
            New-DockerContainer -Name $script:CreatedContainerName

            # Assert
            $script:CreatedContainer.Image | Should -Be $global:TestConfig.Image.Name
        }

        It 'supports a name, terminal, and command arguments' {
            # Arrange

            # Act
            $script:CreatedContainer = New-DockerContainer `
                -Image $global:TestConfig.Image.Name `
                -Name $script:CreatedContainerName `
                -Terminal `
                -ArgumentList $global:TestConfig.ContainerCommand

            # Assert
            $script:CreatedContainer.Name | Should -Be $script:CreatedContainerName
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
            $script:CreatedContainer = Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag |
            New-DockerContainer -Name $script:CreatedContainerName `
                -Volumes @{ $testSharePath = $global:TestConfig.MountPoint } -Detach -Interactive

            $fileContents = Invoke-DockerCommand -Name $script:CreatedContainer.Name `
                -Command $global:TestConfig.ReadFileCommand `
                -ArgumentList $containerFilePath `
                -StringOutput

            # Assert
            ( @() + $script:CreatedContainer ).Count | Should -Be 1
            $fileContents | Should -Be $testText
        }

        It 'does not return a container with -Remove' {
            # Arrange
            $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"

            # Act
            New-DockerContainer -Image $global:TestConfig.Image.Name -Name $name `
                -ArgumentList $global:TestConfig.ContainerCommand -Remove -ErrorAction Stop

            # Assert
            $containers = @( Get-DockerContainer -Name $name )
            $containers | Should -BeNullOrEmpty
        }
    }
}
