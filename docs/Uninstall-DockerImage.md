---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Uninstall-DockerImage.html
schema: 2.0.0
---

# Uninstall-DockerImage

## SYNOPSIS
Remove a Docker image.

## SYNTAX

```
Uninstall-DockerImage [[-Name] <String>] [-Force] [-NoPrune] [[-Timeout] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a local image, optionally forcing removal or preventing removal of
untagged parent images.
Supports -WhatIf and -Confirm.

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
    Uninstall-DockerImage -Force
Remove-Item -Path $buildContext -Recurse -Force
```

Builds a uniquely named temporary image, then removes it through the pipeline.
Captured output:
No output.
The image is removed.

## PARAMETERS

### -Name
Specifies the name of the image to be removed.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Image, ImageName

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Removes the image even if a container is using it.

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

### -NoPrune
Prevents removal of untagged parent images.

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

### -Timeout
Specifies how long to wait for the command to finish.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[https://abbgrade.github.io/psdocker/docs/Uninstall-DockerImage.html](https://abbgrade.github.io/psdocker/docs/Uninstall-DockerImage.html)

[https://docs.docker.com/engine/reference/commandline/image_rm/](https://docs.docker.com/engine/reference/commandline/image_rm/)

