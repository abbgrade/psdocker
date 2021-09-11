#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'Get-DockerVersion' {
    It 'is Linux or Windows mode' {
        $dockerVersion = Get-DockerVersion
        $dockerVersion.Server.Engine.OSArch |
        Should -BeIn @( 'windows/amd64', 'linux/amd64' )
    }
}
