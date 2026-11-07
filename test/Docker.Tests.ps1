#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)


Describe 'Docker Service' -Tag IntegrationTest {
    BeforeAll {
        . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
    }
    It 'docker daemon is available and responding' {
        # Arrange
        if ( -not $ENV:APPVEYOR ) {
            # Act
            $version = Get-DockerVersion -ErrorAction Stop

            # Assert
            $version.Server | Should -Not -BeNullOrEmpty
            $version.Server.Version | Should -Not -BeNullOrEmpty
        }
    }
}
