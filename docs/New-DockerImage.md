---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/New-DockerImage.html
schema: 2.0.0
---

# New-DockerImage

## SYNOPSIS
Build a Docker image.

## SYNTAX

```
New-DockerImage [-Repository] <String> [[-Tag] <String>] [[-Path] <DirectoryInfo>] [[-Timeout] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Builds an image from a Dockerfile in the specified build context.
Supports -WhatIf and -Confirm.
Wraps the Docker CLI \`build\` command.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker is running and can pull images from Microsoft Container Registry.
Install-DockerImage -Repository 'mcr.microsoft.com/powershell' -Tag 'latest' | Out-Null
$repository = "psdocker-example-$([guid]::NewGuid().ToString('N'))"
$buildContext = Join-Path $env:TEMP $repository
New-Item -Path $buildContext -ItemType Directory | Out-Null
Set-Content -Path (Join-Path $buildContext 'Dockerfile') -Value 'FROM mcr.microsoft.com/powershell:latest'
New-DockerImage -Repository $repository -Path $buildContext
Get-DockerImage -Repository $repository -Tag 'latest' |
    Format-List Repository,Tag,Id,Size
Uninstall-DockerImage -Name "$repository`:latest" -Force
Remove-Item -Path $buildContext -Recurse -Force
```

Creates a temporary build context, builds the image, verifies it, then removes the image and context.
The build command itself produces no PowerShell output; Get-DockerImage returns the image.
Captured output (temporary repository name redacted):
Repository : psdocker-example-...
Tag        : latest
Id         : sha256:6b12245d294980267796ce1828c74dfb0991ba46e412d372417b0ddc89d31652
Size       : 489MB

### EXAMPLE 2
```
$buildContext = Join-Path $env:TEMP "psdocker-example-$([guid]::NewGuid().ToString('N'))"
New-Item -Path $buildContext -ItemType Directory | Out-Null
New-DockerImage -Repository 'psdocker-example' -Path $buildContext -WhatIf
Remove-Item -Path $buildContext -Recurse -Force
```

Shows the build operation without building an image, then removes the temporary context.
Captured output:
What if: Performing the operation "Build Docker image" on target "psdocker-example:latest".

## PARAMETERS

### -Repository
Specifies the repository name for the image to build.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tag
Specifies the tag to apply to the image.
Defaults to 'latest'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Latest
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Specifies the directory containing the Dockerfile and build context.

```yaml
Type: DirectoryInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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

[https://abbgrade.github.io/psdocker/docs/New-DockerImage.html](https://abbgrade.github.io/psdocker/docs/New-DockerImage.html)

[https://docs.docker.com/engine/reference/commandline/build/](https://docs.docker.com/engine/reference/commandline/build/)

