#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Remove-DockerContainer' {
    Context 'running container' {
        BeforeEach {
            $container = New-DockerContainer -Image $global:TestConfig.Image.Name
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
    Context 'two running containers' {
        BeforeEach {
            $container = @( 1, 2 ) | Foreach-Object {
                New-DockerContainer -Image $global:TestConfig.Image.Name
            }
        }

        It 'works with pipeline parameters' {
            # Act
            $container | Remove-DockerContainer

            # Assert
            foreach ( $item in $container ) {
                Get-DockerContainer -Name $item.Name |
                Should -BeNullOrEmpty
            }
        }
    }
}
