---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-SqlInstanceLogFileVLFCount

## SYNOPSIS
Evaluates virtual log file (VLF) count.

## SYNTAX

### ServerInstance (Default)
```
Get-SqlInstanceLogFileVLFCount
	-ServerInstance <String>
	[-DatabaseName <String>]
	[-VLFCountThreshold <Int32>]
	[<CommonParameters>]
```

### SmoServerObject
```
Get-SqlInstanceLogFileVLFCount
	-SmoServerObject <Server>
	[-DatabaseName <String>]
	[-VLFCountThreshold <Int32>]
	[<CommonParameters>]
```

## DESCRIPTION
Evaluates virtual log file (VLF) count.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SqlInstanceLogFileVLFCount -ServerInstance .
```

Get virtual log file (VLF) count for all databases on SQL instance.

### EXAMPLE 2
```powershell
Get-SqlInstanceLogFileVLFCount -ServerInstance . -DatabaseName AdventureWorks
```

Get virtual log file (VLF) count for database AdventureWorks

### EXAMPLE 3
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlInstanceLogFileVLFCount -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Get virtual log file (VLF) count for database AdventureWorks using the specified Smo session.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to evaluate log file growth rate.

```yaml
Type: String
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

### -VLFCountThreshold
VLF count threshold.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### SqlServerMaintenance.SqlLogFileVLFCount

## NOTES
1 VLF	When growth rate is less than 1/8 total log size
4 VLF	When growth rate is greater than 1/8 total log size and growth less than 64MB
8 VLF	When growth rate is greater than 1/8 total log size and growth less than 1GB
16 VLF	When growth rate is greater than 1/8 total log size and growth greater than 1GB

Growth rate should not be greater than 64GB

## RELATED LINKS
