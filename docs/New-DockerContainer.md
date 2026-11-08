---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/New-DockerContainer.html
schema: 2.0.0
---

# New-DockerContainer

## SYNOPSIS
Create a Docker container.

## SYNTAX

```
New-DockerContainer [[-Name] <String>] [-ImageName] <String> [[-Environment] <Hashtable>]
 [[-Ports] <Hashtable>] [[-Volumes] <Hashtable>] [[-Timeout] <Int32>] [[-StatusTimeout] <Int32>] [-Detach]
 [-Interactive] [-Terminal] [-Remove] [-StringOutput] [[-ArgumentList] <String[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a container from an image and optionally configures its name, environment,
ports, volumes, and command.
Supports -WhatIf and -Confirm.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
$name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') |
    Format-List Id,Name,Image,Status
Remove-DockerContainer -Name $name -Force
```

Creates a temporary detached container, then removes it.
Captured output (temporary container ID and generated name redacted):
Id     : \<redacted\>
Name   : psdocker-example-...
Image  : mcr.microsoft.com/powershell:latest
Status : Up Less than a second

### EXAMPLE 2
```
# No Docker image or daemon is needed for this WhatIf example.
New-DockerContainer -Image 'mcr.microsoft.com/powershell' -WhatIf
```

Shows what would happen without creating a container.
Captured output:
What if: Performing the operation "Create Docker container" on target "image 'mcr.microsoft.com/powershell'".

## PARAMETERS

### -Name
Specifies the name of the new container.
If not specified, a name will be generated.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ImageName
Specifies the name of the image to create the container from.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Image

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Environment
Specifies the environment variables to use during container creation.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Ports
Specifies the port mappings for the created container.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Volumes
Specifies the volumes to mount, mapping host paths to container paths.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusTimeout
Specifies the timeout of the Docker client for the container lookup after creation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detach
Runs the container without a connection to the client shell.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Interactive
Connects the container's standard input to the client.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Terminal
Allocates a pseudo-TTY.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Remove
Automatically removes the container when it exits; no container object is returned.

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

### -StringOutput
Returns the Docker command output as a string.

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

### -ArgumentList
Specifies the command and arguments to run in the container.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
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

### Container: Returns a Container object for the created container unless -Remove is specified.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/New-DockerContainer.html](https://abbgrade.github.io/psdocker/docs/New-DockerContainer.html)

[https://docs.docker.com/engine/reference/commandline/run/](https://docs.docker.com/engine/reference/commandline/run/)

