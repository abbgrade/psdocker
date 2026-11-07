#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Search-DockerRepository' {
    It 'returns a list of images' {
        # Arrange
        $term = 'Hello'

        # Act
        $images = Search-DockerRepository -Term $term -Limit $null -ErrorAction Stop

        # Assert
        $images.Count | Should -BeGreaterThan 0
    }
    It 'returns a limited list of images' {
        # Arrange
        $term = 'Hello'
        $limit = 5

        # Act
        $images = Search-DockerRepository -Term $term -Limit $limit -ErrorAction Stop

        # Assert
        $images.Count | Should -BeLessOrEqual $limit
    }
}
