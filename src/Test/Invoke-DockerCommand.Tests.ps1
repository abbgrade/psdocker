
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Invoke-DockerCommand' {
    Context 'running container' {
        BeforeAll {
            $testConfig.Image | Install-DockerImage

            $container = New-DockerContainer -Image $testConfig.Image.Name -Interactive -Detach
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
                -Command $testConfig.PrintCommand `
                -ArgumentList 'foobar' -StringOutput | Should -Be 'foobar'
        }
    }
}
