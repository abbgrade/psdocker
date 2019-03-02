
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Install-DockerImage' {

    It 'works with named parameters' {
        Install-DockerImage -Repository $testConfig.Image.Repository
    }

    It 'works with pipeline parameters' {
        Search-DockerRepository -Term $testConfig.Image.Repository -Limit 1 |
        Install-DockerImage
    }

    It 'works with name and tag' {
        Install-DockerImage -Repository $testConfig.Image.Repository -Tag $testConfig.Image.Tag
    }

    It 'throws on invalid image' {
        {
            Install-DockerImage -Repository 'foobar' -WarningAction SilentlyContinue -ErrorAction Stop
        } | Should Throw
    }
}
