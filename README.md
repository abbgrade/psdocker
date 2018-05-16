# PSDocker

[![Build status](https://ci.appveyor.com/api/projects/status/fck33uiofugnmgva?svg=true)](https://ci.appveyor.com/project/abbgrade/psdocker)

## Installation

Install PSDocker from [PowerShell Gallery](https://www.powershellgallery.com/packages/psdocker) using a PowerShell command line:

    Install-Module -Name PSDocker -Scope CurrentUser

## Usage

Get a image from the docker repository

    Install-DockerImage -Image 'microsoft/nanoserver'

Create a new container

    New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer'

Stop a container

    Stop-DockerContainer -Name 'mycontainer'

Remove a container

    Remove-DockerContainer -Name 'mycontainer'

Get container information

    Get-DockerContainer

Run a command in a docker container

    $container = New-DockerContainer -Image 'microsoft/iis' -Detach
    Invoke-DockerContainerCommand -Name $container.Name -Command "hostname"