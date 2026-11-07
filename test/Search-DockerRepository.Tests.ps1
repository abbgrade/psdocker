#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Search-DockerRepository' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'IntegrationTests' -Tag IntegrationTest {
        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
        }

        It 'returns a list of images' {
            # Arrange
            $term = 'Hello'

            # Act
            $images = Search-DockerRepository -Term $term -Limit $null -ErrorAction Stop

            # Assert
            $images.Count | Should -BeGreaterThan 0
            $images[0].Name | Should -Not -BeNullOrEmpty
        }
        It 'returns a limited list of images' {
            # Arrange
            $term = 'Hello'
            $limit = 5

            # Act
            $images = Search-DockerRepository -Term $term -Limit $limit -ErrorAction Stop

            # Assert
            $images.Count | Should -BeLessOrEqual $limit
            $images.Name | Should -Not -BeNullOrEmpty
        }
    }
}
