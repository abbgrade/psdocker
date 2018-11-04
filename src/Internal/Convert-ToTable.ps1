function Convert-ToTable {

    <#

    .SYNOPSIS Converts the output of the docker client to a table of PsObjects

    .PARAMETER Content
    Specifies the lines, returned from the docker client.

    .PARAMETER Columns
    Specifies the column name of the source and the property name in the result.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Content,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $Columns
    )

    $header = $Content[0]
    $lines = New-Object System.Collections.ArrayList
    foreach ( $line in $Content[1..$Content.Length]) {
        if ( $line ) {
            $lines.Add($line) | Out-Null
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

        if ( $Columns ) {
            if ( -not $Columns.ContainsKey( $columnName ) ) {
                throw "Unexpected column '$columnName'"
            }
            $columnName = $Columns[ $columnName ]
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