# Use the Docker CLI as the engine interface

## Context and Problem Statement

The module needs to perform Docker operations to manage images, containers, and versions.

## Considered Options

* Invoke the Docker CLI
* Call the Docker Engine API directly
* Use a Docker client library

## Decision Outcome

Chosen option: "Invoke the Docker CLI", because it was the least-effort implementation and was good enough for the project's needs. A direct API integration or client library would have added implementation and maintenance effort without enough benefit to justify it.

### Consequences

* Good, because the module does not need to introduce and maintain a separate Docker API client dependency.
* Good, because Docker CLI behavior and options remain available to the module.
* Bad, because the module must construct process arguments, handle process output and exit codes, and account for CLI output or compatibility changes.
