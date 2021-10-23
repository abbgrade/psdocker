<#
.Synopsis
	Build script <https://github.com/nightroman/Invoke-Build>

.Example
	Invoke-Build Publish -NuGetApiKey xyz
#>

param(
	[string] $NuGetApiKey = $env:nuget_apikey
)

. $PsScriptRoot\tasks\Build.Tasks.ps1

task . Clean, Build
