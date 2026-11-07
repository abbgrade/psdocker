#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\UnitTestSetup.ps1
}

Describe 'ModuleManifest' -Tag UnitTest {
    It 'is valid' {
        # Arrange
        $manifestPath = $ModuleManifestPath

        # Act
        $manifest = Test-ModuleManifest -Path $manifestPath

        # Assert
        $manifest | Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}

Describe 'Windows container image selection' -Tag UnitTest {
    It 'uses the Windows Server 2025 image on build 26100' {
        # Arrange
        $productName = 'Windows Server 2025 Datacenter'
        $buildNumber = 26100
        $releaseId = '2009'

        # Act
        $tag = Get-WindowsContainerImageTag `
            -ProductName $productName `
            -BuildNumber $buildNumber `
            -ReleaseId $releaseId

        # Assert
        $tag | Should -Be 'ltsc2025'
    }

    It 'preserves the release ID for Windows client editions' {
        # Arrange
        $productName = 'Windows 11 Pro'
        $buildNumber = 26100
        $releaseId = '2009'

        # Act
        $tag = Get-WindowsContainerImageTag `
            -ProductName $productName `
            -BuildNumber $buildNumber `
            -ReleaseId $releaseId

        # Assert
        $tag | Should -Be $releaseId
    }
}
