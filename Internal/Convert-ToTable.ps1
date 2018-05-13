function Convert-ToTable {

    param (
        [string[]]
        $Content,

        [hashtable]
        $ColumnNames
    )

    $header = $Content[0]
    $lines = New-Object System.Collections.ArrayList
    foreach ( $line in $Content[1..$Content.Length]) {
        if ( $line ) {
            $lines.Add($line)
        }
    }

    # Extract schema
    $schema = New-Object System.Collections.ArrayList
    $offset = 0
    do {
        $index = $header.IndexOf('  ')

        if ($index -gt 0) {
            $columnName = $header.Substring(0, $index)
            $length = $header.IndexOf($header.Substring($index).Trim())
        } else {
            $columnName = $header.Trim()
            $length = $null
        }

        if ( $ColumnNames ) {
            if ( -not $ColumnNames.ContainsKey( $columnName ) ) {
                throw "Unexpected column '$columnName'"
            }
            $columnName = $ColumnNames[ $columnName ]
        }

        $schema.Add(@{
            Name = $columnName
            Offset = $offset
            Length = $length
        }) | Out-Null
        $header = $header.Substring($length)
        $offset += $length
    } while ( $length )

    # Extract data
    foreach ( $line in $lines ) {
        $row = @{}
        foreach ( $column in $schema ) {
            if ( $column.Length ) {
                $value = $line.Substring($column.Offset, $column.Length)
            } else {
                $value = $line.Substring($column.Offset)
            }
            $row[$column.Name] = $value.Trim()
        }
        New-Object PSObject -Property $row
    }
}