function Get-Service {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ContainerName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [switch]
        $PowershellCore = $false
    )

    $command = 'Get-Service'
    if ( $Name ) {
        $command += " -Name '$Name'"
    }

    $powershell = 'powershell'
    if ( $PowershellCore ) {
        $powershell = 'pwsh'
    }

    $json = Invoke-DockerCommand `
        -Name $ContainerName `
        -Command $powershell `
        -ArgumentList "$command | Select Name, DisplayName, Status | ConvertTo-Json" `
        -StringOutput | ConvertFrom-Json

    $services = $json | ForEach-Object {
            $status = $null
            try {
                $status = [Enum]::ToObject([System.ServiceProcess.ServiceControllerStatus], $_.Status)
            } catch {
                Write-Warning $_.Exception
            }

            New-Object PSObject -Property @{
                Name  = $_.Name
                DisplayName = $_.DisplayName
                Status = $status
            }
        }

    $services
}