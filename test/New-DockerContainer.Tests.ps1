#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\Helper\TestHelper.ps1
}

Describe 'New-DockerContainer' {
    Context 'installed Image' {
        BeforeAll {
            $global:TestConfig.Image | Install-DockerImage
        }

        It 'does not throw' {
            $container = New-DockerContainer -Image $global:TestConfig.Image.Name -Environment @{"A" = 1; "B" = "C"}
            $container.Image | Should -Be $global:TestConfig.Image.Name

            $container | Remove-DockerContainer
        }

        It 'accepts Get-Image as parameter' {
            $container = Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag | New-DockerContainer
            $container.Image | Should -Be $global:TestConfig.Image.Name

            $container | Remove-DockerContainer
        }

        It 'mounts a volume' {

            $testSharePath = ( Get-Item 'TestDrive:\' ).FullName
            $testText = 'lorem ipsum'
            Set-Content "$testSharePath\test.txt" -Value $testText

            $container = Get-DockerImage -Repository $global:TestConfig.Image.Repository -Tag $global:TestConfig.Image.Tag |
            New-DockerContainer -Volumes @{ $testSharePath = $global:TestConfig.MountPoint } -Detach -Interactive

            # test if new container returns one element
            ( @() + $container ).Count | Should -Be 1

            Invoke-DockerCommand -Name $container.Name -Command "$( $global:TestConfig.PowershellCommand ) `"Get-Content -Path '$( $global:TestConfig.MountPoint )/test.txt'`"" -StringOutput |
            Should -Be $testText

            Remove-DockerContainer -Name $container.Name -Force
        }

        It 'Removes with -Remove' {
            $previousCount = ( Get-DockerContainer ).Count
            New-DockerContainer -Image $global:TestConfig.Image.Name -Remove

            ( Get-DockerContainer ).Count | Should -Be $previousCount
        }
    }
}
