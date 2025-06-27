---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Remove-SqlInstanceHistory

## SYNOPSIS
Removes SQL instance history older than retention period.

## SYNTAX

### ServerInstance
```
Remove-SqlInstanceHistory
	-ServerInstance <String>
	[-LogHistory <LogHistory[]>]
	[-RetentionInDays <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlConnection
```
Remove-SqlInstanceHistory
	-SqlConnection <SqlConnection>
	[-LogHistory <LogHistory[]>]
	[-RetentionInDays <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Removes SQL instance history older than retention period.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-SqlInstanceHistory -ServerInstance .
```

Removes SQL Log History older than the default of 45 days for all logs.

### EXAMPLE 2
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Remove-SqlInstanceHistory -SqlConnection $SqlConnection
```

Removes SQL Log History older than the default of 45 days for all logs using the specified Sql connection.

### EXAMPLE 3
```powershell
Remove-SqlInstanceHistory -ServerInstance . -LogHistory @(AgentJob, Backup, DatabaseMail)
```

Removes SQL Log History older than 45 days for agent jobs, backup, and database mail logs.

## PARAMETERS

### -LogHistory
The name of log to remove history.

```yaml
Type: LogHistory[]
Parameter Sets: (All)
Aliases:
Accepted values: AgentJob, Backup, DatabaseMail, LogShipping, MaintenancePlan, MultiServerAdministration, PolicyBasedManagement

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetentionInDays
The number of days to retain logs.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 45
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

### -SqlConnection
Specifies SQL connection object.

```yaml
Type: SqlConnection
Parameter Sets: SqlConnection
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

### System.Void

## NOTES

## RELATED LINKS
