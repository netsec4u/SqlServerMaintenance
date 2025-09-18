---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Find-OrphanedDatabasePhysicalFile
---

# Find-OrphanedDatabasePhysicalFile

## SYNOPSIS

Finds database files that are currently not associated with any attached database.

## SYNTAX

### ServerInstance (Default)

```
Find-OrphanedDatabasePhysicalFile
  -ServerInstance <string>
  [<CommonParameters>]
```

### SmoServerObject

```
Find-OrphanedDatabasePhysicalFile
  -SmoServerObject <Server>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Finds database files that are currently not associated with any attached database.

## EXAMPLES

### Example 1

Find-OrphanedDatabasePhysicalFile -ServerInstance MySqlServer

Finds the orphaned database files on SQL instance MySqlServer.

### Example 2

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Find-OrphanedDatabasePhysicalFile -SmoServerObject $SmoServer

Finds the orphaned database files using SmoServer object.

## PARAMETERS

### -ServerInstance

SQL Server host name and instance name.

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

Specifies SQL Server Management Object.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SqlServerMaintenance.OrphanedDatabasePhysicalFile



## NOTES




## RELATED LINKS

None.

