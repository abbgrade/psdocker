---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version:
schema: 2.0.0
---

# Install-DockerImage

## SYNOPSIS
Install image

## SYNTAX

```
Install-DockerImage [-Name] <String> [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Installs a docker image in the service from a repository.
Wraps the command \[docker pull\](https://docs.docker.com/engine/reference/commandline/pull/).

## EXAMPLES

### BEISPIEL 1
```
Install-DockerImage -Name 'microsoft/nanoserver'
```

## PARAMETERS

### -Name
Specifies the name of the repository of the image to install.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Specifies the number of seconds to wait for the command to finish.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
