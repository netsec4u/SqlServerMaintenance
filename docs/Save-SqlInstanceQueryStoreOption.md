---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Save-SqlInstanceQueryStoreOption
---

# Save-SqlInstanceQueryStoreOption

## SYNOPSIS

Save query store statistics on all databases or a specified database.

## SYNTAX

### ServerInstance (Default)

```
Save-SqlInstanceQueryStoreOption
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

### SmoServerObject

```
Save-SqlInstanceQueryStoreOption
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Save query store statistics on all databases or a specified database.

## EXAMPLES

### Example 1

```powershell
Save-SqlInstanceQueryStoreOption -ServerInstance .
```

Save query store options for all databases on SQL instance.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Save-SqlInstanceQueryStoreOption -SmoServerObject $SmoServer
```

Save query store options for all databases using the specified Smo session.

### Example 3

```powershell
Save-SqlInstanceQueryStoreOption -ServerInstance . -DatabaseName AdventureWorks
```

Save query store options for AdventureWorks database.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to store query store options.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void



## NOTES

Query Store cannot be enabled for the master or tempdb databases.


## RELATED LINKS

None.

