---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-SqlInstanceDataFileUsage

## SYNOPSIS
Gets data file usage.

## SYNTAX

### ServerInstance (Default)
```
Get-SqlInstanceDataFileUsage
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-FreeSpaceThreshold <Int32>]
	[-MinimumSamples <Int32>]
	[-StatisticPeriod <Int32>]
	[-ProjectionPeriod <Int32>]
	[-MinimumFileGrowth <Int32>]
	[-ReliabilityThreshold <Decimal>]
	[<CommonParameters>]
```

### SmoServerObject
```
Get-SqlInstanceDataFileUsage
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-FreeSpaceThreshold <Int32>]
	[-MinimumSamples <Int32>]
	[-StatisticPeriod <Int32>]
	[-ProjectionPeriod <Int32>]
	[-MinimumFileGrowth <Int32>]
	[-ReliabilityThreshold <Decimal>]
	[<CommonParameters>]
```

## DESCRIPTION
Gets data file usage on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SqlInstanceDataFileUsage -ServerInstance .
```

Get data file usage for all databases.

### EXAMPLE 2
```powershell
Get-SqlInstanceDataFileUsage -ServerInstance . -DatabaseName AdventureWorks
```

Get data file usage for AdventureWorks database.

### EXAMPLE 3
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlInstanceDataFileUsage -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Get data file usage for AdventureWorks database using the specified Smo session.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to gather data file usage.

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
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinimumFileGrowth
Specifies the minimum file growth in MB.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 64
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinimumSamples
Specifies the minimum number of samples to project growth.

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

### -ProjectionPeriod
Specifies the number of days to project growth.

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

### -ReliabilityThreshold
Specifies the threshold for automatically growing logical file.

```yaml
Type: Decimal
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0.85
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.

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

### -StatisticPeriod
Specified number of days of statistics used to calculate growth rate.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### SqlServerMaintenance.SqlDataFileUsage

## NOTES

## RELATED LINKS
