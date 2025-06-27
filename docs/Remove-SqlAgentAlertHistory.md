---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Remove-SqlAgentAlertHistory

## SYNOPSIS
Remove SQL Agent alert history.

## SYNTAX

### ServerInstance (Default)
```
Remove-SqlAgentAlertHistory
	-ServerInstance <String>
	[-Retention <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlConnection
```
Remove-SqlAgentAlertHistory
	-SqlConnection <SqlConnection>
	[-Retention <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove SQL Agent alert history beyond retention period.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-SqlAgentAlertHistory -ServerInstance .
```

Remove SQL Agent Alert history for sql instance.

### EXAMPLE 2
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Remove-SqlAgentAlertHistory -SqlConnection $SqlConnection
```

Remove SQL Agent Alert history using the specified Sql connection.

## PARAMETERS

### -Retention
Specifies the number of days to retain.

```yaml
Type: Int32
Parameter Sets: (All)
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
