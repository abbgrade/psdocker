#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe 'Remove-DockerContainer' {
    Context 'running container' {
        BeforeEach {
            $container = New-DockerContainer -Image $testConfig.Image.Name
        }

        It 'works with named parameters' {
            Remove-DockerContainer -Name $container.Name
        }
    }
    Context 'two running containers' {
        BeforeEach {
            $container = @( 1, 2 ) | Foreach-Object {
                New-DockerContainer -Image $testConfig.Image.Name
            }
        }

        It 'works with pipeline parameters' {
            $container | Remove-DockerContainer

            foreach ( $item in $container ) {
                Get-DockerContainer -Name $item.Name |
                Should -BeNullOrEmpty
            }
        }
    }
}
