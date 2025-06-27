---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-SqlInstanceColumnStoreMaintenance

## SYNOPSIS
Perform column store index maintenance.

## SYNTAX

### ServerInstance (Default)
```
Invoke-SqlInstanceColumnStoreMaintenance
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-DeletedRowsPercent <Int32>]
	[-RowGroupQuality <Int32>]
	[-PercentageRowGroupQuality <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Invoke-SqlInstanceColumnStoreMaintenance
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-DeletedRowsPercent <Int32>]
	[-RowGroupQuality <Int32>]
	[-PercentageRowGroupQuality <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Perform column store index maintenance on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlInstanceColumnStoreMaintenance -ServerInstance .
```

Performs column store index maintenance against all database on local server.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Invoke-SqlInstanceColumnStoreMaintenance -SmoServerObject $SmoServer
```

Performs column store index maintenance against all database using the specified Smo session.

### EXAMPLE 3
```powershell
Invoke-SqlInstanceColumnStoreMaintenance -ServerInstance . -Database AdventureWorks
```

Performs column store index maintenance against database AdventureWorks on local server.

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

### -DeletedRowsPercent
Threshold for percentage of deleted rows within a partition within a row group.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -PercentageRowGroupQuality
The percentage threshold to rebuild column store index.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowGroupQuality
The threshold for when the number of rows within a row group is less than this value to consider rebuilding column store.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 500000
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target of the index maintenance operation.

```yaml
Type: String
Parameter Sets: ServerInstance
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
Parameter Sets: SmoServerObject
Aliases:

Required: True
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

### SqlServerMaintenance.Index

## NOTES
https://techcommunity.microsoft.com/t5/DataCAT/SQL-2014-Clustered-Columnstore-index-rebuild-and-maintenance/ba-p/305244

Need to implement reorganize
Reorganize should be done after large data load
ALTER INDEX CCI_fact_order_BIG_CCI ON dbo.fact_order_BIG_CCI
REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON);

## RELATED LINKS
