
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

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
