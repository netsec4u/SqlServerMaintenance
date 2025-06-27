---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Remove-DbStatistic

## SYNOPSIS
Remove database statistic.

## SYNTAX

### Default-ServerInstance (Default)
```
Remove-DbStatistic
	-ServerInstance <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### NamedStatistic-ServerInstance
```
Remove-DbStatistic
	-ServerInstance <String>
	-StatisticsName <DbStatistic>
	[-Retention <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### NamedStatistic-SqlConnection
```
Remove-DbStatistic
	-SqlConnection <SqlConnection>
	-StatisticsName <DbStatistic>
	[-Retention <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### Default-SqlConnection
```
Remove-DbStatistic
	-SqlConnection <SqlConnection>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove database statistic from statistics table.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-DbStatistic -ServerInstance .
```

Remove statistics older than retention period.

### EXAMPLE 2
```powershell
Remove-DbStatistic -ServerInstance . -StatisticsName Database
```

Remove Database database statistics older than retention period.

### EXAMPLE 3
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Remove-DbStatistic -SqlConnection $SqlConnection -StatisticsName Database
```

Remove Database database statistics older than retention period using specified Sql connection.

## PARAMETERS

### -Retention
Specifies the number of days to retain.

```yaml
Type: Int32
Parameter Sets: NamedStatistic-ServerInstance, NamedStatistic-SqlConnection
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.

```yaml
Type: String
Parameter Sets: Default-ServerInstance, NamedStatistic-ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlConnection
Specifies SQL connection object.

```yaml
Type: SqlConnection
Parameter Sets: NamedStatistic-SqlConnection, Default-SqlConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatisticsName
Specifies the name of the statistics to remove.

```yaml
Type: DbStatistic
Parameter Sets: NamedStatistic-ServerInstance, NamedStatistic-SqlConnection
Aliases:
Accepted values: Backup, ColumnStore, Database, FullTextIndex, Index, QueryStore, TableStatistics

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

### System.Void

## NOTES

## RELATED LINKS
