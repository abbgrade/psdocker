#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Get-DockerImage' {
    Context 'one image of a repository is installed' {
        BeforeAll {
            if ( Get-DockerImage | Where-Object Repository -eq $global:TestConfig.Image.Repository ) {
                Uninstall-DockerImage -Name $global:TestConfig.Image.Repository
            }
            Install-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag -ErrorAction Stop
        }

        It 'returns a list of images' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository

            # Act
            $images = Get-DockerImage -ErrorAction Stop |
                Where-Object Repository -eq $repository

            # Assert
            $images.Repository | Should -Contain $repository
        }

        It 'returns a specific image' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository
            $tag = $global:TestConfig.Image.Tag

            # Act
            $image = Get-DockerImage -Repository $repository -Tag $tag -ErrorAction Stop

            # Assert
            $image.Repository | Should -Be $repository
        }
    }
}
