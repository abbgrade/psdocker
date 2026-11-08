---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Get-DockerContainer.html
schema: 2.0.0
---

# Get-DockerContainer

## SYNOPSIS
Get Docker containers.

## SYNTAX

```
Get-DockerContainer [-Running] [-Latest] [[-Name] <String>] [[-Timeout] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns container information and can filter by running state, latest container,
or name.
Wraps the Docker CLI \`ps\` command.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
$name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') | Out-Null
Get-DockerContainer -Running -Name $name | Format-List Id,Name,Image,Status
Remove-DockerContainer -Name $name -Force
```

Creates a temporary running container, lists it, then removes it.
Captured output (temporary container ID and generated name redacted):
Id     : \<redacted\>
Name   : psdocker-example-...
Image  : mcr.microsoft.com/powershell:latest
Status : Up Less than a second

### EXAMPLE 2
```
# Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
$name = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
New-DockerContainer -Image 'mcr.microsoft.com/powershell:latest' -Name $name -Detach -ArgumentList @('sleep','infinity') | Out-Null
Get-DockerContainer -Name $name | Format-List Id,Name,Image,Status
Remove-DockerContainer -Name $name -Force
```

Finds a container by name, then removes the temporary container.
Captured output (temporary container ID and generated name redacted):
Id     : \<redacted\>
Name   : psdocker-example-...
Image  : mcr.microsoft.com/powershell:latest
Status : Up Less than a second

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

### Container: Returns a Container object for each container matching the parameters.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/Get-DockerContainer.html](https://abbgrade.github.io/psdocker/docs/Get-DockerContainer.html)

[https://docs.docker.com/engine/reference/commandline/ps/](https://docs.docker.com/engine/reference/commandline/ps/)

