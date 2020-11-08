#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe 'Uninstall-DockerImage' {
    Context 'installed image' {
        BeforeAll {
            $testConfig.Image | Install-DockerImage
        }

        It 'removes the image from pipeline' {
            Get-DockerImage -Repository $testConfig.Image.Repository -Tag $testConfig.Image.Tag |
            Uninstall-DockerImage

            Get-DockerImage -Repository $testConfig.Image.Repository -Tag $testConfig.Image.Tag |
            Should -BeNullOrEmpty
        }
    }
}
