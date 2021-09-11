#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Get-DockerImage' {
    Context 'one image of a repository is installed' {
        BeforeAll {
            if ( Get-DockerImage | Where-Object Name -eq $global:TestConfig.Image.Repository ) {
                Uninstall-DockerImage -Name $global:TestConfig.Image.Repository
            }
            Install-DockerImage -Repository $global:TestConfig.Image.Repository
        }

        It 'returns a list of images' {
            Get-DockerImage |
            Where-Object Name -eq $global:TestConfig.Image.Repository | Should -Be
        }

        It 'returns a specific image' {
            (
                Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag
            ).Repository | Should -Be $global:TestConfig.Image.Repository
        }
    }
}
