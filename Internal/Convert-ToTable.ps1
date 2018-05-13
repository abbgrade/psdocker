function Convert-ToTable {

    param (
        [string] $Content
    )

    $rows = $Content.Split([Environment]::NewLine)

    # Extract schema
    $headerRow = $rows[0]
    $schema = New-Object System.Collections.ArrayList
    $offset = 0
    do {
        $index = $headerRow.IndexOf('  ')

        if ($index -gt 0) {
            $columnName = $headerRow.Substring(0, $index)
            $length = $headerRow.IndexOf($headerRow.Substring($index).Trim())
        } else {
            $columnName = $headerRow.Trim()
            $length = $null
        }

        $schema.Add(@{
            Name = $columnName.ToLower()
            Offset = $offset
            Length = $length
        }) | Out-Null
        $headerRow = $headerRow.Substring($length)
        $offset += $length
    } while ( $length )

    # Extract data
    foreach ( $row in $rows[1..$rows.Length] ) {
        if ( $row ) {
            $data = @{}
            foreach ( $column in $schema ) {
                if ( $column.Length ) {
                    $value = $row.Substring($column.Offset, $column.Length)
                } else {
                    $value = $row.Substring($column.Offset)
                }
                $data[$column.Name] = $value.Trim()
            }
            New-Object PSObject -Property $data
        }
    }
}