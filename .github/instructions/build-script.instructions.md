---
description: "Use when creating or editing a PowerShell Invoke-Build project entry script named .build.ps1. Covers parameters, shared task files, module configuration, and dependency tasks."
name: "Invoke-Build Project Script"
applyTo: "**/.build.ps1"
---

# `.build.ps1` Guidelines

- Treat `.build.ps1` as the project's Invoke-Build entry point: configure the project and load its task definitions; keep reusable build logic in the task files.
- Put `[CmdletBinding()]` and `param(...)` at the top of the script, before executable statements. Document the script and each parameter with comment-based help.
- Set required project variables, such as `$ModuleName` and, for .NET projects, `$Configuration`, before dot-sourcing task files that depend on them.
- Dot-source only the task files needed by the project, using `$PSScriptRoot` for paths relative to the project. Preserve the selected template's task-loading conventions.
- Define the dependency tasks required by the selected build targets (`InstallBuildDependencies`, `InstallTestDependencies`, and `InstallReleaseDependencies`) in the project entry script. Keep project-specific dependency installation here rather than modifying shared task templates.
- Keep optional parameters explicit and compatible with the tasks that consume them. In PsBuildTasks templates, `$BuildNumber` controls alpha prerelease versioning, and `$PsBuildTasksBranch` selects the branch used to download shared files; the task template defaults the branch to `main` when it is unset.
- Do not assume every project has the same task set. Inspect the loaded task files before adding invocations, dependencies, or examples.
- Keep credentials and machine-specific values out of the script. Use the repository's existing secure configuration mechanism for secrets.
- When changing task setup, verify the script parses and run the smallest relevant Invoke-Build task. Review generated or updated files before committing because update tasks can overwrite project files.
