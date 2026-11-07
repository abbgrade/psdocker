
param (
    [string] $ModuleManifestPath = "$PSScriptRoot\..\..\src\psdocker.psd1"
)

. $PSScriptRoot\Get-WindowsContainerImageTag.ps1
. $PSScriptRoot\Grant-TestContainerReadAccess.ps1
