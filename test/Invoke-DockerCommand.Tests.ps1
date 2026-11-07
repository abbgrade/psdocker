#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Invoke-DockerCommand' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'UnitTests' -Tag UnitTest {

        It 'does not run a command in a container with WhatIf' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {}

                # Act
                Invoke-Command -Name 'example-container' -Command 'hostname' -WhatIf

                # Assert
                Should -Invoke Invoke-ClientCommand -Times 0 -Exactly
            }
        }
    }

    Context 'IntegrationTests' -Tag IntegrationTest {

        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
            $global:TestConfig.Image | Install-DockerImage

            $script:Container = New-DockerContainer -Image $global:TestConfig.Image.Name -Interactive -Detach
        }

        AfterAll {
            Remove-DockerContainer -Name $script:Container.Name -Force
        }

        It 'does not throw' {
            # Arrange
            $name = $script:Container.Name

            # Act
            $output = Invoke-DockerCommand -Name $name -Command 'hostname' -StringOutput -ErrorAction Stop

            # Assert
            $output | Should -Not -BeNullOrEmpty
        }

        It 'returns string output' {
            # Arrange
            $name = $script:Container.Name
            $argument = 'foobar'

            # Act
            $output = Invoke-DockerCommand -Name $name `
                -Command $global:TestConfig.PrintCommand `
                -ArgumentList $argument -StringOutput

            # Assert
            $output | Should -Be $argument
        }
    }
}
