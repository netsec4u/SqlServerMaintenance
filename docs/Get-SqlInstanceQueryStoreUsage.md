---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-SqlInstanceQueryStoreUsage

## SYNOPSIS
Gets query store usage.

## SYNTAX

### ServerInstance (Default)
```
Get-SqlInstanceQueryStoreUsage
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-FreeSpaceThreshold <Int32>]
	[<CommonParameters>]
```

### SmoServerObject
```
Get-SqlInstanceQueryStoreUsage
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-FreeSpaceThreshold <Int32>]
	[<CommonParameters>]
```

## DESCRIPTION
Gets query store usage on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SqlInstanceQueryStoreUsage -ServerInstance .
```

Get query store usage for all databases  on SQL instance.

### EXAMPLE 2
```powershell
Get-SqlInstanceQueryStoreUsage -ServerInstance . -DatabaseName AdventureWorks
```

Get query store usage for AdventureWorks database.

### EXAMPLE 3
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlInstanceQueryStoreUsage -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Get query store usage for AdventureWorks database using the specified Smo session.

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

### -FreeSpaceThreshold
Specifies the free space threshold.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### SqlServerMaintenance.SqlQueryStore

## NOTES

## RELATED LINKS
