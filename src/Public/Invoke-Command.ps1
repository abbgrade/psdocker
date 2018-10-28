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
        $TimeoutMS = 30 * 1000,

        [Parameter(Mandatory=$false)]
        [switch]
        $StringOutput
    )

    # $container = Get-Container -Name $Name -TimeoutMS $TimeoutMS
    # Write-Verbose "Container status is '$( $container.Status )'."

    [string[]] $arguments = @( 'exec', $Name, $Command ) + $( if ( $ArgumentList ) { $ArgumentList } )

    Invoke-ClientCommand `
        -ArgumentList $arguments `
        -StringOutput:$StringOutput `
        -TimeoutMS $TimeoutMS

    Write-Verbose "Command on Docker container executed."
}