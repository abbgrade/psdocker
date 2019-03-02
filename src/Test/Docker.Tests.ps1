
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Docker Service' {
    It 'docker port is open / service is running' {
        if ( -not $ENV:APPVEYOR ) {
            $socket = New-Object Net.Sockets.TcpClient
            $socket.Connect( '127.0.0.1', 2375 )
            $socket.Connected | Should -Be $true
        }
    }
}
