---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version:
schema: 2.0.0
---

# Invoke-DockerCommand

## SYNOPSIS
Invoke command

## SYNTAX

```
Invoke-DockerCommand [-Name] <String> [-Command] <String> [[-ArgumentList] <String[]>] [[-Timeout] <Int32>]
 [-StringOutput] [<CommonParameters>]
```

## DESCRIPTION
Invokes a command on a docker container.
Wraps the docker \[command exec\](https://docs.docker.com/engine/reference/commandline/exec/).

## EXAMPLES

### BEISPIEL 1
```
$container = New-DockerContainer -Image 'microsoft/iis' -Detach
```

PS C:\\\> Invoke-DockerCommand -Name $container.Name -Command "hostname" -StringOutput
88eb8fa9c07f

## PARAMETERS

### -Name
Specifies the name of the docker container to run the command on.

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

### -Command
Specifies the command to run on the docker container.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ArgumentList
Specifies the list of arguments of the command.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -StringOutput
Specifies if the output of the container command should be returned as string.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
