task Build {

	[string] $root = $null
	if ( $env:APPVEYOR ) {
		$root = $env:APPVEYOR_BUILD_FOLDER
	} else {
		$root = '.'
	}

	New-Item -Path "$root\build" -ItemType Directory -Force | Out-Null

	# Update the module version based on the build version and limit exported functions
	$replacements = @{}
	if ( $env:APPVEYOR ) {
		$replacements["ModuleVersion = '.*'"] = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
	}

	foreach( $module in @( 'Client', 'Container' )) {

		Write-Output "Start build of module $module"

		$manifestFilePath = "$root\src\Modules\$module\PSDocker.$module.psd1"
		$manifestContent = Get-Content -Path $manifestFilePath -Raw

		$replacements.GetEnumerator() | ForEach-Object {
			$manifestContent = $manifestContent -replace $_.Key, $_.Value
		}

		$manifestContent.Trim() | Set-Content -Path $manifestFilePath

		# Copy build artefacts
		Copy-Item -Path "$root\src\Modules\$module" -Destination "$root\build\PSDocker.$module" -Recurse


		Write-Output "Build of module $module is done"
	}
}

task Test {
    Invoke-Pester -Script Test
}

task Publish {
	# Publish module to PowerShell Gallery

	Write-Output "Publish module PSDocker.Client to PSGallery"
	Publish-Module -Path "$($env:APPVEYOR_BUILD_FOLDER)\build\PSDocker.Client" -NuGetApiKey $env:nuget_apikey

	Write-Output "Install module PSDocker.Client from PSGallery"
	Import-Module 'PSDocker.Client' -Verbose

	Write-Output "Publish module PSDocker.Container to PSGallery"
	Publish-Module -Path "$($env:APPVEYOR_BUILD_FOLDER)\build\PSDocker.Container" -NuGetApiKey $env:nuget_apikey
}