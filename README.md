# psdocker

[![.github/workflows/build-validation.yml](https://github.com/abbgrade/psdocker/actions/workflows/build-validation.yml/badge.svg?branch=develop)](https://github.com/abbgrade/psdocker/actions/workflows/build-validation.yml)

For details, visit the [GitHub Pages](https://abbgrade.github.io/psdocker/).

## Installation

Make sure the Docker CLI is installed, for example via [Chocolatey](https://chocolatey.org/packages/docker-cli) or [Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows/).

Install psdocker from the [PowerShell Gallery](https://www.powershellgallery.com/packages/psdocker) in a PowerShell session:

```powershell
Install-Module -Name psdocker -Scope CurrentUser
```

## Build

This project uses a [build script](./.build.ps1) based on [Invoke-Build](https://github.com/nightroman/Invoke-Build).
For installation details, see the Invoke-Build documentation; we recommend `Install-Module InvokeBuild -Scope CurrentUser`.
The documentation is generated with [platyPS](https://github.com/PowerShell/platyPS), so you may also want to run `Install-Module PlatyPs -Scope CurrentUser`.

You can run the build by:

- __PowerShell__: execute `Invoke-Build` in a PowerShell session in the project directory
- __VS Code__: run the integrated build task feature (F1 + "Tasks: Run Build Task")

## Test

This project uses test scripts based on [Pester](https://github.com/pester/Pester).
For installation details, see the Pester documentation; we recommend `Install-Module Pester -Scope CurrentUser`.

You can run the tests by:

- __PowerShell__: execute `Invoke-Build Test` in a PowerShell session in the project directory
- __VS Code__: run the integrated test task feature (F1 + "Tasks: Run Test Task")

For debugging tests, change the working directory to `./src/test`, set a breakpoint in VS Code, and start debugging with F1 + "Debug: Start Debugging".

## Usage

See [the command reference](./docs/) for descriptions and examples.

## Changelog

See the [changelog](./CHANGELOG.md) file.

## Contributors

Thanks to the contributors of this project:

- Steffen Kampmann
- Marc Kassay
