---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://docs.docker.com/engine/reference/commandline/run/
schema: 2.0.0
---

# New-DockerContainer

## SYNOPSIS
New container

## SYNTAX

```
New-DockerContainer [[-Name] <String>] [-ImageName] <String> [[-Environment] <Hashtable>]
 [[-Ports] <Hashtable>] [[-Volumes] <Hashtable>] [[-Timeout] <Int32>] [[-StatusTimeout] <Int32>] [-Detach]
 [-Interactive] [-Terminal] [-Remove] [-StringOutput] [[-ArgumentList] <String[]>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new container in the docker service.
Wraps the command \`docker run\`.

## EXAMPLES

### EXAMPLE 1
```
New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer'
Image       : microsoft/nanoserver
Ports       :
Command     : "c:\\windows\\system32\\cmd.exe"
Created     : 14 seconds ago
Name        : mycontainer
ContainerID : 1a0b70cfcfba78e46468dbfa72b0b36fae4c30282367482bc348b5fcee0b85d3
Status      : Exited (0) 1 second ago
```

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
Automatically removes the container when it exits.

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

### Container: Returns a Container object for the created container.
## NOTES

## RELATED LINKS

[https://docs.docker.com/engine/reference/commandline/run/](https://docs.docker.com/engine/reference/commandline/run/)

