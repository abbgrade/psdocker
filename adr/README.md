# Architecture Decision Records

This directory contains the project's architecture decision records (ADRs), using the
[MADR minimal template](https://github.com/adr/madr/blob/develop/template/adr-template-minimal.md).
The decisions document architecture visible in the existing implementation. Their rationale
is reconstructed from the code and current project requirements; it may not reflect the
original decision discussions.

## Creating an ADR

1. Copy [adr-template.md](./adr-template.md).
2. Name the new file with the next four-digit number and a short, descriptive title, for
   example `0004-support-docker-contexts.md`.
3. Keep the record focused on one decision. Add the relevant alternatives and trade-offs.
4. If a decision changes, add a new ADR that explains the change and links to the superseded
   record rather than silently rewriting history.
5. Submit ADRs with the change they concern for review.

## Decisions

* [0001: Use the Docker CLI as the engine interface](./0001-use-docker-cli-as-the-engine-interface.md)
* [0002: Separate public and internal module functions](./0002-separate-public-and-internal-module-functions.md)
* [0003: Return typed objects for images and containers](./0003-return-typed-objects-for-images-and-containers.md)
