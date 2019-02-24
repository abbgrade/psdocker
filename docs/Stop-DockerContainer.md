---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version: https://docs.docker.com/engine/reference/commandline/stop/
schema: 2.0.0
---

# Stop-DockerContainer

## SYNOPSIS
Stop container

## SYNTAX

```
Stop-DockerContainer [-Name] <String> [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Wraps the command \`docker stop\`.

## EXAMPLES

### BEISPIEL 1
```
$container = New-DockerContainer -Image 'microsoft/nanoserver'
```

PS C:\\\> $container | Stop-DockerContainer

## PARAMETERS

### -Name
Specifies the name of the container to stop.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Default value: 10
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

[https://docs.docker.com/engine/reference/commandline/stop/](https://docs.docker.com/engine/reference/commandline/stop/)

