#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'New-DockerImage' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'UnitTests' -Tag UnitTest {
        It 'does not build an image with WhatIf' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {}

                # Act
                New-Image -Repository 'example/app' -WhatIf

                # Assert
                Should -Invoke Invoke-ClientCommand -Times 0 -Exactly
            }
        }
    }
}
