<#
.SYNOPSIS
Selects a Windows container image tag for the host Windows version.

.DESCRIPTION
Returns the release ID for Windows client editions and for unrecognized
Windows Server builds. Maps recognized Windows Server builds to their
corresponding long-term servicing channel image tags.

.OUTPUTS
System.String. The container image tag.
#>
function Get-WindowsContainerImageTag {
    param (
        # Windows product name used to distinguish Server editions from clients.
        [Parameter(Mandatory)][string] $ProductName,

        # Windows build number used to select a Server image tag.
        [Parameter(Mandatory)][int] $BuildNumber,

        # Release ID for client editions or unrecognized Server builds.
        [Parameter(Mandatory)][string] $ReleaseId
    )

    if ($ProductName -notlike 'Windows Server*') {
        return $ReleaseId
    }

    switch ($BuildNumber) {
        14393 { 'ltsc2016' }
        17763 { 'ltsc2019' }
        20348 { 'ltsc2022' }
        26100 { 'ltsc2025' }
        default { $ReleaseId }
    }
}
