#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe 'Get-DockerContainer' {
    Context 'there are some containers' {
        BeforeAll {
            $testConfig.Image | Install-DockerImage

            $container = New-Object System.Collections.ArrayList
            $container.Add(( New-DockerContainer -Image $testConfig.Image.Name )) | Out-Null
            $container.Add(( New-DockerContainer -Image $testConfig.Image.Name )) | Out-Null
        }

        AfterAll {
            @() + $container | Remove-DockerContainer
        }

        It 'returns the correct number of containers' {

            $previousCount = ( Get-DockerContainer ).Count

            $container.Add(( New-DockerContainer -Image $testConfig.Image.Name )) | Out-Null
            $container.Add(( New-DockerContainer -Image $testConfig.Image.Name )) | Out-Null
            $container.Add(( New-DockerContainer -Image $testConfig.Image.Name )) | Out-Null
            $container.Add(( New-DockerContainer -Image $testConfig.Image.Name )) | Out-Null

            ( Get-DockerContainer ).Count |
            Should -Be $( $previousCount + 4 )
        }
    }
}
