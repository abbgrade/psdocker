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

Describe 'Windows container image selection' {
    It 'uses the Windows Server 2025 image on build 26100' {
        Get-WindowsContainerImageTag `
            -ProductName 'Windows Server 2025 Datacenter' `
            -BuildNumber 26100 `
            -ReleaseId '2009' |
        Should -Be 'ltsc2025'
    }

    It 'preserves the release ID for Windows client editions' {
        Get-WindowsContainerImageTag `
            -ProductName 'Windows 11 Pro' `
            -BuildNumber 26100 `
            -ReleaseId '2009' |
        Should -Be '2009'
    }
}
