function Get-Version {

    $output = ( Invoke-ClientCommand "version" -StringOutput ).Split([Environment]::NewLine)
    $dockerVersionTable = @{
        'Client' = @{}
        'Server' = @{}
    }

    $component = $null
    foreach ( $line in $output ) {
        switch ( $line ) {
            "" {}
            "Client:" { $component = 'Client' }
            "Server:" { $component = 'Server' }
            Default {
                if ( -not $component ) {
                    throw "unexpected response from 'docker version'"
                } else {
                    $key, $value = $line -Split ':  ' | ForEach-Object { $_.Trim() }
                    $componentVersionTable = $dockerVersionTable[$component]
                    $componentVersionTable.Add($key.Replace('/', '').Replace(' ', ''), $value)
                }
            }
        }
    }

    New-Object PSObject -Property @{
        Client = ( New-Object PSObject -Property $dockerVersionTable['Client'] )
        Server = ( New-Object PSObject -Property $dockerVersionTable['Server'] )
    }

}