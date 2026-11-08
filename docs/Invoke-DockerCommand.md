---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Invoke-DockerCommand.html
schema: 2.0.0
---

# Invoke-DockerCommand

## SYNOPSIS
Run a command in a Docker container.

## SYNTAX

```
Invoke-DockerCommand [-Name] <String> [-Command] <String> [[-ArgumentList] <String[]>] [[-Timeout] <Int32>]
 [-StringOutput] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Runs a command in an existing container and optionally returns its output as a string.
Supports -WhatIf and -Confirm.
Wraps the Docker CLI \`exec\` command.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
$containerName = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
$container = New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $containerName -Detach -ArgumentList @('sleep','infinity')
Invoke-DockerCommand -Name $container.Name -Command 'echo' -ArgumentList 'hello' -StringOutput
Remove-DockerContainer -Name $container.Name -Force
```

Creates a temporary container, runs echo in it, then removes the container.
Captured output:
hello

## PARAMETERS

### -Name
Specifies the name of the Docker container to run the command on.

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
Specifies the command to run in the Docker container.

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
Specifies the arguments to pass to the command.

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
Returns the container command output as a string.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

### System.String: Returns command output when -StringOutput is specified.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/Invoke-DockerCommand.html](https://abbgrade.github.io/psdocker/docs/Invoke-DockerCommand.html)

[https://docs.docker.com/engine/reference/commandline/exec/](https://docs.docker.com/engine/reference/commandline/exec/)

