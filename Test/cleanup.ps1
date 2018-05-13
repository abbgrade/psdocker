
Import-Module 'C:\Users\s.kampmann\Documents\GitHub\PSDocker\PSDocker.psm1' -Force

$DebugPreference = "Continue"
$VerbosePreference = "Continue"

$container = Get-Container
Write-Output "Remove $( $container.Count ) container."
$container | ForEach-Object {
    Remove-Container -Name $_.Name
}
