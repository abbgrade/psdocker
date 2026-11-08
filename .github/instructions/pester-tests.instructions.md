---
name: Pester Test Structure
description: "Use when creating or updating PowerShell Pester tests, especially *.Tests.ps1 files."
applyTo: "**/*.Tests.ps1"
---

Rules:
- Use exactly one dedicated test file and one `Describe` block per public function. Name both after the unprefixed source function, for example `Get-Thing.Tests.ps1` and `Describe Get-Thing` for `function Get-Thing`.
- For modules with `DefaultCommandPrefix` in the `.psd1` manifest, use the prefixed exported command in test calls (for example, `Get-AdfThing`) but do not add that prefix to the source filename or `Describe` name.
- Never rename a function or file solely because test call sites use the manifest-prefixed command.
- Do not test private/internal functions directly.
- Do not use `Import-Module -Force` in test setup or test files.
- Do not pass `-Verbose` in test files or test helpers; leave verbose output to the user (for example `Invoke-Pester -Verbose` or `$VerbosePreference`). Helpers and commands under test may emit `Write-Verbose` diagnostics.

Structure:
- Put tests in appropriate nested `Context` blocks; do not create empty blocks.
- Use the unquoted `Context UnitTests -Tag UnitTest {` form for fast tests that do not depend on external services or Docker.
- Use the unquoted `Context IntegrationTests -Tag IntegrationTest {` form for tests that exercise Docker, external services, or other system-level integrations.
- Do not add untagged Pester tests.

Test case format:
- Every `It` block name must describe shortly what it tests. Use clear, concise language that explains the specific behavior or scenario being tested (for example, `'returns filtered users when matching criteria provided'` or `'throws error when required parameter missing'`).
- Every `It` block must follow this order:

```powershell
# Arrange
# Act
# Assert
```

- Include a phase heading only when that phase has statements in the `It` block; omit empty headings. For example, when test data is prepared in `BeforeEach`, do not add an empty `# Arrange` inside `It`.
- Put test data, dependencies, and mocks under `# Arrange`.
- Put the behavior under test under `# Act`.
- Put assertions under `# Assert`.
- Keep each test focused on one behavior and keep the three sections clearly separated.
