---
name: 'PowerShell'
description: 'Use when writing or editing PowerShell scripts, modules, or commands. Covers quoting, parameters, errors, and maintainable PowerShell style.'
applyTo: '**/*.ps1, **/*.psm1'
---

# PowerShell Guidelines

- Avoid quotes when syntax permits an unquoted value without changing its meaning. Otherwise prefer single quotes; use double quotes only when interpolation or an embedded single quote requires them.
- Use full cmdlet and parameter names in scripts; avoid aliases.
- Prefer pipeline input over named parameters when the command supports it and the resulting code remains clear.
- Name functions with an approved PowerShell verb and a descriptive singular noun, such as `Get-Widget`.
- For modules with `DefaultCommandPrefix` in the `.psd1` manifest, keep source `.ps1` filenames and function declarations unprefixed. PowerShell adds the prefix to exported command names at import time; do not copy it into source names.
- Give parameters appropriate types and add validation attributes when they clarify or enforce valid input.
- Treat adding or tightening parameter types or validation as a potential behavior change, not a style-only refactor. Before changing an existing contract, inspect callers and pipeline binding, including scalar and array inputs, and test compatibility and rejection cases. Preserve the existing contract unless the user requests or approves a behavior change.
- Use `Join-Path` to combine paths, and `$PSScriptRoot` when resolving paths relative to the script.
- Use `Write-Output` or the appropriate information, warning, verbose, or error stream instead of `Write-Host` in reusable functions.
- Handle failures explicitly. Do not suppress errors or use empty catch blocks; rethrow or report errors with useful context.
- Keep functions focused, pipeline-friendly where appropriate, and consistent with existing project conventions.
