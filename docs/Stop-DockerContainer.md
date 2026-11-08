---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Stop-DockerContainer.html
schema: 2.0.0
---

# Stop-DockerContainer

## SYNOPSIS
Stop a Docker container.

## SYNTAX

```
Stop-DockerContainer [-Name] <String> [[-Timeout] <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Stops a running container.
Supports -WhatIf and -Confirm.
Wraps the Docker CLI \`stop\` command.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
$name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') | Out-Null
Stop-DockerContainer -Name $name
Remove-DockerContainer -Name $name
```

Creates a temporary container, stops it, then removes it.
Captured output:
No output.
The container is stopped.

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

## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/Stop-DockerContainer.html](https://abbgrade.github.io/psdocker/docs/Stop-DockerContainer.html)

[https://docs.docker.com/engine/reference/commandline/stop/](https://docs.docker.com/engine/reference/commandline/stop/)

