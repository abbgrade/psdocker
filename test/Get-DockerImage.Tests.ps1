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
            $image = $global:TestConfig.Image
            if ( Get-DockerImage | Where-Object {
                $_.Repository -eq $image.Repository -and $_.Tag -eq $image.Tag
            } ) {
                Uninstall-DockerImage -Name $image.Name
            }
            Install-DockerImage -Repository $image.Repository -Tag $image.Tag -ErrorAction Stop
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
