
$ErrorActionPreference = "Continue"
$DebugPreference = "SilentlyContinue"
# $DebugPreference = "Continue"
$VerbosePreference = "SilentlyContinue"
# $VerbosePreference = "Continue"

if ( $PSScriptRoot ) { $ScriptRoot = $PSScriptRoot } else { $ScriptRoot = Get-Location }
$ModuleManifestPath = "$ScriptRoot\..\PSDocker.psd1"
Import-Module "$ScriptRoot\..\PSDocker.psm1" -Prefix 'Docker' -Force

Describe 'Module Tests' {

    Context 'Module' {
        It 'ModuleManifest is valid' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }
    Context "Docker Service" {
        It "Docker service is running" {
            $dockerService = @() +
                ( Get-Service | Where-Object Name -eq "Docker" ) +
                ( Get-Process | Where-Object Name -eq "Docker for Windows" )

            $dockerService | Should -Not -BeNullOrEmpty # Docker is not running
            if ( $dockerService.Status ) {
                $dockerService.Status | Should -Be "Running"
            }
        }
        It "Linux or Windows mode" {
            $dockerVersion = Get-DockerVersion
            $dockerVersion.Server.OSArch | Should -BeIn @( "windows/amd64", "linux/amd64" )
        }
    }
    Context 'Lifecycle Cmdlets' {

        BeforeAll {
            $image = 'hello-world:latest'
        }
        It 'docker pull works' {
            Install-DockerImage -Image $image
        }
        It 'docker pull throws on invalid image' {
            {
                Install-DockerImage -Image 'foobar'
            } | Should Throw
        }
        It 'docker ps returns the correct number of containers' {
            $baseLineContainer = @(
                ( New-DockerContainer -Image $image ),
                ( New-DockerContainer -Image $image )
            )

            $previousCount = ( Get-DockerContainer ).Count

            $container = @(
                ( New-DockerContainer -Image $image ),
                ( New-DockerContainer -Image $image ),
                ( New-DockerContainer -Image $image ),
                ( New-DockerContainer -Image $image )
            )


            $afterCount = ( Get-DockerContainer ).Count

            $afterCount | Should -Be $( $previousCount + 4 )

            ( $baseLineContainer + $container ) | ForEach-Object {
                Remove-DockerContainer -Name $_.Name
            }
        }
        It 'docker run throws without image' {
            {
                New-DockerContainer
            } | Should -Throw
        }
        It 'docker run works' {
            $container = New-DockerContainer -Image $image -Environment @{"A" = 1; "B" = "C"}
            $container.Image | Should -Be $image

            Remove-DockerContainer -Name $container.Name
        }
        It 'docker remove works' {
            $container = New-DockerContainer -Image $image

            Remove-DockerContainer -Name $container.Name
        }
    }
    Context 'Container Cmdlets' {
        BeforeAll {
            try {
                $dockerArch = ( Get-DockerVersion ).Server.OSArch
                [string] $image = $null
                [string] $service = $null
                [string] $powershell = $null
                switch ( $dockerArch ) {
                    'windows/amd64' {
                        $image = 'microsoft/iis'
                        $service = 'W3SVC'
                        $powershell = 'powershell'
                    }
                    'linux/amd64' {
                        $image = 'microsoft/powershell'
                        $service = 'nginx'
                        $powershell = 'pwsh'
                    }
                    default {
                        throw "missing test for $dockerArch"
                    }
                }

                # $container = New-DockerContainer -Image $image -Detach
                $container = New-DockerContainer -Image $image -Interactive -Detach -Verbose
            } catch {
                Write-Error $_.Exception -ErrorAction 'Continue'
                throw
            }
        }
        It 'docker exec does not throw' {
            { Invoke-DockerContainerCommand -Name $container.Name 'hostname' } | Should -Not -Throw
        }
        It 'docker exec returns a valid output' {
            Invoke-DockerContainerCommand -Name $container.Name -Command $powershell -Arguments '-c "Write-Host foobar"' -StringOutput | Should -Be 'foobar'
        }
        It 'docker exec powershell' {
            $service = Get-DockerService -ContainerName $container.Name # -Name $service
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