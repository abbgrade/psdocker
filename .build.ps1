<#
.Synopsis
	Build and manage the psdocker PowerShell module.

.Description
	Project entry point for Invoke-Build. Loads the module build, dependency,
	and PsBuildTasks definitions. Available tasks include building and installing
	the module, updating documentation, publishing to the PowerShell Gallery,
	and refreshing shared PsBuildTasks files.

.Example
    Invoke-Build Build
    Builds the module from src, updates its command documentation, and writes
    the build output to publish.

.Example
    Invoke-Build Doc.Init -ForceDocInit
    Creates or overwrites command documentation templates in docs. Review the
    generated files and discard unwanted overwrites with version control.

.Example
    Invoke-Build UpdatePsBuildTasks -PsBuildTasksBranch feature/copilot-task
    Refreshes the shared PsBuildTasks files from the specified branch instead
    of the default main branch.
#>

param(
    # NuGet API key used to publish the module; defaults to the nuget_apikey environment variable.
	[string] $NuGetApiKey = $env:nuget_apikey,

	# Allow publishing a module version that already exists in the PowerShell Gallery.
	[switch] $ForcePublish,

    # Overwrite existing Markdown help files when initializing documentation.
	[switch] $ForceDocInit,

	# Build number used to set an alpha prerelease suffix (for example, 12 becomes alpha0012).
	[int] $BuildNumber,

    # PsBuildTasks branch used to download shared files; defaults to main when omitted.
    [string] $PsBuildTasksBranch
)

$ModuleName = 'psdocker'

. $PSScriptRoot\tasks\Build.Tasks.ps1
. $PSScriptRoot\tasks\Dependencies.Tasks.ps1
. $PSScriptRoot\tasks\PsBuild.Tasks.ps1

# Synopsis: Default task.
task . Build
