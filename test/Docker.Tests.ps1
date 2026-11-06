#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Docker Service' {
    It 'docker daemon is available and responding' {
        if ( -not $ENV:APPVEYOR ) {
            $version = Get-DockerVersion -ErrorAction Stop
            $version.Server | Should -Not -BeNullOrEmpty
            $version.Server.Version | Should -Not -BeNullOrEmpty
        }
    }
}
