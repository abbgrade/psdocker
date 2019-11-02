# PSDocker

[![Build status](https://ci.appveyor.com/api/projects/status/fck33uiofugnmgva?svg=true)](https://ci.appveyor.com/project/abbgrade/psdocker)

## Installation

Install PSDocker from [PowerShell Gallery](https://www.powershellgallery.com/packages/psdocker) using a PowerShell command line:

    Install-Module -Name PSDocker -Scope CurrentUser

## Build

This project uses a [build script](./PsDocker.build.ps1) that is based on [Invoke-Build](https://github.com/nightroman/Invoke-Build).
For installation details see the instructions from the Invoke-Build project, but we recommend `Install-Module InvokeBuild -Scope CurrentUser`.
The documentation is based on [platyPS](https://github.com/PowerShell/platyPS), so you may want to execute `Install-Module PlatyPs -Scope CurrentUser`.

You can run the build by:

- __PowerShell__: execute `Invoke-Build` in a PowerShell in the directory of this project
- __VSCode__: run the integrated build task feature (F1 + "Tasks: Run Build Task")

## Test

This project uses test scripts using [Pester](https://github.com/pester/Pester).
For installation details see the instructions from the Pester project, but we recommend `Install-Module Pester -Scope CurrentUser`.

You can run the tests by:

- __PowerShell__: execute `Invoke-Build Test` in a PowerShell in the directory of this project
- __VSCode__: run the integrated test task feature (F1 + "Tasks: Run Test Task")

For debugging tests change the working directory to ./src/test create the breakpoint in VSCode and start debugging by F1 + "Debug: Start Debugging".

## Usage

See the folder [docs](./docs) for examples.

## Changelog

### Work in progress

- Fixed timeout issue

### Version 1.5.0

- Adopted changes from the Docker CLI
- Added argument completions for image name, tag, repository, container name

### Version 1.4.0

- Fixed output issue with volumes
- Fixed pipeline processing with multiple items
- Fixed ErrorAction parameter
- Unit test refactoring

### Version 1.3.0

- Support for Linux clients
- Support for Linux containers
- Support von container volumes
- Refactoring

### Version 1.2.0

- Pipeline support for the cmdlets.
- New cmdlet Uninstall-Image
- Types for Image, Repository and Container used as output.
- Refactoring

## Contributors

- Steffen Kampmann
- Marc Kassay
