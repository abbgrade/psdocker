foreach ( $folder in @('Internal', 'Public') ) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if (Test-Path -Path $folderPath) {
        Write-Verbose "Importing from $folder"
        foreach ( $function in Get-ChildItem -Path $folderPath -Filter '*.ps1' ) {
            Write-Verbose "  Importing $( $function.BaseName )"
            . $function.FullName

            switch ( $folder ) {
                Public {
                    if ( ( Get-Command -Module $null | Where-Object { $_.Name -eq $function.BaseName } ) ) {
                        Export-ModuleMember -Function $function.BaseName
                    }
                }
            }
        }
    }
}
