---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version:
schema: 2.0.0
---

# Search-DockerImage

## SYNOPSIS
Search the Docker Hub for images

## SYNTAX

```
Search-DockerImage [-Term] <String> [-Limit] <Int32> [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Wraps the command \[docker search\](https://docs.docker.com/engine/reference/commandline/search/).

## EXAMPLES

### BEISPIEL 1
```
Search-DockerImage 'nanoserver' -Limit 2
```

IsAutomated : False
Description :
Name        : microsoft/nanoserver
Stars       : 431
IsOfficial  : False

IsAutomated : False
Description : Nano Server + IIS.
Updated on 08/21/2018 -- â€¦
Name        : nanoserver/iis
Stars       : 35
IsOfficial  : False

## PARAMETERS

### -Term
Specifies the search term.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Specifies the maximum number of results.
If the limit is $null or 0 the docker default (25) is used instead.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
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
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
