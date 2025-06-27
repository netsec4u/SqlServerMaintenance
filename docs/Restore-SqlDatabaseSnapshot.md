---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Restore-SqlDatabaseSnapshot

## SYNOPSIS
Restore database to snapshot.

## SYNTAX

### ServerInstance (Default)
```
Restore-SqlDatabaseSnapshot
	-ServerInstance <String>
	-DatabaseSnapshotName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Restore-SqlDatabaseSnapshot
	-SmoServerObject <Server>
	-DatabaseSnapshotName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Restore database to snapshot.

## EXAMPLES

### Example 1
```powershell
Restore-SqlDatabaseSnapshot -ServerInstance MyServer -DatabaseSnapshotName AdventureWorksSnapshot
```

Restores database to snapshot AdventureWorksSnapshot.

### Example 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Restore-SqlDatabaseSnapshot -SmoServerObject $SmoServer -DatabaseSnapshotName AdventureWorksSnapshot
```

Restores database to snapshot AdventureWorksSnapshot using the specified Smo session.

## PARAMETERS

### -DatabaseSnapshotName
Specifies the name of the snapshot to restore.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### System.String

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS
