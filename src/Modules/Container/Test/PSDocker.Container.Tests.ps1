#Requires -Modules PSDocker.Client

$ErrorActionPreference = "Continue"
$DebugPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

if ( $PSScriptRoot ) { $ScriptRoot = $PSScriptRoot } else { $ScriptRoot = Get-Location }
$ModuleManifestPath = "$ScriptRoot\..\PSDocker.Container.psd1"
Import-Module "$ScriptRoot\..\..\Client\PSDocker.Client.psm1" -Prefix 'Docker' -Force
Import-Module "$ScriptRoot\..\PSDocker.Container.psm1" -Prefix 'Container' -Force

Describe 'Module Tests' {

    Context 'Module' {
        It 'ModuleManifest is valid' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }
    Context 'Container Cmdlets' {
        BeforeAll {
            try {
                $dockerArch = ( Get-DockerVersion ).Server.OSArch
                [string] $image = $null
                [string] $service = $null
                switch ( $dockerArch ) {
                    'windows/amd64' {
                        $image = 'microsoft/iis'
                        $service = 'W3SVC'
                    }
                    'linux/amd64' {
                        $image = 'microsoft/powershell'
                        $service = 'nginx'
                    }
                    default {
                        throw "missing test for $dockerArch"
                    }
                }

                # $container = New-DockerContainer -Image $image -Detach
                $container = New-DockerContainer -Image $image -Interactive -Detach
            } catch {
                Write-Error $_.Exception -ErrorAction 'Continue'
                throw
            }
        }
        It 'docker exec powershell' {
            $service = Get-ContainerService -ContainerName $container.Name -Name $service
            $service.Name | Should -Be 'W3SVC'
        }
        AfterAll {
            try {
                if ( $container ) {
                    Remove-DockerContainer -Name $container.Name -Force
                }
            } catch {
                Write-Error $_.Exception -ErrorAction 'Continue'
                throw
            }
        }
    }
}