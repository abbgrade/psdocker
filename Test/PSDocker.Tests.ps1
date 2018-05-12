
$ErrorActionPreference = "Stop"
$DebugPreference = "Continue"
$VerbosePreference = "Continue"

if ( $PSScriptRoot ) { $ScriptRoot = $PSScriptRoot } else { $ScriptRoot = Get-Location }
$ModuleManifestPath = "$ScriptRoot\..\PSDocker.psd1"
Import-Module "$ScriptRoot\..\PSDocker.psm1" -Force

Describe 'Module Manifest Tests' {

    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }

    It 'Test docker pull' {
        Install-DockerImage -Image 'kitematic/hello-world-nginx'
        { Install-DockerImage -Image 'foobar' } | Should Throw
    }
}

