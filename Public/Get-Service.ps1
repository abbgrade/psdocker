function Get-Service {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $ContainerName,

        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

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

    $json = Invoke-DockerContainerCommand `
        -Name $ContainerName `
        -Command $powershell `
        -Arguments "$command | Select Name, DisplayName, Status | ConvertTo-Json" `
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