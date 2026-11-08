---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Install-DockerImage.html
schema: 2.0.0
---

# Install-DockerImage

## SYNOPSIS
Pull a Docker image.

## SYNTAX

```
Install-DockerImage [[-Registry] <String>] [-Repository] <String> [[-Tag] <String>] [-AllTags]
 [[-Digest] <String>] [[-Timeout] <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Pulls an image from a registry and returns matching local image information.
Supports -WhatIf and -Confirm.
Wraps the Docker CLI \`pull\` command.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker is running and can access the image registry.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' |
    Format-List Repository,Tag,Id,Size
```

Pulls the latest PowerShell image.
Captured output (the image ID may change when the tag is updated):
Repository : mcr.microsoft.com/powershell
Tag        : latest
Id         : sha256:810c4f1e0c9d23022c3ec18c50a6205ee4b60766f1739d329b2948df1fd7d5b0
Size       : 489MB

### EXAMPLE 2
```
# Does not require the image to be present or pulled.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -WhatIf
```

Shows the pull operation without downloading the image.
Captured output:
What if: Performing the operation "Pull Docker image" on target "mcr.microsoft.com/powershell".

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
Aliases: Name, ImageName

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
Accept pipeline input: False
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

### Image: Returns Image objects for the pulled image matching the specified parameters.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/Install-DockerImage.html](https://abbgrade.github.io/psdocker/docs/Install-DockerImage.html)

[https://docs.docker.com/engine/reference/commandline/pull/](https://docs.docker.com/engine/reference/commandline/pull/)

