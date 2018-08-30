task Build {
	[string] $root = $null
	if ( $env:APPVEYOR ) {
		$root = $env:APPVEYOR_BUILD_FOLDER
	} else {
		$root = '.'
	}
    $manifestFilePath = "$root\src\Modules\Client\PSDocker.Client.psd1"
	$manifestContent = Get-Content -Path $manifestFilePath -Raw

	# Update the module version based on the build version and limit exported functions
	$replacements = @{}
	if ( $env:APPVEYOR ) {
		$replacements["ModuleVersion = '.*'"] = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
	}

	$replacements.GetEnumerator() | ForEach-Object {
		$manifestContent = $manifestContent -replace $_.Key, $_.Value
	}

	$manifestContent.Trim() | Set-Content -Path $manifestFilePath

	# Copy build artefacts
	New-Item -Path "$root\build" -ItemType Directory
	Copy-Item -Path "$root\src\Modules\Client" -Destination "$root\build\PSDocker.Client" -Recurse
}

task Test {
    Invoke-Pester -Script Test
}

task Publish {
	# Publish module to PowerShell Gallery
	Publish-Module -Path "$($env:APPVEYOR_BUILD_FOLDER)\build\PSDocker.Client" -NuGetApiKey $env:nuget_apikey
}