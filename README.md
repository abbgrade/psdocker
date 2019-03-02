# PSDocker

[![Build status](https://ci.appveyor.com/api/projects/status/fck33uiofugnmgva?svg=true)](https://ci.appveyor.com/project/abbgrade/psdocker)

## Installation

Install PSDocker from [PowerShell Gallery](https://www.powershellgallery.com/packages/psdocker) using a PowerShell command line:

    Install-Module -Name PSDocker -Scope CurrentUser

## Usage

See the folder [docs](./docs) for examples.

## Changelog

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
