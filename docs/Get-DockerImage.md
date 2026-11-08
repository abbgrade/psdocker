---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Get-DockerImage.html
schema: 2.0.0
---

# Get-DockerImage

## SYNOPSIS
Get Docker images.

## SYNTAX

```
Get-DockerImage [[-Repository] <String>] [[-Tag] <String>] [[-Timeout] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns locally available Docker images, optionally filtered by repository and tag.
Wraps the Docker CLI \`image ls\` command.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
Get-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' |
    Format-List Repository,Tag,Id,Size
```

Pulls the image if needed, then returns its local image information.
Captured output (the image ID may change when the tag is updated):
Repository : mcr.microsoft.com/powershell
Tag        : latest
Id         : sha256:810c4f1e0c9d23022c3ec18c50a6205ee4b60766f1739d329b2948df1fd7d5b0
Size       : 489MB

## PARAMETERS

### -Repository
Specifies the repository to filter the images on.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Position: 3
Default value: 10
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

### Image: Returns an Image object for each image matching the parameters.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/Get-DockerImage.html](https://abbgrade.github.io/psdocker/docs/Get-DockerImage.html)

[https://docs.docker.com/engine/reference/commandline/image_ls/](https://docs.docker.com/engine/reference/commandline/image_ls/)

