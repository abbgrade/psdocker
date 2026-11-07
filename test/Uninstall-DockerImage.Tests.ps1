#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Uninstall-DockerImage' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'UnitTests' -Tag UnitTest {
        It 'does not remove an image with WhatIf' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {}

                # Act
                Uninstall-Image -Name 'example/app' -WhatIf

                # Assert
                Should -Invoke Invoke-ClientCommand -Times 0 -Exactly
            }
        }
    }

    Context 'IntegrationTests' -Tag IntegrationTest {
        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
        }

        It 'removes a test-owned image without removing the configured base image' {
            # Arrange
            $repository = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
            $buildContext = Join-Path ( Get-Item 'TestDrive:\' ).FullName $repository
            New-Item -Path $buildContext -ItemType Directory | Out-Null
            Set-Content -Path ( Join-Path $buildContext 'Dockerfile' ) `
                -Value "FROM $($global:TestConfig.Image.Name)"

            try {
                # Act
                New-DockerImage -Repository $repository -Path $buildContext -ErrorAction Stop
                Uninstall-DockerImage -Name $repository -Force -ErrorAction Stop

                # Assert
                Get-DockerImage -Repository $repository -Tag 'latest' |
                Should -BeNullOrEmpty
            }
            finally {
                if ( Get-DockerImage -Repository $repository -Tag 'latest' -ErrorAction SilentlyContinue ) {
                    Uninstall-DockerImage -Name $repository -Force -ErrorAction Continue
                }
            }
        }
    }
}
