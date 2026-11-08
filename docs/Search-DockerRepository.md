---
external help file: psdocker-help.xml
Module Name: psdocker
online version: https://abbgrade.github.io/psdocker/docs/Search-DockerRepository.html
schema: 2.0.0
---

# Search-DockerRepository

## SYNOPSIS
Search Docker Hub repositories.

## SYNTAX

```
Search-DockerRepository [-Term] <String> [-Limit] <Int32> [[-Timeout] <Int32>] [-IsAutomated] [-IsOfficial]
 [[-MinimumStars] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Searches Docker Hub and returns repository details.
Results can be filtered by
official status, automated builds, and minimum star count.

## EXAMPLES

### EXAMPLE 1
```
# Prerequisites: Docker CLI is installed and can access Docker Hub.
Search-DockerRepository -Term 'hello-world' -Limit 5 -IsOfficial | Format-List
```

Searches for official repositories matching hello-world.
Captured output (search results and popularity values can change):
Name        : hello-world
Description : Hello World!
(an example of minimal Dockerization)
Stars       : 0
IsAutomated : False
IsOfficial  : True

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
If 0, Docker's default limit (25) is used.

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

### -IsAutomated
Returns only repositories with automated builds.

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

### -IsOfficial
Returns only official repositories.

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

### -MinimumStars
Returns only repositories with at least this many stars.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
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

### Repository: Returns objects of type `Repository` that has the following properties:
### - Name
### - Description
### - Stars
### - IsAutomated
### - IsOfficial
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/psdocker/docs/Search-DockerRepository.html](https://abbgrade.github.io/psdocker/docs/Search-DockerRepository.html)

[https://docs.docker.com/engine/reference/commandline/search/](https://docs.docker.com/engine/reference/commandline/search/)

