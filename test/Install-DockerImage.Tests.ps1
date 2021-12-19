#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Install-DockerImage' {

    It 'works with named parameters' {
        Install-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag -ErrorAction Stop
    }

    It 'works with pipeline parameters' {
        Search-DockerRepository -Term ( $global:TestConfig.Image.Repository -split '/', 2)[1] -Limit 1 -ErrorAction Stop |
        Install-DockerImage -ErrorAction Stop
    }

    It 'works with name and tag' {
        Install-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag -ErrorAction Stop
    }

    It 'throws on invalid image' {
        {
            Install-DockerImage -Repository 'foobar' -WarningAction SilentlyContinue -ErrorAction Stop
        } | Should -Throw
    }
}
