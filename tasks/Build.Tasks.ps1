# Copy from original https://github.com/abbgrade/PsBuildTasks/blob/main/Powershell/Build.Tasks.ps1

requires ModuleName

[System.IO.DirectoryInfo] $SourceDirectory = "$PsScriptRoot/../src"
[System.IO.DirectoryInfo] $SourceManifest = "$SourceDirectory/$ModuleName.psd1"
[System.IO.DirectoryInfo] $PublishDirectory = "$PsScriptRoot/../publish"
[System.IO.DirectoryInfo] $DocumentationDirectory = "$PsScriptRoot/../docs"
[System.IO.DirectoryInfo] $ModulePublishDirectory = "$PublishDirectory/$ModuleName"

# Synopsis: Remove all temporary files.
task Clean -Jobs {
	remove $PublishDirectory
	$DocumentationDirectory | Get-ChildItem -Exclude index.md, _config.yml | Remove-item
}

# Synopsis: Import the module.
task Import -Jobs {
    Import-Module $SourceManifest -Force
}

# Synopsis: Import platyPs.
task Import.platyPs -Jobs {
	Import-Module platyPs
}

# Synopsis: Initialize the documentation directory.
task Doc.Init.Directory -If { $DocumentationDirectory.Exists -eq $false} -Jobs {
	New-Item $DocumentationDirectory -ItemType Directory
}

# Synopsis: Initialize the documentation.
task Doc.Init -Jobs Import, Import.platyPs, Doc.Init.Directory, {
    New-MarkdownHelp -Module $ModuleName -OutputFolder $DocumentationDirectory -Force:$ForceDocInit -ErrorAction Continue
}

# Synopsis: Update the markdown documentation.
task Doc.Update -Jobs Import, Import.platyPs, Doc.Init, {
    Update-MarkdownHelp -Path $DocumentationDirectory
}

task PreparePublishDirectory -If ( -Not ( Test-Path $PublishDirectory )) -Jobs {
	New-Item -Path $PublishDirectory -ItemType Directory | Out-Null
}

# Synopsis: Set the prerelease in the manifest based on the build number.
task SetPrerelease -If $BuildNumber {
	$Global:PreRelease = "alpha$( '{0:d4}' -f $BuildNumber )"
	Update-ModuleManifest -Path $Global:Manifest -Prerelease $Global:PreRelease
}

# Synopsis: Build the module.
task Build -Jobs Clean, Doc.Update, PreparePublishDirectory, {
	Copy-Item -Path $SourceDirectory -Destination $ModulePublishDirectory -Recurse
    [System.IO.FileInfo] $Global:Manifest = "$ModulePublishDirectory/$ModuleName.psd1"
}, SetPrerelease

# Synopsis: Install the module.
task Install -Jobs Build, {
    $info = Import-PowerShellDataFile $Global:Manifest
    $version = ([System.Version] $info.ModuleVersion)
	$defaultModulePath = $env:PSModulePath -split ';' | Select-Object -First 1
    if ( -not $defaultModulePath ) {
        Write-Error "Failed to determine default module path from `$env:PSModulePath='$( $env:PSModulePath )'"
    }
	Write-Verbose "install $ModuleName $version to '$defaultModulePath'"
	$installPath = Join-Path $defaultModulePath $ModuleName $version.ToString()
    New-Item -Type Directory $installPath -Force | Out-Null
    Get-ChildItem $Global:Manifest.Directory | Copy-Item -Destination $installPath -Recurse -Force
}

# Synopsis: Publish the module to PSGallery.
task Publish -Jobs Clean, Build, {
	if ( -Not $Global:PreRelease ) {
		assert ( $Configuration -eq 'Release' )
		Update-ModuleManifest -Path $Global:Manifest -Prerelease ''
	}
	Publish-Module -Path $Global:Manifest.Directory -NuGetApiKey $NuGetApiKey -Force:$ForcePublish
}
