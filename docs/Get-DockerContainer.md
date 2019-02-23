---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version: https://docs.docker.com/engine/reference/commandline/ps/
schema: 2.0.0
---

# Get-DockerContainer

## SYNOPSIS
Get docker container

## SYNTAX

```
Get-DockerContainer [-Running] [-Latest] [[-Name] <String>] [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns references to docker containers of a docker service.
It can be filtered by name and status.
Wraps the command \`docker ps\`.

## EXAMPLES

### BEISPIEL 1
```
New-DockerContainer -Image 'microsoft/nanoserver' -Name 'mycontainer' | Out-Null
```

PS C:\\\> Get-DockerContainer -Name 'mycontainer'
Image       : microsoft/nanoserver
Ports       :
Command     : "c:\\\\windows\\\\system32\\\\cmd.exe"
Created     : 13 seconds ago
Name        : mycontainer
ContainerID : 1c3bd73d25552b41a677a99a15a9326ba72123096f9e10c3d36f72fb90e57f16
Status      : Exited (0) 5 seconds ago

## PARAMETERS

### -Running
Specifies if only running containers should be returned.

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

### -Latest
Specifies if only the latest created container should be returned.

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

### -Name
Specifies if only the container with the given name should be returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Container:  It returns a Container object for each container matching the parameters.
## NOTES

## RELATED LINKS

[https://docs.docker.com/engine/reference/commandline/ps/](https://docs.docker.com/engine/reference/commandline/ps/)

