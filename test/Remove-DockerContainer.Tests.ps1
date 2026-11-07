#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Remove-DockerContainer' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'UnitTests' -Tag UnitTest {
        It 'does not stop or remove a container with WhatIf' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {}
                Mock Stop-Container {}

                # Act
                Remove-Container -Name 'example-container' -Force -WhatIf

                # Assert
                Should -Invoke Invoke-ClientCommand -Times 0 -Exactly
                Should -Invoke Stop-Container -Times 0 -Exactly
            }
        }
    }

    Context 'IntegrationTests' -Tag IntegrationTest {
        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
            $global:TestConfig.Image | Install-DockerImage -ErrorAction Stop
        }

        It 'works with named parameters' {
            # Arrange
            $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
            $container = $null

            try {
                $container = New-DockerContainer -Image $global:TestConfig.Image.Name -Name $name -ErrorAction Stop

                # Act
                Remove-DockerContainer -Name $name

                # Assert
                Get-DockerContainer -Name $name | Should -BeNullOrEmpty
            } finally {
                if ( $container -and ( Get-DockerContainer -Name $name -ErrorAction SilentlyContinue ) ) {
                    Remove-DockerContainer -Name $name -Force -ErrorAction Continue
                }
            }
        }

        It 'works with pipeline parameters' {
            # Arrange
            $containers = @()

            try {
                $containers = @( 1, 2 | ForEach-Object {
                    $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
                    New-DockerContainer -Image $global:TestConfig.Image.Name -Name $name -ErrorAction Stop
                } )

                # Act
                $containers | Remove-DockerContainer

                # Assert
                foreach ( $item in $containers ) {
                    Get-DockerContainer -Name $item.Name |
                    Should -BeNullOrEmpty
                }
            } finally {
                foreach ( $item in $containers ) {
                    if ( Get-DockerContainer -Name $item.Name -ErrorAction SilentlyContinue ) {
                        Remove-DockerContainer -Name $item.Name -Force -ErrorAction Continue
                    }
                }
            }
        }
    }
}
