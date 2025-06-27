---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-SqlInstanceLogFileGrowthRate

## SYNOPSIS
Evaluates log file auto growth rate.

## SYNTAX

### ServerInstance (Default)
```
Get-SqlInstanceLogFileGrowthRate
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[-LogAutoGrowthThreshold <decimal>]
	[<CommonParameters>]
```

### SmoServerObject
```
Get-SqlInstanceLogFileGrowthRate
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[-LogAutoGrowthThreshold <decimal>]
	[<CommonParameters>]
```

## DESCRIPTION
Evaluates log file auto growth rate to alert when rate is less than 12.5% of log file size.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SqlInstanceLogFileGrowthRate -ServerInstance .
```

Get log file growth rate for all databases on SQL instance.

### EXAMPLE 2
```powershell
Get-SqlInstanceLogFileGrowthRate -ServerInstance . -DatabaseName AdventureWorks
```

Get log file growth rate for AdventureWorks database.

### EXAMPLE 3
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlInstanceLogFileGrowthRate -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Get log file growth rate for AdventureWorks database using the specified Smo session.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to evaluate log file growth rate.

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

### -LogAutoGrowthThreshold
Specifies the minimum threshold percentage for auto growth.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0.125
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### SqlServerMaintenance.SqlLogFileGrowth

## NOTES

## RELATED LINKS
