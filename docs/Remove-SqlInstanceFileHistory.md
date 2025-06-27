---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Remove-SqlInstanceFileHistory

## SYNOPSIS
Removes SQL file history older than retention period.

## SYNTAX

### ServerInstance
```
Remove-SqlInstanceFileHistory
	-ServerInstance <String>
	[-LogFileHistory <LogFileHistory[]>]
	[-RetentionInDays <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
Remove-SqlInstanceFileHistory
	-SmoServerObject <Server>
	[-LogFileHistory <LogFileHistory[]>]
	[-RetentionInDays <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Removes SQL file history older than retention period.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-SqlInstanceFileHistory -ServerInstance .
```

Removes SQL file History older than the default of 45 days for all files.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Remove-SqlInstanceFileHistory -SmoServerObject $SmoServer
```

Removes SQL file History older than 45 days for all files using the specified Smo session.

### EXAMPLE 3
```powershell
Remove-SqlInstanceFileHistory -ServerInstance . -LogHistory @(Dump, Trace)
```

Removes SQL file History older than the default of 45 days for Dump, and Trace.

## PARAMETERS

### -LogFileHistory
The name of log file to remove history.

```yaml
Type: LogFileHistory[]
Parameter Sets: (All)
Aliases:
Accepted values: AgentJobOutput, Dump, ExtendedEvent, Trace

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

### -SmoServerObject
Specifies SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: SmoServer
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
