#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Uninstall-DockerImage' {
    Context 'installed image' {
        BeforeAll {
            $global:TestConfig.Image | Install-DockerImage -ErrorAction Continue
        }

        It 'removes the image from pipeline' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository
            $tag = $global:TestConfig.Image.Tag

            # Act
            Get-DockerImage -Repository $repository -Tag $tag |
            Uninstall-DockerImage -Force

            # Assert
            Get-DockerImage -Repository $repository -Tag $tag |
            Should -BeNullOrEmpty
        }
    }
}
