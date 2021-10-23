
[string] $sourcePath = "$PsScriptRoot\src"
[string] $buildPath = "$PsScriptRoot\build"
[string] $docPath = "$PsScriptRoot\docs"
[string] $manifestFilePath = "$sourcePath\PSDocker.psd1"
[string] $moduleBuildPath = "$buildPath\PSDocker"

task Build -Jobs CopyArtefacts

task CleanBuildPath {
	Remove-Item $buildPath -Recurse -ErrorAction 'Continue'
}

task PrepareBuildPath -Jobs CleanBuildPath, {
	New-Item -Path $buildPath -ItemType Directory | Out-Null
}

task CopyArtefacts -Jobs PrepareBuildPath, {
	Copy-Item -Path $sourcePath -Destination $moduleBuildPath -Recurse
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
