
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Docker Service' {
    It 'docker port is open / service is running' {
        if ( -not $ENV:APPVEYOR ) {
            Get-Process -Name com.docker.service | Should -Not -BeNullOrEmpty
        }
    }
}
