---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://docs.docker.com/engine/reference/commandline/version/
schema: 2.0.0
---

# Get-DockerVersion

## SYNOPSIS
Get version information

## SYNTAX

```
Get-DockerVersion [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns version information of the docker client and service.
Wraps the command \`docker version\`.

## EXAMPLES

### EXAMPLE 1
```
$version = Get-DockerVersion
PS C:\> $version.Client
Version      : 18.06.1-ce
Goversion    : go1.10.3
Experimental : false
APIversion   : 1.38
Gitcommit    : e68fc7a
Built        : Tue Aug 21 17:21:34 2018
OSArch       : windows/amd64
```

PS C:\\\> $version.Server
Version      : 18.06.1-ce
Built        : Tue Aug 21 17:36:40 2018
Experimental : false
Goversion    : go1.10.3
APIversion   : 1.38 (minimum version 1.24)
Gitcommit    : e68fc7a
Engine:      :
OSArch       : windows/amd64

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.docker.com/engine/reference/commandline/version/](https://docs.docker.com/engine/reference/commandline/version/)

