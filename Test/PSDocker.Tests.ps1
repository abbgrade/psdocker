#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'ModuleManifest' {
    It 'is valid' {
        Test-ModuleManifest -Path $ModuleManifestPath |
        Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}
