---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-SqlInstanceStatisticsMaintenance

## SYNOPSIS
Perform table statistics maintenance.

## SYNTAX

### Default-ServerInstance (Default)
```
Invoke-SqlInstanceStatisticsMaintenance
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-StatisticsScanType <StatisticsScanType>]
	[-StatisticsSample <Int64>]
	[-Persist]
	[-MaxDop <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### StaticThreshold-ServerInstance
```
Invoke-SqlInstanceStatisticsMaintenance
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-StatisticsScanType <StatisticsScanType>]
	-RowCountThreshold <Int32>
	-ModificationCountThreshold <Int32>
	[-MaxDop <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### StaticThreshold-SmoServerObject
```
Invoke-SqlInstanceStatisticsMaintenance
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-StatisticsScanType <StatisticsScanType>]
	-RowCountThreshold <Int32>
	-ModificationCountThreshold <Int32>
	[-MaxDop <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### Default-SmoServerObject
```
Invoke-SqlInstanceStatisticsMaintenance
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-StatisticsScanType <StatisticsScanType>]
	[-StatisticsSample <Int64>]
	[-Persist]
	[-MaxDop <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Perform table statistics maintenance on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance .
```

Performs table statistics maintenance against all database on local server based on dynamic threshold.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Invoke-SqlInstanceStatisticsMaintenance -SmoServerObject $SmoServer
```

Performs table statistics maintenance against all database using specified Smo session.

### EXAMPLE 3
```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks
```

Performs table statistics maintenance against database AdventureWorks on local server based on dynamic threshold.

### EXAMPLE 4
```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -RowCountThreshold 1024 -ModificationCountThreshold 100
```

Use static threshold where statics with a row count more than 1024 rows and 100 rows modified.

### EXAMPLE 5
```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -StatisticsScanType Percent -StatisticsSample 50
```

Performs table statistics maintenance against database AdventureWorks on local server based on dynamic threshold with 50 percent sampling.

### EXAMPLE 6
```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -StatisticsScanType Rows -StatisticsSample 1000 -RowCountThreshold 1024 -ModificationCountThreshold 100
```

Performs table statistics maintenance against database AdventureWorks on local server based on static threshold with row sampling of 1000 rows.

### EXAMPLE 7
```powershell
Invoke-SqlInstanceStatisticsMaintenance -ServerInstance . -Database AdventureWorks -StatisticsScanType FullScan -Persist
```

Performs table statistics maintenance against database AdventureWorks on local server to perform full scan and to persist.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to back up.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxDop
Overrides the max degree of parallelism configuration option for the duration of the statistic operation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModificationCountThreshold
Specifies modification count threshold for updating statistics.

```yaml
Type: Int32
Parameter Sets: StaticThreshold-ServerInstance, StaticThreshold-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Persist
Persist sample percentage for statistics.
Parameter is available when StatisticsScanType is FullScan, Percent, or Rows.

```yaml
Type: SwitchParameter
Parameter Sets: Default-ServerInstance, Default-SmoServerObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowCountThreshold
Specifies row count threshold for updating statistics.

```yaml
Type: Int32
Parameter Sets: StaticThreshold-ServerInstance, StaticThreshold-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target of the statistics maintenance operation.

```yaml
Type: String
Parameter Sets: Default-ServerInstance, StaticThreshold-ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmoServerObject
Specifies SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: StaticThreshold-SmoServerObject, Default-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatisticsSample
Specifies the approximate percentage or number of rows in the table or indexed view for the query optimizer to use when it updates statistics.
Parameter is available when StatisticsScanType is Percent or Rows.

```yaml
Type: int64
Parameter Sets: Default-ServerInstance, Default-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatisticsScanType
Specifies statistics scan type.

```yaml
Type: StatisticsScanType
Parameter Sets: (All)
Aliases:
Accepted values: Percent, Rows, FullScan, Resample, Default

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Void

## NOTES
Need partition implementation.

Statistics recompilation threshold where n is the number of rows:
	\< 500 roes	-	500
	\> 500 rows	-	MIN( 500 + (0.20 * n), SQRT(1,000 * n))

Sample Rate
	\< 1024 pages	lesser of total pages and (15*power(Rows,0.55)/TotalRows*TotalPages)+1024
	\> 1024 pages	(15*power(Rows,0.55)/TotalRows*TotalPages)+1024

## RELATED LINKS
