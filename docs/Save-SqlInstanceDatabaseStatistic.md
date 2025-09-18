---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Save-SqlInstanceDatabaseStatistic
---

# Save-SqlInstanceDatabaseStatistic

## SYNOPSIS

Save database statistics on all databases or a specified database.

## SYNTAX

### ServerInstance (Default)

```
Save-SqlInstanceDatabaseStatistic
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

### SmoServerObject

```
Save-SqlInstanceDatabaseStatistic
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Save database statistics on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1

Save-SqlInstanceDatabaseStatistic -ServerInstance .

Save database statistics for all database on SQL instance.

### EXAMPLE 2

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Save-SqlInstanceDatabaseStatistic -SmoServerObject $SmoServer

Save database statistics for all database on SQL instance using the specified Smo session.

### EXAMPLE 3

Save-SqlInstanceDatabaseStatistic -ServerInstance . -DatabaseName AdventureWorks

Save database statistics for AdventureWorks database.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to save database statistics.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

Specifies the name of a SQL Server instance.
This server instance becomes the target of saving database statistics.

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

### System.Void



## NOTES




## RELATED LINKS

None.

