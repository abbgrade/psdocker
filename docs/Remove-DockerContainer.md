---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version:
schema: 2.0.0
---

# Remove-DockerContainer

## SYNOPSIS
Remove container

## SYNTAX

```
Remove-DockerContainer [-Name] <String> [-Force] [[-Timeout] <Int32>] [[-StopTimeout] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a docker container from the service.
Wraps the command \[docker rm\](https://docs.docker.com/engine/reference/commandline/rm/).

## EXAMPLES

### BEISPIEL 1
```
New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer' | Out-Null
```

PS C:\\\> Remove-DockerContainer -Name 'mycontainer'

## PARAMETERS

### -Name
Specifies the name of the container, that should be removed.

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

### -Force
Specifies if the container should be stopped before removal.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopTimeout
Specifies the timeout of the docker client command for the stop operation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
