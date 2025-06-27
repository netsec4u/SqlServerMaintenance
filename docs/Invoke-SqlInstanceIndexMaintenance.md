---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-SqlInstanceIndexMaintenance

## SYNOPSIS
Perform index maintenance.

## SYNTAX

### ServerInstance (Default)
```
Invoke-SqlInstanceIndexMaintenance
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-RowCountThreshold <Int32>]
	[-IndexEvalMethod <IndexEvalMethod>]
	[-PageSpaceUsedThreshold <Int32>]
	[-ReorganizeThreshold <Int32>]
	[-RebuildThreshold <Int32>]
	[-Online]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Invoke-SqlInstanceIndexMaintenance
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-RowCountThreshold <Int32>]
	[-IndexEvalMethod <IndexEvalMethod>]
	[-PageSpaceUsedThreshold <Int32>]
	[-ReorganizeThreshold <Int32>]
	[-RebuildThreshold <Int32>]
	[-Online]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Perform index maintenance on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlInstanceIndexMaintenance -ServerInstance .
```

Performs index maintenance against all database on local server.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Invoke-SqlInstanceIndexMaintenance -SmoServerObject $SmoServer
```

Performs index maintenance against all database using the specified Smo session.

### EXAMPLE 3
```powershell
Invoke-SqlInstanceIndexMaintenance -ServerInstance . -Database AdventureWorks
```

Performs index maintenance against database AdventureWorks on local server.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to perform index maintenance.

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

### -IndexEvalMethod
Specifies the index evaluation method for index maintenance.

```yaml
Type: IndexEvalMethod
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PageSpaceUsed
Accept pipeline input: False
Accept wildcard characters: False
```

### -Online
Specifies that an index or an index partition of an underlying table can be rebuilt online.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSpaceUsedThreshold
Specifies the page space used threshold to perform rebuild.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

### -RebuildThreshold
Specifies the average fragmentation level to perform a rebuild.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReorganizeThreshold
Specifies the average fragmentation level to perform a reorganize.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowCountThreshold
Specifies the number of row in a table to evaluate index fragmentation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1024
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
Reorganize will not occur when:
	- Primary key column contains unique identifier column and does not contain a LOB datatype.
	- Page lock is off.

Clustered Indexes
	For GUIDs, fill factor should be:
		90% for table larger than 10GB
		Use 70 or 80 for smaller tables
	For integer based key
		Use 100% fill factor

To return page density to fill factor, a rebuild must be performed.
	Reorg must be performed to compress LOBs ???
Verify

## RELATED LINKS
