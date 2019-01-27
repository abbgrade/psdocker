# general test setup
if ( $PSScriptRoot ) { $ScriptRoot = $PSScriptRoot } else { $ScriptRoot = Get-Location }
$ModuleManifestPath = "$ScriptRoot\..\PSDocker.psd1"
Import-Module "$ScriptRoot\..\PSDocker.psd1" -Force

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
    Context "Repository Cmdlets" {
        It 'docker search works' {
            $images = Search-DockerImage -Term 'Hello' -Limit $null
            $images.Count | Should -BeGreaterThan 0

            ( Search-DockerImage -Term 'Hello' -Limit 5 ).Count | Should -BeLessOrEqual 5
        }
    }
    Context 'Lifecycle Cmdlets' {

        BeforeAll {
            $imageName = 'hello-world'
        }
        It 'docker pull works' {
            Install-DockerImage -Name $imageName
        }
        It 'docker pull throws on invalid image' {
            {
                Install-DockerImage -Name 'foobar' -WarningAction 'SilentlyContinue'
            } | Should Throw
        }
        It 'docker image ls works' {
            Install-DockerImage -Name $imageName

            Get-DockerImage | Where-Object Name -eq $imageName | Should -Be
            ( Get-DockerImage -Repository $imageName ).Repository | Should -Be $imageName
        }
        It 'docker ps works' {
            $baseLineContainer = @(
                ( New-DockerContainer -Image $imageName ),
                ( New-DockerContainer -Image $imageName )
            )

            $previousCount = ( Get-DockerContainer ).Count

            $container = @(
                ( New-DockerContainer -Image $imageName ),
                ( New-DockerContainer -Image $imageName ),
                ( New-DockerContainer -Image $imageName ),
                ( New-DockerContainer -Image $imageName )
            )

            $afterCount = ( Get-DockerContainer ).Count

            $afterCount | Should -Be $( $previousCount + 4 )

            ( $baseLineContainer + $container ) | ForEach-Object {
                Remove-DockerContainer -Name $_.Name
            }
        }
        It 'docker run works' {
            $container = New-DockerContainer -Image $imageName -Environment @{"A" = 1; "B" = "C"}
            $container.Image | Should -Be $imageName

            Remove-DockerContainer -Name $container.Name
        }
        It 'docker remove works' {
            $container = New-DockerContainer -Image $imageName

            Remove-DockerContainer -Name $container.Name
        }
    }
    Context 'Container Commands' {
        BeforeAll {
            try {
                $testConfig = New-Object -Type PsObject -Property $(
                    switch ( ( Get-DockerVersion ).Server.OSArch ) {
                        'windows/amd64' {
                            @{
                                Image = 'microsoft/nanoserver'
                                PrintCommand = 'powershell -c Write-Host'
                            } | Write-Output
                        }
                        'linux/amd64' {
                            @{
                                Image = 'microsoft/powershell'
                                PrintCommand = 'echo'
                            } | Write-Output
                        }
                        default {
                            Write-Error "Missing test for $_"
                        }
                    }
                )

                if ( -not ( Get-DockerImage -Repository $testConfig.Image )) {
                    Install-DockerImage -Name $testConfig.Image -Timeout ( 10 * 60)
                }

                $container = New-DockerContainer -Image $testConfig.Image -Interactive -Detach
            } catch {
                Write-Error $_.Exception -ErrorAction 'Continue'
                throw
            }
        }
        It 'docker exec does not throw' {
            Invoke-DockerCommand -Name $container.Name -Command 'hostname'
        }
        It 'docker exec works' {
            Invoke-DockerCommand -Name $container.Name `
                -Command $testConfig.PrintCommand `
                -ArgumentList 'foobar' -StringOutput | Should -Be 'foobar'
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