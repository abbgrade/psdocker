---
description: "Use when creating or editing CHANGELOG.md files or recording user-facing changes. Covers Unreleased entries, Keep a Changelog sections, and release versioning."
name: "Changelog Guidelines"
applyTo: "**/CHANGELOG.md"
---
# Changelog Guidelines

- Follow the existing changelog format and Keep a Changelog conventions. Preserve historical release entries and their wording unless correcting an error.
- Record user-facing changes under `## [Unreleased]`. Use concise bullets that describe the impact to users, not implementation details.
- Group entries under relevant `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, or `Security` headings. Add only headings that have entries; do not add empty categories or placeholder entries.
- Keep `## [Unreleased]` at the top, followed by released versions in descending order.
- Do not create or edit a versioned release heading or change a version/date unless a release or version bump is explicitly requested. For a requested release, move the unreleased entries into the new version section, use the requested version and release date, and leave an `Unreleased` section at the top.
- Add an entry only for a meaningful user-facing change. Do not log routine maintenance, internal-only changes, or documentation edits that do not affect users.
