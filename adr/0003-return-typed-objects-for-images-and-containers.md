# Return typed objects for images and containers

## Context and Problem Statement

PowerShell users need to consume Docker image and container information in scripts and pipelines. Returning raw CLI text would make that information harder to inspect and use as structured data.

## Considered Options

* Return typed `Image` and `Container` objects
* Return raw Docker CLI output
* Return untyped structured objects

## Decision Outcome

Chosen option: "Return typed `Image` and `Container` objects", because the implementation maps Docker's structured output to named PowerShell properties and provides domain-specific types for the two principal resources.

### Consequences

* Good, because callers can inspect resource properties and pass objects through PowerShell pipelines.
* Good, because the module can provide convenience properties such as `ImageName` and `Name`.
* Bad, because the mapping and object types must be kept aligned with the Docker CLI data and the module's public behavior.
