function Invoke-Command {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Command,

        [Parameter(Mandatory=$false)]
        [string[]]
        $ArgumentList,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 30,

        [Parameter(Mandatory=$false)]
        [switch]
        $StringOutput
    )

    [string[]] $arguments = @( 'exec', $Name, $Command ) + $( if ( $ArgumentList ) { $ArgumentList } )

    Invoke-ClientCommand `
        -ArgumentList $arguments `
        -StringOutput:$StringOutput `
        -Timeout $Timeout

    Write-Verbose "Command on Docker container executed."
}