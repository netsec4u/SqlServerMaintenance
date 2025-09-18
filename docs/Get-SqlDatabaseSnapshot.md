---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlDatabaseSnapshot
---

# Get-SqlDatabaseSnapshot

## SYNOPSIS

Lists database snapshots.

## SYNTAX

### ServerInstance (Default)

```
Get-SqlDatabaseSnapshot
  -ServerInstance <string>
  [-DatabaseName <string>]
  [-DatabaseSnapshotName <string>]
  [<CommonParameters>]
```

### SmoServerObject

```
Get-SqlDatabaseSnapshot
  -SmoServerObject <Server>
  [-DatabaseName <string>]
  [-DatabaseSnapshotName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Lists database snapshots.

## EXAMPLES

### Example 1

Get-SqlDatabaseSnapshot -ServerInstance MyServer

Lists all snapshots on server MyServer.

### Example 2

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlDatabaseSnapshot -SmoServerObject $SmoServer

Lists all snapshots using the specified Smo session.

### Example 3

Get-SqlDatabaseSnapshot -ServerInstance MyServer -DatabaseName AdventureWorks

Lists all snapshots on database AdventureWorks.

### Example 4

Get-SqlDatabaseSnapshot -ServerInstance MyServer -DatabaseSnapshotName AdventureWorksSnapshot

Lists all snapshot AdventureWorksSnapshot.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to gather snapshots.

```yaml
Type: System.String
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

### -DatabaseSnapshotName

Specifies the name of the snapshot.

```yaml
Type: System.String
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

### SqlServerMaintenance.DatabaseSnapshot



## NOTES




## RELATED LINKS

None.

