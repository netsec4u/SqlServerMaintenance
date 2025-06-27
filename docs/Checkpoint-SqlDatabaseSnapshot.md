---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Checkpoint-SqlDatabaseSnapshot

## SYNOPSIS
Create database snapshot.

## SYNTAX

### ServerInstance (Default)
```
Checkpoint-SqlDatabaseSnapshot
	-ServerInstance <String>
	-DatabaseName <String>
	-DatabaseSnapshotName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Checkpoint-SqlDatabaseSnapshot
	-SmoServerObject <Server>
	-DatabaseName <String>
	-DatabaseSnapshotName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Create database snapshot.

## EXAMPLES

### Example 1
```powershell
Checkpoint-SqlDatabaseSnapshot -ServerInstance MyServer -DatabaseName AdventureWorks -DatabaseSnapshotName AdventureWorksSnapshot
```

Creates snapshot on database AdventureWorks called AdventureWorksSnapshot.

### Example 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Checkpoint-SqlDatabaseSnapshot -SmoServerObject $SmoServer -DatabaseName AdventureWorks -DatabaseSnapshotName AdventureWorksSnapshot
```

Creates snapshot on database AdventureWorks called AdventureWorksSnapshot.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to create snapshot.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseSnapshotName
Specifies the snapshot name to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

### SqlServerMaintenance.DatabaseSnapshot

## NOTES

## RELATED LINKS
