---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
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

### Example 1

```powershell
Get-SqlInstanceQueryStoreUsage -ServerInstance .
```

Get query store usage for all databases  on SQL instance.

### Example 2

```powershell
Get-SqlInstanceQueryStoreUsage -ServerInstance . -DatabaseName AdventureWorks
```

Get query store usage for AdventureWorks database.

### Example 3

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Get-SqlInstanceQueryStoreUsage -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

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

### SqlServerMaintenance.SqlQueryStore



## NOTES




## RELATED LINKS

None.

