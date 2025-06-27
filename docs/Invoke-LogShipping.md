---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-LogShipping

## SYNOPSIS
Perform Log Ship operation.

## SYNTAX

### ServerInstance (Default)
```
Invoke-LogShipping
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	-LSOperation <LSOperation>
	[-Session <PSSession>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlConnection
```
Invoke-LogShipping
	-SqlConnection <SqlConnection>
	[-DatabaseName <String[]>]
	-LSOperation <LSOperation>
	[-Session <PSSession>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Perform Log Ship backup, copy, or restore operation.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-LogShipping -ServerInstance . -LSOperation Backup
```

Performs log ship backup for all database on local server.

### EXAMPLE 2
```powershell
Invoke-LogShipping -ServerInstance . -DatabaseName AdventureWorks -LSOperation Backup
```

Performs log ship backup for database AdventureWorks on local server.

### EXAMPLE 3
```powershell
Invoke-LogShipping -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

Performs log ship backup for database AdventureWorks using the specified Sql connection.

### EXAMPLE 4
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Invoke-LogShipping -SqlConnection $SqlConnection -DatabaseName AdventureWorks -Session $PSSession
```

Performs log ship backup for database AdventureWorks using the specified Sql connection and execute within specified PSSession.

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

### -LSOperation
Specifies the log shipping operation to invoke.

```yaml
Type: LSOperation
Parameter Sets: (All)
Aliases:
Accepted values: Backup, Copy, Restore

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target of the backup operation.

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

### -Session
Specifies PS Session.

```yaml
Type: PSSession
Parameter Sets: (All)
Aliases:

Required: False
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

### System.Collections.Generic.List`1[[SqlServerMaintenance.SqlLogShip, ojgualwj.axe, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null]]

## NOTES

## RELATED LINKS
