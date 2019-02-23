---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version: https://docs.docker.com/engine/reference/commandline/pull/
schema: 2.0.0
---

# Install-DockerImage

## SYNOPSIS
Install image

## SYNTAX

```
Install-DockerImage [[-Registry] <String>] [-Repository] <String> [[-Tag] <String>] [-AllTags]
 [[-Digest] <String>] [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Installs a docker image in the service from a repository.
Wraps the command \`docker pull\`.

## EXAMPLES

### BEISPIEL 1
```
Install-DockerImage -Name 'microsoft/nanoserver'
```

## PARAMETERS

### -Registry
Specifies the registry that contains the repository or image.

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

### -Repository
Specifies the name of the repository of the image to install.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tag
Specifies the tag of the image to install.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AllTags
Specifies if the images for all tags should be installed.

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

### -Digest
Specifies the digest of the specific image that should be installed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
Default value: 300
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Image: Returns the images that are installed and match the parameter.
## NOTES

## RELATED LINKS

[https://docs.docker.com/engine/reference/commandline/pull/](https://docs.docker.com/engine/reference/commandline/pull/)

