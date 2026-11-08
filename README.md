# psdocker

[![.github/workflows/build-validation.yml](https://github.com/abbgrade/psdocker/actions/workflows/build-validation.yml/badge.svg?branch=develop)](https://github.com/abbgrade/psdocker/actions/workflows/build-validation.yml)

psdocker integrates Docker into PowerShell-based DevOps workflows, including test automation. It wraps the Docker CLI with commands to find and manage images and containers, and to run commands inside containers.

For details, visit the [GitHub Pages](https://abbgrade.github.io/psdocker/).

## Installation

Make sure [PowerShell 7.0 or later](https://learn.microsoft.com/powershell/scripting/install/installing-powershell) and the Docker CLI are installed. You can install Docker, for example, via [Chocolatey](https://chocolatey.org/packages/docker-cli) or [Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows/).

Install psdocker from the [PowerShell Gallery](https://www.powershellgallery.com/packages/psdocker) in a PowerShell session:

```powershell
Install-Module -Name psdocker -Scope CurrentUser
```

## Quick start

With Docker running and access to Microsoft Container Registry, pull a PowerShell image, start a container, run a command in it, and remove it:

```powershell
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
$name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
$container = New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep', 'infinity')

try {
    Invoke-DockerCommand -Name $container.Name -Command 'echo' -ArgumentList 'hello' -StringOutput
}
finally {
    Remove-DockerContainer -Name $container.Name -Force
}
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

For debugging tests, change the working directory to `./test`, set a breakpoint in VS Code, and start debugging with F1 + "Debug: Start Debugging".

## Usage

See [the command reference](./docs/) for descriptions and examples.

## Changelog

See the [changelog](./CHANGELOG.md) file.

## Contributors

Thanks to the contributors of this project:

- Steffen Kampmann
- Marc Kassay
