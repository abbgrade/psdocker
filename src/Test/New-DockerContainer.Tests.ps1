
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'New-DockerContainer' {
    Context 'installed Image' {
        BeforeAll {
            $testConfig.Image | Install-DockerImage
        }

        It 'does not throw' {
            $container = New-DockerContainer -Image $testConfig.Image.Name -Environment @{"A" = 1; "B" = "C"}
            $container.Image | Should -Be $testConfig.Image.Name

            $container | Remove-DockerContainer
        }

        It 'accepts Get-Image as parameter' {
            $container = Get-DockerImage -Repository $testConfig.Image.Repository -Tag $testConfig.Image.Tag | New-DockerContainer
            $container.Image | Should -Be $testConfig.Image.Name

            $container | Remove-DockerContainer
        }

        It 'mounts a volume' {

            $testSharePath = ( Get-Item 'TestDrive:\' ).FullName
            $testText = 'lorem ipsum'
            Set-Content "$testSharePath\test.txt" -Value $testText

            $container = Get-DockerImage -Repository $testConfig.Image.Repository -Tag $testConfig.Image.Tag |
            New-DockerContainer -Volumes @{ $testSharePath = $testConfig.MountPoint } -Detach -Interactive

            # test if new container returns one element
            ( @() + $container ).Count | Should -Be 1

            Invoke-DockerCommand -Name $container.Name -Command "$( $testConfig.PowershellCommand ) `"Get-Content -Path '$( $testConfig.MountPoint )/test.txt'`"" -StringOutput |
            Should -Be $testText

            Remove-DockerContainer -Name $container.Name -Force
        }
    }
}
