task Build {
	if ( $env:APPVEYOR ) {
		$buildPath = '.'
	} else {
		$buildPath = $env:APPVEYOR_BUILD_FOLDER
	}
    $manifestFilePath = "$buildPath\src\Modules\Client\PSDocker.Client.psd1"
	$manifestContent = Get-Content -Path $manifestFilePath -Raw

	## Update the module version based on the build version and limit exported functions
	$replacements = @{}
	if ( $env:APPVEYOR ) {
		$replacements["ModuleVersion = '.*'"] = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
	}

	$replacements.GetEnumerator() | ForEach-Object {
		$manifestContent = $manifestContent -replace $_.Key, $_.Value
	}

	$manifestContent | Set-Content -Path $manifestFilePath
}

task Test {
    Invoke-Pester -Script Test
}

task Publish {
	$null = New-Item -ItemType Directory -Path "$env:Temp\PSDocker" -Force

	## Remove all of the files/folders to exclude out of the main folder
	$excludeFromPublish = @(
		'psdocker\.nuspec'
		'\.appveyor\.yml'
		'PSDocker\.build\.ps1'
		'Test\\appveyor\.Pester\.ps1'
		'\.git'
		'\.vscode'
	)
	$exclude = $excludeFromPublish -join '|'
	Get-ChildItem -Path $env:APPVEYOR_BUILD_FOLDER -Recurse -Force | Where-Object { $_.FullName -match $exclude } | Remove-Item -Force -Recurse

	## Publish module to PowerShell Gallery
	$publishParams = @{
		Path        = $env:APPVEYOR_BUILD_FOLDER
		NuGetApiKey = $env:nuget_apikey
	}
	Publish-Module @publishParams
}