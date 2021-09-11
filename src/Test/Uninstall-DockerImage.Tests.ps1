#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Uninstall-DockerImage' {
    Context 'installed image' {
        BeforeAll {
            $global:TestConfig.Image | Install-DockerImage
        }

        It 'removes the image from pipeline' {
            Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag |
            Uninstall-DockerImage

            Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag |
            Should -BeNullOrEmpty
        }
    }
}
