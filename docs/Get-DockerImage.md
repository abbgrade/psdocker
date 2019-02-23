---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version: https://docs.docker.com/engine/reference/commandline/image_ls/
schema: 2.0.0
---

# Get-DockerImage

## SYNOPSIS
Get docker image

## SYNTAX

```
Get-DockerImage [[-Repository] <String>] [[-Tag] <String>] [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Wraps the command \`docker image ls\`.

## EXAMPLES

### BEISPIEL 1
```
Get-DockerImage -Repository 'microsoft/powershell'
```

Created    : 2 weeks ago
ImageId    : sha256:4ebab174c7292440d4d7d5e5e61d3cd4487441d3f49df0b656ccc81d2a0e4489
Size       : 364MB
Tag        : latest
Repository : microsoft/powershell

## PARAMETERS

### -Repository
Specifies the repository to filter the images on.

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

### -Tag
Specifies the tag to filter the images on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

### Image: Returns a Image object for each object matching the parameters.
## NOTES

## RELATED LINKS

[https://docs.docker.com/engine/reference/commandline/image_ls/](https://docs.docker.com/engine/reference/commandline/image_ls/)

