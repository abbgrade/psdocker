#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Invoke-DockerCommand' {
    Context 'running container' {
        BeforeAll {
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
            $command = { Invoke-DockerCommand -Name $name -Command 'hostname' }

            # Assert
            $command | Should -Not -Throw
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
