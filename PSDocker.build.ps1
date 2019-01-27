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

task Build PrepareBuildPath, CopyArtefacts

task PrepareBuildPath {
	New-Item -Path $buildPath -ItemType Directory | Out-Null
}

task CleanBuildPath {
	Remove-Item $buildPath -Recurse -ErrorAction 'Continue'
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
	Remove-Item -Path $docPath/*
	New-MarkdownHelp -Module PSDocker -OutputFolder $docPath
	# Update-MarkdownHelp -Path $docPath -AlphabeticParamsOrder -Force
}

task . Clean, Build