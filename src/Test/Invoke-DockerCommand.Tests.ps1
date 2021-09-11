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

            $container = New-DockerContainer -Image $global:TestConfig.Image.Name -Interactive -Detach
        }

        AfterAll {
            Remove-DockerContainer -Name $container.Name -Force
        }

        It 'does not throw' {
            {
                Invoke-DockerCommand -Name $container.Name -Command 'hostname'
            } | Should -Not -Throw
        }

        It 'returns string output' {
            Invoke-DockerCommand -Name $container.Name `
                -Command $global:TestConfig.PrintCommand `
                -ArgumentList 'foobar' -StringOutput | Should -Be 'foobar'
        }
    }
}
