---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version: https://docs.docker.com/engine/reference/commandline/image_rm/
schema: 2.0.0
---

# Uninstall-DockerImage

## SYNOPSIS
Remove docker image

## SYNTAX

```
Uninstall-DockerImage [[-Name] <String>] [-Force] [-NoPrune] [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Wraps the docker command \`docker image rm\`.

## EXAMPLES

### BEISPIEL 1
```
Get-DockerImage -Repository 'microsoft/powershell' | Uninstall-DockerImage
```

## PARAMETERS

### -Name
Specifies the name of the image to be removed.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Image

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Specifies if the image should be removed, even if a container is using this image.

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

### -NoPrune
Specifies if untagged parents should not be removed.

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

### -Timeout
Specifies how long to wait for the command to finish.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 10
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.docker.com/engine/reference/commandline/image_rm/](https://docs.docker.com/engine/reference/commandline/image_rm/)

[Install-Image]()

