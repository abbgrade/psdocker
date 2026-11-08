---
name: powershell-refactoring
description: "Use when refactoring PowerShell modules or functions, improving Pester coverage, preserving parameter compatibility, or refreshing generated command help."
---

# PowerShell refactoring

Use this workflow for PowerShell refactoring and related test or help updates. Follow applicable repository and user instructions; do not change observable behavior or public contracts unless requested.

## 1. Inspect and establish a baseline

- Inspect the worktree, module manifest, exports, affected function implementations, callers, and existing tests. Preserve unrelated staged and unstaged changes.
- Determine the relevant Pester version and test selection. Before broad changes, run the existing relevant tests when feasible and record the selected tests, environment, results, and failures. Avoid network-dependent or destructive tests unless appropriate and authorized.
- If no comparable baseline can be established, report that limitation. Do not label later failures pre-existing without evidence.

## 2. Preserve contracts and improve coverage

- Treat a new or narrower parameter type or validation attribute as a potential breaking change. Inspect direct and pipeline callers and existing input shapes, including single values and arrays, before making an explicitly requested contract change.
- Add focused public-command tests for supported inputs, output shape, and relevant invalid cases. For array inputs, check each value and ensure invalid elements are rejected where validation applies. Verify behavior through dependent public commands when the change affects them.
- Keep signatures and runtime behavior unchanged for documentation-only or behavior-preserving refactoring. Follow the repository's help, naming, and Pester conventions.

## 3. Refresh generated help

- For every public command with PlatyPS-generated help, ensure the first `.LINK` in source help is its hosted page URL (`https://<project-owner>.github.io/<project>/docs/<ExportedCommandName>.html`). Derive the project URL from repository/module metadata and use the exported command name, including any manifest `DefaultCommandPrefix`. PlatyPS maps this first link to generated `online version` metadata; put external references such as Microsoft Learn links later.
- Inspect repository documentation tasks before generating help. Prefer the narrow in-place task, but verify its prerequisites and what it updates: PlatyPS `Update-MarkdownHelp` can leave synopsis, description, and examples stale, and an initialization step may emit existing-file errors even when the overall task reports success.
- Read all task output for non-terminating errors. Compare affected pages with current comment-based help and verify syntax, parameter metadata, examples, and output sections; do not assume a successful task refreshed the prose.
- If the task leaves prose stale or cannot refresh existing files, check affected pages for user edits and use PlatyPS's supported command-specific generation (for example `New-MarkdownHelp -Command <ExportedCommandName> -OutputFolder <docs> -Force`) to refresh only those pages in place. Set the locale expected by the repository task. Do not overwrite unrelated pages, hand-copy parameter descriptions, or generate docs in a temporary directory.
- Verify each generated `online version` URL exactly matches its first source `.LINK`, and confirm the rendered related link. Search affected pages for unresolved placeholders; leave known generator limitations untouched when the project accepts them and report them.

## 4. Validate and report

- Rerun the relevant existing tests and added tests using the same baseline selection and environment when possible. Compare failures with the baseline; report new, baseline-confirmed, and unclassified failures separately.
- Run applicable syntax, help, and whitespace checks. Report commands, results, skipped checks, documentation warnings, and any behavior changes explicitly requested by the user.
