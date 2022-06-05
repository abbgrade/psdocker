<#
.Synopsis
	Build script <https://github.com/nightroman/Invoke-Build>

.Example
    # Create module from source.
    Invoke-Build Build

.Example
    # Add doc templates for new command.
    # BE CAREFUL! Existing documents will be overwritten and must be discarded using git.
    Invoke-Build Doc.Init -ForceDocInit
#>

param(
	[string] $NuGetApiKey = $env:nuget_apikey,

	# Overwrite published versions
	[switch] $ForcePublish,

    # Add doc templates for new command.
	[switch] $ForceDocInit,

	# Version suffix to prereleases
	[int] $BuildNumber
)

$ModuleName = 'psdocker'

. $PSScriptRoot\tasks\Build.Tasks.ps1
. $PSScriptRoot\tasks\Dependencies.Tasks.ps1
. $PSScriptRoot\tasks\PsBuild.Tasks.ps1

# Synopsis: Default task.
task . Build
