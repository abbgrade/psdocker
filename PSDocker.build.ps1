task Build {
	if ( $env:APPVEYOR ) {
		$buildPath = '.'
	} else {
		$buildPath = $env:APPVEYOR_BUILD_FOLDER
	}
    $manifestFilePath = "$buildPath\src\Modules\Client\PSDocker.Client.psd1"
	$manifestContent = Get-Content -Path $manifestFilePath -Raw

	# Update the module version based on the build version and limit exported functions
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
	# Publish module to PowerShell Gallery
	$clientModulePath = "$env:APPVEYOR_BUILD_FOLDER\src\Modules\Client"

	Get-ChildItem $clientModulePath -Recurse

	$publishParams = @{
		Path        = $clientModulePath
		NuGetApiKey = $env:nuget_apikey
	}
	Publish-Module @publishParams
}