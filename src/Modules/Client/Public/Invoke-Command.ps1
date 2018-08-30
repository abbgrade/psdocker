function Invoke-Command {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [ValidateNotNullOrEmpty()]
        [string]
        $Command,

        [string[]]
        $Arguments,

        [int]
        $TimeoutMS = $null,

        [switch]
        $StringOutput
    )

    $container = Get-Container -Name $Name
    Write-Verbose "Container status is '$( $container.Status )'."

    Invoke-ClientCommand `
        -ArgumentList ( @( 'exec', $Name, $Command ) + $Arguments ) `
        -StringOutput:$StringOutput `
        -TimeoutMS $TimeoutMS
    Write-Verbose "Command on Docker container executed."
}