task Build {
    $manifestFilePath = "$env:APPVEYOR_BUILD_FOLDER\PSDocker.psd1"
	$manifestContent = Get-Content -Path $manifestFilePath -Raw

	## Update the module version based on the build version and limit exported functions
	$replacements = @{
		"ModuleVersion = '.*'" = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
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
		'PSDocker\\psdocker\.nuspec'
		'PSDocker\\\.appveyor\.yml'
		'PSDocker\\PSDocker\.build\.ps1'
		'PSDocker\\Test\\appveyor\.Pester\.yml'
		'PSDocker\\\.git'
		'PSDocker\\\.vscode'
	)
	$exclude = $excludeFromPublish -join '|'
	Get-ChildItem -Path $env:APPVEYOR_BUILD_FOLDER -Recurse | Where-Object { $_.FullName -match $exclude } | Remove-Item -Force -Recurse

	## Publish module to PowerShell Gallery
	$publishParams = @{
		Path        = $env:APPVEYOR_BUILD_FOLDER
		NuGetApiKey = $env:nuget_apikey
	}
	Publish-Module @publishParams
}