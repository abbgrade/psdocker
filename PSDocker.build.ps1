task Build {

	[string] $root = $null
	if ( $env:APPVEYOR ) {
		$root = $env:APPVEYOR_BUILD_FOLDER
	} else {
		$root = '.'
	}

	New-Item -Path "$root\build" -ItemType Directory -Force

	# Update the module version based on the build version and limit exported functions
	$replacements = @{}
	if ( $env:APPVEYOR ) {
		$replacements["ModuleVersion = '.*'"] = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
	}

	foreach( $module in @( 'Client', 'Container' )) {

		$manifestFilePath = "$root\src\Modules\$module\PSDocker.$module.psd1"
		$manifestContent = Get-Content -Path $manifestFilePath -Raw

		$replacements.GetEnumerator() | ForEach-Object {
			$manifestContent = $manifestContent -replace $_.Key, $_.Value
		}

		$manifestContent.Trim() | Set-Content -Path $manifestFilePath

		# Copy build artefacts
		Copy-Item -Path "$root\src\Modules\$module" -Destination "$root\build\PSDocker.$module" -Recurse
	}
}

task Test {
    Invoke-Pester -Script Test
}

task Publish {
	# Publish module to PowerShell Gallery
	Publish-Module -Path "$($env:APPVEYOR_BUILD_FOLDER)\build\PSDocker.Client" -NuGetApiKey $env:nuget_apikey
	Publish-Module -Path "$($env:APPVEYOR_BUILD_FOLDER)\build\PSDocker.Container" -NuGetApiKey $env:nuget_apikey
}