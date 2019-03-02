
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Get-DockerVersion' {
    It 'is Linux or Windows mode' {
        $dockerVersion = Get-DockerVersion
        $dockerVersion.Server.OSArch |
        Should -BeIn @( 'windows/amd64', 'linux/amd64' )
    }
}
