---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlServerMaintenanceConfiguration
---

# Get-SqlServerMaintenanceConfiguration

## SYNOPSIS

Get module configuration.

## SYNTAX

### __AllParameterSets

```
Get-SqlServerMaintenanceConfiguration
  -SettingName <SqlServerMaintenanceSetting>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Get module configuration.

## EXAMPLES

### EXAMPLE 1

Get-SqlServerMaintenanceConfiguration -SettingName SmtpSettings

Get module configuration for SmtpSettings.

## PARAMETERS

### -SettingName

Specifies setting to retrieve settings.

```yaml
Type: SqlServerMaintenanceSetting
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject



## NOTES




## RELATED LINKS

None.

