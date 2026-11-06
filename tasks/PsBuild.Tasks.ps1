
if ( -Not $PsBuildTaskBranch ) {
    $PsBuildTaskBranch = 'main'
}

#region InvokeBuild

task UpdateBuildTasks {
	Invoke-WebRequest `
		-Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/Powershell/Build.Tasks.ps1" `
		-OutFile "$PSScriptRoot\Build.Tasks.ps1"
}

#endregion
#region GitHub Actions

task UpdateValidationWorkflow {
    [System.IO.FileInfo] $file = "$PSScriptRoot/../.github/workflows/build-validation.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/build-validation-matrix.yml" `
        -OutFile $file
}

task UpdatePagesWorkflow {
    [System.IO.FileInfo] $file = "$PSScriptRoot/../.github/workflows/build-pages.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/build-pages.yml" `
        -OutFile $file
}

task UpdatePreReleaseWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\pre-release.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/pre-release-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateReleaseWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\release.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/release-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateReleaseHotfixWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\release-hotfix.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/release-hotfix-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateWorkflows -Jobs UpdateValidationWorkflow, UpdatePagesWorkflow, UpdatePreReleaseWorkflow, UpdateReleaseWorkflow, UpdateReleaseHotfixWorkflow

#endregion
#region GitHub Pages

task UpdateIndexPage {
    New-Item -Type Directory "$PSScriptRoot\..\docs" -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/docs/index.md" `
        -OutFile "$PSScriptRoot\..\docs\index.md"
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/_config.yml" `
        -OutFile "$PSScriptRoot\..\_config.yml"
}

#endregion
#region VsCode

task UpdateVsCodeTasks {
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.vscode\tasks.json"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/VsCode/tasks.json" `
        -OutFile $file
}

#endregion
#region PsBuildTasks

task UpdatePsBuildTasksTasks {
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/tasks/PowerShell-Matrix.Tasks.ps1" `
        -OutFile "$PSScriptRoot\PsBuild.Tasks.ps1"
}

#endregion
#region PowerShell Module

task UpdateModuleFile {
    requires ModuleName
    New-Item -Type Directory "$PSScriptRoot\..\src" -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/Powershell/MyModuleName.psm1" `
        -OutFile "$PSScriptRoot\..\src\$ModuleName.psm1"
}

#endregion

task UpdatePsBuildTasks -Jobs UpdateBuildTasks, UpdateWorkflows, UpdateIndexPage, UpdateVsCodeTasks, UpdatePsBuildTasksTasks, UpdateModuleFile
