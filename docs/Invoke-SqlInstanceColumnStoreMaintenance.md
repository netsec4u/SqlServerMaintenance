---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-SqlInstanceColumnStoreMaintenance
---

# Invoke-SqlInstanceColumnStoreMaintenance

## SYNOPSIS

Perform column store index maintenance on all databases or a specified database.

## SYNTAX

### ServerInstance (Default)

```
Invoke-SqlInstanceColumnStoreMaintenance
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [-DeletedRowsPercent <int>]
  [-RowGroupQuality <int>]
  [-PercentageRowGroupQuality <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServerObject

```
Invoke-SqlInstanceColumnStoreMaintenance
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [-DeletedRowsPercent <int>]
  [-RowGroupQuality <int>]
  [-PercentageRowGroupQuality <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Perform column store index maintenance on all databases or a specified database.

## EXAMPLES

### Example 1

```powershell
Invoke-SqlInstanceColumnStoreMaintenance -ServerInstance .
```

Performs column store index maintenance against all database on local server.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Invoke-SqlInstanceColumnStoreMaintenance -SmoServerObject $SmoServer
```

Performs column store index maintenance against all database using the specified Smo session.

### Example 3

```powershell
Invoke-SqlInstanceColumnStoreMaintenance -ServerInstance . -Database AdventureWorks
```

Performs column store index maintenance against database AdventureWorks on local server.

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

### -DeletedRowsPercent

Threshold for percentage of deleted rows within a partition within a row group.

```yaml
Type: System.Int32
DefaultValue: 10
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

### -PercentageRowGroupQuality

The percentage threshold to rebuild column store index.

```yaml
Type: System.Int32
DefaultValue: 20
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

### -RowGroupQuality

The threshold for when the number of rows within a row group is less than this value to consider rebuilding column store.

```yaml
Type: System.Int32
DefaultValue: 500000
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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### SqlServerMaintenance.Index



## NOTES

https://techcommunity.microsoft.com/t5/DataCAT/SQL-2014-Clustered-Columnstore-index-rebuild-and-maintenance/ba-p/305244

Need to implement reorganize Reorganize should be done after large data load ALTER INDEX CCI_fact_order_BIG_CCI ON dbo.fact_order_BIG_CCI REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON);


## RELATED LINKS

None.

