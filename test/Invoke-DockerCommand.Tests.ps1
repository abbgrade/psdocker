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
            {
                Invoke-DockerCommand -Name $script:Container.Name -Command 'hostname'
            } | Should -Not -Throw
        }

        It 'returns string output' {
            Invoke-DockerCommand -Name $script:Container.Name `
                -Command $global:TestConfig.PrintCommand `
                -ArgumentList 'foobar' -StringOutput | Should -Be 'foobar'
        }
    }
}
