#Requires -Modules Pester

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } ),
    [string] $ModuleManifestPath = "$PSScriptRoot\..\PSDocker.psd1"
)

Describe 'ModuleManifest' {
    It 'is valid' {
        Test-ModuleManifest -Path $ModuleManifestPath |
        Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}

Import-Module "$PSScriptRoot\..\PSDocker.psd1" -Force

#region Host system

Describe 'Docker Service' {
    It 'is running' {
        Get-Process |
        Where-Object Name -eq 'Docker for Windows' |
        Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-DockerVersion' {
    It 'is Linux or Windows mode' {
        $dockerVersion = Get-DockerVersion
        $dockerVersion.Server.OSArch |
        Should -BeIn @( 'windows/amd64', 'linux/amd64' )
    }
}

#endregion

$imageName = 'hello-world'

#region Image

Describe 'Search-DockerRepository' {
    It 'returns a list of images' {
        $images = Search-DockerRepository -Term 'Hello' -Limit $null
        $images.Count | Should -BeGreaterThan 0
    }
    It 'returns a limited list of images' {
        $images = Search-DockerRepository -Term 'Hello' -Limit 5
        $images.Count | Should -BeLessOrEqual 5
    }
}

Describe 'Install-DockerImage' {

    It 'works with named parameters' {
        Install-DockerImage -Name $imageName
    }
    It 'works with pipeline parameters' {
        Search-DockerRepository -Term $imageName -Limit 1 -IsOfficial | Install-DockerImage
    }
    It 'throws on invalid image' {
        {
            Install-DockerImage -Name 'foobar' -WarningAction 'SilentlyContinue'
        } | Should Throw
    }
}

Describe 'Get-DockerImage' {

    BeforeAll {
        Install-DockerImage -Name $imageName
    }

    It 'returns a list of images' {
        Get-DockerImage |
        Where-Object Name -eq $imageName | Should -Be
    }

    It 'returns a specific image' {
        (
            Get-DockerImage -Repository $imageName
        ).Repository | Should -Be $imageName
    }
}

#endregion
#region Container

Describe 'New-DockerContainer' {
    It 'does not throw' {
        $container = New-DockerContainer -Image $imageName -Environment @{"A" = 1; "B" = "C"}
        $container.Image | Should -Be $imageName

        Remove-DockerContainer -Name $container.Name
    }
}

Describe 'Remove-DockerContainer' {
    It 'does not throw' {
        $container = New-DockerContainer -Image $imageName

        Remove-DockerContainer -Name $container.Name
    }
}

Describe 'Get-DockerContainer' {
    It 'returns the correct number of containers' {
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
}

#endregion

Describe 'Invoke-DockerCommand' {
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
    It 'does not throw' {
        {
            Invoke-DockerCommand -Name $container.Name -Command 'hostname'
        } | Should -Not -Throw
    }
    It 'returns string output' {
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
