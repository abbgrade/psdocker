
$ErrorActionPreference = "Continue"
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

        BeforeAll {
            $image = 'microsoft/nanoserver'
        }

        It 'docker pull' {
            Install-DockerImage -Image $image
            {
                Install-DockerImage -Image 'foobar'
            } | Should Throw
        }
        It 'docker ps' {
            $container = Get-DockerContainer
            $container.Length
        }
        It 'docker run' {
            {
                New-DockerContainer
            } | Should Throw

            New-DockerContainer -Image $image -Environment @{"A" = 1; "B" = "C"} | Should Be
        }
        It 'docker remove' {
            $containerName = 'testcontainer'
            try {
                New-DockerContainer -Image $image -Name $containerName
            } catch {}
            Remove-DockerContainer -Name $containerName
        }
    }
}

