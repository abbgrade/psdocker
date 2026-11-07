#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Remove-DockerContainer' -Tag IntegrationTest {

    BeforeAll {
        . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
    }
    Context 'container created for the test' {
        BeforeEach {
            $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
            $container = New-DockerContainer -Image $global:TestConfig.Image.Name -Name $name -ErrorAction Stop
        }

        AfterEach {
            if ( $container ) {
                Remove-DockerContainer -Name $container.Name -Force -ErrorAction Continue
            }
        }

        It 'works with named parameters' {
            # Arrange
            $name = $container.Name

            # Act
            Remove-DockerContainer -Name $name

            # Assert
            Get-DockerContainer -Name $name | Should -BeNullOrEmpty
        }
    }
    Context 'two containers created for the test' {
        BeforeEach {
            $container = @( 1, 2 ) | Foreach-Object {
                $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
                New-DockerContainer -Image $global:TestConfig.Image.Name -Name $name -ErrorAction Stop
            }
        }

        AfterEach {
            foreach ( $item in $container ) {
                Remove-DockerContainer -Name $item.Name -Force -ErrorAction Continue
            }
        }

        It 'works with pipeline parameters' {
            # Arrange
            $containers = $container

            # Act
            $containers | Remove-DockerContainer

            # Assert
            foreach ( $item in $containers ) {
                Get-DockerContainer -Name $item.Name |
                Should -BeNullOrEmpty
            }
        }
    }
}
