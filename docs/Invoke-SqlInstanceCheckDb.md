---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-SqlInstanceCheckDb

## SYNOPSIS
Perform CheckDb.

## SYNTAX

### ServerInstance (Default)
```
Invoke-SqlInstanceCheckDb
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-MaxDOP <Int32>]
	[-PhysicalOnlyThreshold <Int32>]
	[-NoIndex]
	[-EstimateOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Invoke-SqlInstanceCheckDb
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-MaxDOP <Int32>]
	[-PhysicalOnlyThreshold <Int32>]
	[-NoIndex]
	[-EstimateOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Perform CheckDb on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlInstanceCheckDb -ServerInstance .
```

Performs CheckDB against all database on local server.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Invoke-SqlInstanceCheckDb -SmoServerObject $SmoServer
```

Performs CheckDB against all database using the specified Smo session.

### EXAMPLE 3
```powershell
Invoke-SqlInstanceCheckDb -ServerInstance . -Database AdventureWorks
```

Performs CheckDB against database AdventureWorks on local server.

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

### -EstimateOnly
Returns the estimated amount of tempdb space that is required to perform CHECKDB with all the other specified options.
The actual database check is not performed.

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

### -MaxDOP
Overrides the max degree of parallelism configuration option for the CheckDb.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoIndex
Specifies that intensive checks of nonclustered indexes for user tables will not be performed.

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

### -PhysicalOnlyThreshold
Specifies the threshold to perform a physical only check.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 51200
Accept pipeline input: False
Accept wildcard characters: False
```


### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target of the CheckDb operation.

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

### System.Data.DataRow

## NOTES

## RELATED LINKS
