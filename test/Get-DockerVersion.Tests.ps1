#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Get-DockerVersion' -Tag IntegrationTest {

    BeforeAll {
        . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
    }
    It 'reports a server operating system and architecture' {
        # Arrange

        # Act
        $dockerVersion = Get-DockerVersion

        # Assert
        $dockerVersion.Server.Engine.OSArch | Should -Match '^(windows|linux)/.+'
    }
}
