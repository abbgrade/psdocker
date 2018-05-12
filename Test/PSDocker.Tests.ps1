
$ErrorActionPreference = "Stop"
$DebugPreference = "Continue"
$VerbosePreference = "Continue"

if ( $PSScriptRoot ) { $ScriptRoot = $PSScriptRoot } else { $ScriptRoot = Get-Location }
$ModuleManifestPath = "$ScriptRoot\..\PSDocker.psd1"
Import-Module "$ScriptRoot\..\PSDocker.psm1" -Prefix 'Docker' -Force

Describe 'Module Tests' {

    Context 'Module' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
            $? | Should Be $true
        }
    }
    Context "Docker Service" {
        It "is running" {
            $dockerService = Get-Service | Where-Object Name -eq "Docker"
            $dockerService | Should -Not -BeNullOrEmpty # Docker is not running
            $dockerService.Status | Should -Be "Running"
        }
    }
    Context 'Cmdlets' {
        It 'Test docker pull' {
            Install-DockerImage -Image 'kitematic/hello-world-nginx'
            try {
                Install-DockerImage -Image 'foobar'
                Should Throw
            } catch {}
        }
    }
}

