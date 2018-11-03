function Search-Image {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Term,

        [Parameter(Mandatory=$false)]
        [int]
        $TimeoutMS = 30 * 1000
    )

    Invoke-ClientCommand 'search', $Term -TimeoutMS $TimeoutMS -TableOutput -ColumnNames @{
        'NAME' = 'Name'
        'DESCRIPTION' = 'Description'
        'STARS' = 'Stars'
        'OFFICIAL' = 'IsOfficial'
        'AUTOMATED' = 'IsAutomated'
    } | Foreach-Object {
        New-Object -Type PsObject -Property @{
            Name = $_.Name
            Description = $_.Description
            Stars = [int] $_.Stars
            IsOfficial = switch($_.IsOfficial) { '[OK]' { $true } default { $false }}
            IsAutomated = switch($_.IsAutomated) { '[OK]' { $true } default { $false }}
        }
    }

}