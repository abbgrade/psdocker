#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Install-DockerImage' {

    It 'works with named parameters' {
        # Arrange
        $repository = $global:TestConfig.Image.Repository
        $tag = $global:TestConfig.Image.Tag

        # Act
        $install = { Install-DockerImage -Repository $repository -Tag $tag -ErrorAction Stop }

        # Assert
        $install | Should -Not -Throw
    }

    It 'works with pipeline parameters' {
        # Arrange
        $image = $global:TestConfig.Image

        # Act
        $install = { $image | Install-DockerImage -ErrorAction Stop }

        # Assert
        $install | Should -Not -Throw
    }

    It 'works with name and tag' {
        # Arrange
        $repository = $global:TestConfig.Image.Repository
        $tag = $global:TestConfig.Image.Tag

        # Act
        $install = { Install-DockerImage -Repository $repository -Tag $tag -ErrorAction Stop }

        # Assert
        $install | Should -Not -Throw
    }

    It 'throws on invalid image' {
        # Arrange
        $repository = 'foobar'

        # Act
        $install = { Install-DockerImage -Repository $repository -WarningAction SilentlyContinue -ErrorAction Stop }

        # Assert
        $install | Should -Throw
    }
}
