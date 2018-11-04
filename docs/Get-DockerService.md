---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version:
schema: 2.0.0
---

# Get-DockerService

## SYNOPSIS

## SYNTAX

```
Get-DockerService [-ContainerName] <String> [-Name] <String> [-PowershellCore] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### BEISPIEL 1
```
$container = New-DockerContainer -Image 'microsoft/iis' -Detach
```

C:\\\> Get-DockerService -ContainerName $container.Name -Name 'W3SVC'
 Status Name  DisplayName
 ------ ----  -----------
Running W3SVC World Wide Web Publishing Service

## PARAMETERS

### -ContainerName
{{Fill ContainerName Description}}

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

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PowershellCore
\[Parameter(Mandatory=$false)\]
\[switch\]
$PowershellClassic = $false

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
