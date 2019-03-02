
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'ModuleManifest' {
    It 'is valid' {
        Test-ModuleManifest -Path $ModuleManifestPath |
        Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}
