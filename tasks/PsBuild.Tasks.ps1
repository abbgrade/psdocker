
if ( -Not $PsBuildTasksBranch ) {
    $PsBuildTasksBranch = 'main'
}

#region InvokeBuild

task UpdateBuildTasks {
	Invoke-WebRequest `
		-Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/Powershell/Build.Tasks.ps1" `
		-OutFile "$PSScriptRoot\Build.Tasks.ps1"
}

#endregion
#region GitHub Actions

task UpdateValidationWorkflow {
    [System.IO.FileInfo] $file = "$PSScriptRoot/../.github/workflows/build-validation.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/GitHub/build-validation-matrix.yml" `
        -OutFile $file
}

task UpdatePagesWorkflow {
    [System.IO.FileInfo] $file = "$PSScriptRoot/../.github/workflows/build-pages.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/GitHub/build-pages.yml" `
        -OutFile $file
}

task UpdatePreReleaseWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\pre-release.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/GitHub/pre-release-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateReleaseWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\release.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/GitHub/release-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateReleaseHotfixWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\release-hotfix.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/GitHub/release-hotfix-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateWorkflows -Jobs UpdateValidationWorkflow, UpdatePagesWorkflow, UpdatePreReleaseWorkflow, UpdateReleaseWorkflow, UpdateReleaseHotfixWorkflow

#endregion
#region GitHub Pages

task UpdateIndexPage {
    New-Item -Type Directory "$PSScriptRoot\..\docs" -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/docs/index.md" `
        -OutFile "$PSScriptRoot\..\docs\index.md"
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/_config.yml" `
        -OutFile "$PSScriptRoot\..\_config.yml"
}

#endregion
#region VsCode

task UpdateVsCodeTasks {
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.vscode\tasks.json"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/VsCode/tasks.json" `
        -OutFile $file
}

#endregion
#region GitHub Copilot

task UpdateCopilot {
    $files = @(
        @{ Source = 'Copilot/instructions/readme.instructions.md'; Target = '.github/instructions/readme.instructions.md' }
        @{ Source = 'Copilot/instructions/changelog.instructions.md'; Target = '.github/instructions/changelog.instructions.md' }
        @{ Source = 'Copilot/instructions/build-script.instructions.md'; Target = '.github/instructions/build-script.instructions.md' }
        @{ Source = 'Copilot/instructions/powershell.instructions.md'; Target = '.github/instructions/powershell.instructions.md' }
        @{ Source = 'Copilot/instructions/powershell-functions.instructions.md'; Target = '.github/instructions/powershell-functions.instructions.md' }
        @{ Source = 'Copilot/instructions/pester-tests.instructions.md'; Target = '.github/instructions/pester-tests.instructions.md' }
        @{ Source = 'Copilot/agents/powershell-refactor.agent.md'; Target = '.github/agents/powershell-refactor.agent.md' }
        @{ Source = 'Copilot/skills/powershell-refactoring/SKILL.md'; Target = '.github/skills/powershell-refactoring/SKILL.md' }
        @{ Source = 'Copilot/skills/psbuildtasks-skill/SKILL.md'; Target = '.github/skills/psbuildtasks-skill/SKILL.md' }
    )
    $projectRoot = Join-Path $PSScriptRoot '..'

    foreach ($file in $files) {
        $target = Join-Path $projectRoot $file.Target
        New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force | Out-Null
        Invoke-WebRequest `
            -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/$($file.Source)" `
            -OutFile $target
    }
}

#endregion
#region PsBuildTasks

task UpdatePsBuildTasksTasks {
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/tasks/PowerShell-Matrix.Tasks.ps1" `
        -OutFile "$PSScriptRoot\PsBuild.Tasks.ps1"
}

#endregion
#region PowerShell Module

task UpdateModuleFile {
    requires ModuleName
    New-Item -Type Directory "$PSScriptRoot\..\src" -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTasksBranch/Powershell/MyModuleName.psm1" `
        -OutFile "$PSScriptRoot\..\src\$ModuleName.psm1"
}

#endregion

task UpdatePsBuildTasks -Jobs UpdateBuildTasks, UpdateWorkflows, UpdateIndexPage, UpdateVsCodeTasks, UpdatePsBuildTasksTasks, UpdateModuleFile, UpdateCopilot
