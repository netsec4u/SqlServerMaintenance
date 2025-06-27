---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Remove-DbTest

## SYNOPSIS
Remove database test.

## SYNTAX

### Default-ServerInstance (Default)
```
Remove-DbTest
	-ServerInstance <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### NamedTest-ServerInstance
```
Remove-DbTest
	-ServerInstance <String>
	-TestName <DbTest>
	[-Retention <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### NamedTest-SqlConnection
```
Remove-DbTest
	-SqlConnection <SqlConnection>
	-TestName <DbTest>
	[-Retention <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### Default-SqlConnection
```
Remove-DbTest
	-SqlConnection <SqlConnection>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove database test from tests table.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-DbTest -ServerInstance .
```

Remove database tests older than retention period.

### EXAMPLE 2
```powershell
Remove-DbTest -ServerInstance . -TestName Backup
```

Remove Backup tests older than retention period.

### EXAMPLE 3
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Remove-DbTest -SqlConnection $SqlConnection -TestName Backup
```

Remove Backup tests older than retention period using the specified Sql connection.

## PARAMETERS

### -Retention
Specifies the number of days to retain.

```yaml
Type: Int32
Parameter Sets: NamedTest-ServerInstance, NamedTest-SqlConnection
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target of the index maintenance operation.

```yaml
Type: String
Parameter Sets: Default-ServerInstance, NamedTest-ServerInstance
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
Parameter Sets: NamedTest-SqlConnection, Default-SqlConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestName
Specifies the name of the test to remove.

```yaml
Type: DbTest
Parameter Sets: NamedTest-ServerInstance, NamedTest-SqlConnection
Aliases:
Accepted values: Backup

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
