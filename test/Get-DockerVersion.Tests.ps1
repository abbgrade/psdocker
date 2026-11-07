#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Get-DockerVersion' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'IntegrationTests' -Tag IntegrationTest {
        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
        }

        It 'reports a server operating system and architecture' {
            # Arrange

            # Act
            $dockerVersion = Get-DockerVersion -ErrorAction Stop

            # Assert
            $dockerVersion.Server | Should -Not -BeNullOrEmpty
            $dockerVersion.Server.Version | Should -Not -BeNullOrEmpty
            $dockerVersion.Server.Engine.OSArch | Should -Match '^(windows|linux)/.+'
        }
    }
}
