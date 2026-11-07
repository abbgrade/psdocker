#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Stop-DockerContainer' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'UnitTests' -Tag UnitTest {
        It 'does not stop a container with WhatIf' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {}

                # Act
                Stop-Container -Name 'example-container' -WhatIf

                # Assert
                Should -Invoke Invoke-ClientCommand -Times 0 -Exactly
            }
        }
    }
}
