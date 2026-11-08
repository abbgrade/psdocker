---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Get-DockerVersion.html
schema: 2.0.0
---

# Get-DockerVersion

## SYNOPSIS
Get Docker client and server version information.

## SYNTAX

```
Get-DockerVersion [[-Timeout] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns version details for the Docker client and server, including engine information.
Wraps the Docker CLI \`version\` command.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisite: Docker CLI is installed and the Docker daemon is running.
$version = Get-DockerVersion
$version.Server | Format-List
```

Gets client and server version details, then displays the server information.
Captured output from Docker Engine 29.9.2:
Version  : 29.9.2
Goversion : go1.26.10
APIversion : 1.56
Gitcommit : 0367cbe
Built     : 2026-10-20T18:45:02.000000000+00:00
OSArch   : linux/amd64
Engine   : @{Version=29.9.2; Goversion=go1.26.10; Experimental=false; APIversion=1.56; Gitcommit=0367cbe; Built=Tue Oct 20 19:45:02 2026; OSArch=linux/amd64}

## PARAMETERS

### -Timeout
Specifies the number of seconds to wait for the command to finish.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject: Contains Client and Server version information.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/Get-DockerVersion.html](https://abbgrade.github.io/psdocker/docs/Get-DockerVersion.html)

[https://docs.docker.com/engine/reference/commandline/version/](https://docs.docker.com/engine/reference/commandline/version/)

