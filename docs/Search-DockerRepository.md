---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version: https://docs.docker.com/engine/reference/commandline/search/
schema: 2.0.0
---

# Search-DockerRepository

## SYNOPSIS
Search the Docker Hub for repositories

## SYNTAX

```
Search-DockerRepository [-Term] <String> [-Limit] <Int32> [[-Timeout] <Int32>] [-IsAutomated] [-IsOfficial]
 [[-MinimumStars] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Wraps the command \`docker search\`.

## EXAMPLES

### BEISPIEL 1
```
Search-DockerRepository 'nanoserver' -Limit 2
```

Name        : microsoft/nanoserver
Description : The official Nano Server base image
Stars       : 479
IsAutomated : False
IsOfficial  : False

Name        : nanoserver/iis
Description : Nano Server + IIS.
Updated on 08/21/2018 -- Version: 10.0.14393.2312
Stars       : 42
IsAutomated : False
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
Accept pipeline input: True (ByPropertyName)
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
Default value: 30
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IsAutomated
Returns only repositories with automated build.

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

### -IsOfficial
Returns only official repositories.

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

### -MinimumStars
{{Fill MinimumStars Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Repository: Returns objects of type `Repository` that has the following properties:
### - Name
### - Description
### - Stars
### - IsAutomated
### - IsOfficial
## NOTES

## RELATED LINKS

[https://docs.docker.com/engine/reference/commandline/search/](https://docs.docker.com/engine/reference/commandline/search/)

