---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlInstanceQueryStoreUsage
---

# Get-SqlInstanceQueryStoreUsage

## SYNOPSIS

Gets query store usage on all databases or a specified database.

## SYNTAX

### ServerInstance (Default)

```
Get-SqlInstanceQueryStoreUsage
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [-FreeSpaceThreshold <int>]
  [<CommonParameters>]
```

### SmoServerObject

```
Get-SqlInstanceQueryStoreUsage
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [-FreeSpaceThreshold <int>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Gets query store usage on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1

Get-SqlInstanceQueryStoreUsage -ServerInstance .

Get query store usage for all databases  on SQL instance.

### EXAMPLE 2

Get-SqlInstanceQueryStoreUsage -ServerInstance . -DatabaseName AdventureWorks

Get query store usage for AdventureWorks database.

### EXAMPLE 3

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlInstanceQueryStoreUsage -SmoServerObject $SmoServer -DatabaseName AdventureWorks

Get query store usage for AdventureWorks database using the specified Smo session.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to back up.

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

### -FreeSpaceThreshold

Specifies the free space threshold.

```yaml
Type: System.Int32
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
This server instance becomes the target of the index maintenance operation.

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

### SqlServerMaintenance.SqlQueryStore



## NOTES




## RELATED LINKS

None.

