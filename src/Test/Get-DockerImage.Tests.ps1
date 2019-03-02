
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Get-DockerImage' {
    Context 'one image of a repository is installed' {
        BeforeAll {
            if ( Get-DockerImage | Where-Object Name -eq $testConfig.Image.Repository ) {
                Uninstall-DockerImage -Name $testConfig.Image.Repository
            }
            Install-DockerImage -Repository $testConfig.Image.Repository
        }

        It 'returns a list of images' {
            Get-DockerImage |
            Where-Object Name -eq $testConfig.Image.Repository | Should -Be
        }

        It 'returns a specific image' {
            (
                Get-DockerImage -Repository $testConfig.Image.Repository -Tag $testConfig.Image.Tag
            ).Repository | Should -Be $testConfig.Image.Repository
        }

        It 'returns the installed images from a search' {
            (
                Search-DockerRepository -Term $testConfig.Image.Repository -Limit 1 |
                Get-DockerImage |
                Select-Object 'Repository' |
                Select-Object -Unique
            ).Repository | Should -Be $testConfig.Image.Repository
        }
    }
}
