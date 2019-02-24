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

$testConfig = New-Object -Type PsObject -Property $(
    switch ( ( Get-DockerVersion ).Server.OSArch ) {
        'windows/amd64' {
            @{
                Image = 'microsoft/nanoserver'
                Tag = 'latest'
                PrintCommand = 'powershell -c Write-Host'
                MountPoint = 'C:\volume'
            } | Write-Output
        }
        'linux/amd64' {
            @{
                Image = 'microsoft/powershell'
                Tag = 'latest'
                PrintCommand = 'echo'
                MountPoint = '/tmp/volume'
            } | Write-Output
        }
        default {
            Write-Error "Missing test for $_"
        }
    }
)

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
        Install-DockerImage -Name $testConfig.Image
    }
    It 'works with pipeline parameters' {
        Search-DockerRepository -Term $testConfig.Image -Limit 1 | Install-DockerImage
    }
    It 'works with name and tag' {
        Install-DockerImage -Name $testConfig.Image -Tag $testConfig.Tag
    }
    It 'throws on invalid image' {
        {
            Install-DockerImage -Name 'foobar' -WarningAction 'SilentlyContinue'
        } | Should Throw
    }
}

Describe 'Get-DockerImage' {

    BeforeAll {
        Uninstall-DockerImage -Name $testConfig.Image
        Install-DockerImage -Name $testConfig.Image
    }

    It 'returns a list of images' {
        Get-DockerImage |
        Where-Object Name -eq $testConfig.Image | Should -Be
    }

    It 'returns a specific image' {
        (
            Get-DockerImage -Repository $testConfig.Image -Tag $testConfig.Tag
        ).Repository | Should -Be $testConfig.Image
    }

    It 'returns the installed images from a search' {
        (
            Search-DockerRepository -Term $testConfig.Image -Limit 1 |
            Get-DockerImage |
            Select-Object 'Repository' |
            Select-Object -Unique
        ).Repository | Should -Be $testConfig.Image
    }
}

Describe 'Uninstall-DockerImage' {

    BeforeAll {
        Install-DockerImage -Name $testConfig.Image
    }

    It 'works with pipeline parameters' {
        Get-DockerImage -Repository $testConfig.Image -Tag $testConfig.Tag |
        Uninstall-DockerImage

        Get-DockerImage -Repository $testConfig.Image -Tag $testConfig.Tag |
        Should -BeNullOrEmpty
    }
}

#endregion
#region Container

Describe 'New-DockerContainer' {

    BeforeAll {
        Install-DockerImage -Name $testConfig.Image
    }

    It 'does not throw' {
        $container = New-DockerContainer -Image $testConfig.Image -Environment @{"A" = 1; "B" = "C"}
        $container.Image | Should -Be $testConfig.Image

        $container | Remove-DockerContainer
    }

    It 'accepts Get-Image as parameter' {
        $container = Get-DockerImage -Repository $testConfig.Image -Tag $testConfig.Tag |
        New-DockerContainer

        $container | Remove-DockerContainer
    }

    It 'mounts a volume' {

        $testSharePath = ( Get-Item 'TestDrive:\' ).FullName
        $testText = 'lorem ipsum'
        Set-Content "$testSharePath\test.txt" -Value $testText

        $container = Get-DockerImage -Repository $testConfig.Image -Tag $testConfig.Tag |
        New-DockerContainer -Volumes @{ $testSharePath = $testConfig.MountPoint } -Detach -Interactive

        Invoke-DockerCommand -Name $container.Name -Command "pwsh -c `"Get-Content -Path '$( $testConfig.MountPoint )/test.txt' | Write-Output`"" -StringOutput |
        Should -Be $testText
    }
}

Describe 'Remove-DockerContainer' {

    BeforeEach {
        $container = New-DockerContainer -Image $testConfig.Image
    }

    It 'does not throw' {
        Remove-DockerContainer -Name $container.Name
    }

    It 'works with pipeline parameters' {
        $container | Remove-DockerContainer
    }
}

Describe 'Get-DockerContainer' {
    It 'returns the correct number of containers' {
        $baseLineContainer = @(
            ( New-DockerContainer -Image $testConfig.Image ),
            ( New-DockerContainer -Image $testConfig.Image )
        )

        $previousCount = ( Get-DockerContainer ).Count

        $container = @(
            ( New-DockerContainer -Image $testConfig.Image ),
            ( New-DockerContainer -Image $testConfig.Image ),
            ( New-DockerContainer -Image $testConfig.Image ),
            ( New-DockerContainer -Image $testConfig.Image )
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
        if ( $container ) {
            Remove-DockerContainer -Name $container.Name -Force
        }
    }
}
