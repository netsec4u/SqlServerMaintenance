---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-SqlInstanceFullTextIndexMaintenance

## SYNOPSIS
Perform full text index maintenance.

## SYNTAX

### ServerInstance (Default)
```
Invoke-SqlInstanceFullTextIndexMaintenance
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-IndexSizeThreshold <Int32>]
	[-FragmentationThreshold <Int32>]
	[-FragmentSizeThreshold <Int32>]
	[-FragmentCountThreshold <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Invoke-SqlInstanceFullTextIndexMaintenance
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-IndexSizeThreshold <Int32>]
	[-FragmentationThreshold <Int32>]
	[-FragmentSizeThreshold <Int32>]
	[-FragmentCountThreshold <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Perform full text index maintenance on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlInstanceFullTextIndexMaintenance -ServerInstance .
```

Performs full text index maintenance against all database on local server.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Invoke-SqlInstanceFullTextIndexMaintenance -SmoServerObject $SmoServer
```

Performs full text index maintenance against all database using the specified Smo session.

### EXAMPLE 3
```powershell
Invoke-SqlInstanceFullTextIndexMaintenance -ServerInstance . -Database AdventureWorks
```

Performs full text index maintenance against database AdventureWorks on local server.

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

### -FragmentationThreshold
Specifies the fragmentation level to perform index maintenance.

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

### -FragmentCountThreshold
Specifies the number of fragments to perform index maintenance.

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

### -FragmentSizeThreshold
Specifies the total size of fragments to perform index maintenance.

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

### -IndexSizeThreshold
Specifies the size in MB of full text index to evaluate index fragmentation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
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

### SqlServerMaintenance.FullTextIndex

## NOTES

## RELATED LINKS
