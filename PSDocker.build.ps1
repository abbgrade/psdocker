function Get-BuildRoot {
	if ( $env:APPVEYOR ) {
		Write-Output $env:APPVEYOR_BUILD_FOLDER
	} else {
		Write-Output '.'
	}

}

task Build {
	[string] $root = Get-BuildRoot

	New-Item -Path "$root\build" -ItemType Directory -Force | Out-Null

	# Update the module version based on the build version and limit exported functions
	$replacements = @{}
	if ( $env:APPVEYOR ) {
		$replacements["ModuleVersion = '.*'"] = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
	}

	foreach( $module in @( 'Client', 'Container' )) {

		Write-Output "Start build of module $module"

		$moduleSourcePath = "$root\src\Modules\$module"
		$moduleBuildPath = "$root\build\PSDocker.$module"
		$manifestFilePath = "$moduleSourcePath\PSDocker.$module.psd1"

		#region Update Manifest
		$manifestContent = Get-Content -Path $manifestFilePath -Raw
		$replacements.GetEnumerator() | ForEach-Object {
			$manifestContent = $manifestContent -replace $_.Key, $_.Value
		}
		$manifestContent.Trim() | Set-Content -Path $manifestFilePath
		#endregion

		#region Copy Build Artefacts
		if ( Test-Path $moduleBuildPath ) { Remove-Item $moduleBuildPath -Recurse }
		Copy-Item -Path $moduleSourcePath -Destination $moduleBuildPath -Recurse
		#endregion

		Write-Output "Build of module $module is done"
	}
}

task Test {
    Invoke-Pester -Script Test
}

task Publish {
	[string] $root = Get-BuildRoot

	# Publish module to PowerShell Gallery
	Write-Output "Publish module PSDocker.Client to PSGallery"
	Publish-Module -Path "$root\build\PSDocker.Client" -NuGetApiKey $env:nuget_apikey

	Write-Output "Install module PSDocker.Client from PSGallery"
	Import-Module -Path "$root\build\PSDocker.Client\PSDocker.Client.psd1" -Verbose

	Write-Output "Publish module PSDocker.Container to PSGallery"
	Publish-Module -Path "$root\build\PSDocker.Container" -NuGetApiKey $env:nuget_apikey
}