---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-SqlInstanceStatisticsMaintenance
---

# Invoke-SqlInstanceStatisticsMaintenance

## SYNOPSIS

Perform table statistics maintenance on all databases or a specified database.

## SYNTAX

### Default-ServerInstance (Default)

```
Invoke-SqlInstanceStatisticsMaintenance
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [-StatisticsScanType <StatisticsScanType>]
	[-StatisticsSample <Int64>]
	[-Persist]
  [-MaxDop <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### StaticThreshold-ServerInstance

```
Invoke-SqlInstanceStatisticsMaintenance
  -ServerInstance <string>
  -RowCountThreshold <int>
  -ModificationCountThreshold <int>
  [-DatabaseName <string[]>]
  [-StatisticsScanType <StatisticsScanType>]
  [-MaxDop <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### StaticThreshold-SmoServerObject

```
Invoke-SqlInstanceStatisticsMaintenance
  -SmoServerObject <Server>
  -RowCountThreshold <int>
  -ModificationCountThreshold <int>
  [-DatabaseName <string[]>]
  [-StatisticsScanType <StatisticsScanType>]
  [-MaxDop <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### Default-SmoServerObject

```
Invoke-SqlInstanceStatisticsMaintenance
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [-StatisticsScanType <StatisticsScanType>]
	[-StatisticsSample <Int64>]
	[-Persist]
  [-MaxDop <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Perform table statistics maintenance on all databases or a specified database.

## EXAMPLES

### Example 1

```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance .
```

Performs table statistics maintenance against all database on local server based on dynamic threshold.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Invoke-SqlInstanceStatisticsMaintenance -SmoServerObject $SmoServer
```

Performs table statistics maintenance against all database using specified Smo session.

### Example 3

```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks
```

Performs table statistics maintenance against database AdventureWorks on local server based on dynamic threshold.

### Example 4

```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -RowCountThreshold 1024 -ModificationCountThreshold 100
```

Use static threshold where statics with a row count more than 1024 rows and 100 rows modified.

### Example 5

```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -StatisticsScanType Percent -StatisticsSample 50
```

Performs table statistics maintenance against database AdventureWorks on local server based on dynamic threshold with 50 percent sampling.

### Example 6

```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -StatisticsScanType Rows -StatisticsSample 1000 -RowCountThreshold 1024 -ModificationCountThreshold 100
```

Performs table statistics maintenance against database AdventureWorks on local server based on static threshold with row sampling of 1000 rows.

### Example 7

```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -StatisticsScanType FullScan -Persist
```

Performs table statistics maintenance against database AdventureWorks on local server to perform full scan and to persist.

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

### -MaxDop

Overrides the max degree of parallelism configuration option for the duration of the statistic operation.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -ModificationCountThreshold

Specifies modification count threshold for updating statistics.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: StaticThreshold-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: StaticThreshold-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Persist

Persist sample percentage for statistics.
Parameter is available when StatisticsScanType is FullScan, Percent, or Rows.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default-ServerInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RowCountThreshold

Specifies row count threshold for updating statistics.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: StaticThreshold-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: StaticThreshold-ServerInstance
  Position: Named
  IsRequired: true
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
- Name: StaticThreshold-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-ServerInstance
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
- Name: StaticThreshold-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StatisticsSample

Specifies the approximate percentage or number of rows in the table or indexed view for the query optimizer to use when it updates statistics.
Parameter is available when StatisticsScanType is Percent or Rows.

```yaml
Type: System.Int64
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-ServerInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StatisticsScanType

Specifies statistics scan type.

```yaml
Type: Microsoft.SqlServer.Management.Smo.StatisticsScanType
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

### System.Void



## NOTES

Need partition implementation.

Statistics recompilation threshold where n is the number of rows:
	- \< 500 rows	-	500
	- \> 500 rows	-	MIN( 500 + (0.20 * n), SQRT(1,000 * n))

Sample Rate
	- \< 1024 pages	lesser of total pages and (15*power(Rows,0.55)/TotalRows*TotalPages)+1024
	- \> 1024 pages	(15*power(Rows,0.55)/TotalRows*TotalPages)+1024


## RELATED LINKS

None.

