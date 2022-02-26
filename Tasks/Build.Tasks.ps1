requires ModuleName

[System.IO.DirectoryInfo] $SourceDirectory = "$PsScriptRoot\..\Source"
[System.IO.DirectoryInfo] $SourceManifest = "$SourceDirectory\$ModuleName.psd1"
[System.IO.DirectoryInfo] $PublishDirectory = "$PsScriptRoot\..\Publish"
[System.IO.DirectoryInfo] $DocumentationDirectory = "$PsScriptRoot\..\Docs"
[System.IO.DirectoryInfo] $ModulePublishDirectory = "$PublishDirectory\$ModuleName"

# Synopsis: Remove all temporary files.
task Clean -Jobs {
	remove $PublishDirectory, $DocumentationDirectory
}

# Synopsis: Import the module.
task Import -Jobs {
    Import-Module $SourceManifest -Force
}

# Synopsis: Initialize the documentation.
task Doc.Init -If { $DocumentationDirectory.Exists -eq $false -Or $ForceDocInit -eq $true } -Jobs Import, {
	New-Item $DocumentationDirectory -ItemType Directory -ErrorAction SilentlyContinue
    New-MarkdownHelp -Module $ModuleName -OutputFolder $DocumentationDirectory -Force:$ForceDocInit -ErrorAction Stop
}

# Synopsis: Update the markdown documentation.
task Doc.Update -Jobs Import, Doc.Init, {
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
    [System.IO.FileInfo] $Global:Manifest = "$ModulePublishDirectory\$ModuleName.psd1"
}, SetPrerelease

# Synopsis: Install the module.
task Install -Jobs Build, {
    $info = Import-PowerShellDataFile $Global:Manifest
    $version = ([System.Version] $info.ModuleVersion)
    $defaultModulePath = $env:PsModulePath -split ';' | Select-Object -First 1
	Write-Verbose "install $ModuleName $version to $defaultModulePath"
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
