function Get-BuildRoot {
	if ( $env:APPVEYOR ) {
		Write-Output $env:APPVEYOR_BUILD_FOLDER
	} else {
		Write-Output '.'
	}
}

[string] $root = Get-BuildRoot
[string] $sourcePath = "$root\src"
[string] $buildPath = "$root\build"
[string] $docPath = "$root\docs"
[string] $manifestFilePath = "$sourcePath\PSDocker.psd1"
[string] $moduleBuildPath = "$buildPath\PSDocker"

task Build PrepareBuildPath, BuildManifest, CopyArtefacts

task PrepareBuildPath {
	New-Item -Path $buildPath -ItemType Directory | Out-Null
}

task CleanBuildPath {
	Remove-Item $buildPath -Recurse -ErrorAction 'Continue'
}

task BuildManifest {
	$replacements = @{}

	# Update the module version based on the build version
	if ( $env:APPVEYOR ) {
		$replacements["ModuleVersion = '.*'"] = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
	}

	# Update Manifest
	$manifestContent = Get-Content -Path $manifestFilePath -Raw
	$replacements.GetEnumerator() | ForEach-Object {
		$manifestContent = $manifestContent -replace $_.Key, $_.Value
	}
	$manifestContent.Trim() | Set-Content -Path $manifestFilePath
}

task CopyArtefacts {
	Copy-Item -Path $sourcePath -Destination $moduleBuildPath -Recurse
}

task Test {
    Invoke-Pester $sourcePath
}

task Publish {
	Publish-Module -Path $moduleBuildPath -NuGetApiKey $env:nuget_apikey
}

task Clean CleanBuildPath

task UpdateDocs {
	Import-Module $manifestFilePath -Force
	# New-MarkdownHelp -Module PSDocker -OutputFolder .\docs
	Update-MarkdownHelp $docPath
}

task . Clean, Build