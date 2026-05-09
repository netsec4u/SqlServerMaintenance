---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerMaintenance/blob/main/docs/Initialize-SqlServerMaintenanceDatabase.md
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 05/08/2026
PlatyPS schema version: 2024-05-01
title: Initialize-SqlServerMaintenanceDatabase
---

# Initialize-SqlServerMaintenanceDatabase

## SYNOPSIS

Creates supporting tables for various functions within the module.

## SYNTAX

### ServerInstance (Default)

```
Initialize-SqlServerMaintenanceDatabase
  -ServerInstance <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServerObject

```
Initialize-SqlServerMaintenanceDatabase
  -SmoServerObject <Server>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Creates supporting tables for various functions within the module.

## EXAMPLES

### Example 1

```powershell
Initialize-SqlServerMaintenanceDatabase -ServerInstance .
```

Creates supporting tables on local SQL Server instance.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Initialize-SqlServerMaintenanceDatabase -SmoServerObject $SmoServer
```

Creates supporting tables using the specified Smo session.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServerInstance

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SmoServerObject

An existing SMO Server object representing the SQL Server instance.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
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

### System.Void



## NOTES




## RELATED LINKS

