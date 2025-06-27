---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Find-OrphanedDatabaseUser

## SYNOPSIS
Find orphaned database users.

## SYNTAX

### ServerInstance (Default)
```
Find-OrphanedDatabaseUser
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

### SmoServerObject
```
Find-OrphanedDatabaseUser
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

## DESCRIPTION
Find orphaned database users.

## EXAMPLES

### Example 1
```powershell
Find-OrphanedDatabaseUser -ServerInstance MyServer
```

Finds orphaned database users for databases on MyServer.

### Example 2
```powershell
Find-OrphanedDatabaseUser -ServerInstance MyServer -DatabaseName AdventureWorks
```

Finds orphaned database users on database AdventureWorks.

### Example 3
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Find-OrphanedDatabaseUser -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Finds orphaned database users on database AdventureWorks.

## PARAMETERS

### -DatabaseName
Specifies the name of the database.

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

### SqlServerMaintenance.OrphanedDatabaseUser

## NOTES

## RELATED LINKS
