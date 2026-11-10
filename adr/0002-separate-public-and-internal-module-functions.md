# Separate public and internal module functions

## Context and Problem Statement

The PowerShell module contains commands intended for users as well as implementation helpers. The module needs to expose its command surface without making internal helpers part of that surface.

## Considered Options

* Keep public and internal scripts in separate directories and export public functions
* Put every function in one script and export functions individually
* Export all functions from the module

## Decision Outcome

Chosen option: "Keep public and internal scripts in separate directories and export public functions", because the module loader imports internal scripts before public scripts and exports functions from the `Public` directory.

### Consequences

* Good, because implementation helpers are separated from the user-facing command scripts.
* Good, because public commands can use internal helpers within the module without exporting those helpers as commands.
* Bad, because the module's public surface depends on the loader's directory and export conventions being maintained.
