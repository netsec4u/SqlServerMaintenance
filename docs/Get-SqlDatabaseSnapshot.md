---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-SqlDatabaseSnapshot

## SYNOPSIS
Lists database snapshots.

## SYNTAX

### ServerInstance (Default)
```
Get-SqlDatabaseSnapshot
	-ServerInstance <String>
	[-DatabaseName <String>]
	[-DatabaseSnapshotName <String>]
	[<CommonParameters>]
```

### SmoServerObject
```
Get-SqlDatabaseSnapshot
	-SmoServerObject <Server>
	[-DatabaseName <String>]
	[-DatabaseSnapshotName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Lists database snapshots.

## EXAMPLES

### Example 1
```powershell
Get-SqlDatabaseSnapshot -ServerInstance MyServer
```

Lists all snapshots on server MyServer.

### Example 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlDatabaseSnapshot -SmoServerObject $SmoServer
```

Lists all snapshots using the specified Smo session.

### Example 3
```powershell
Get-SqlDatabaseSnapshot -ServerInstance MyServer -DatabaseName AdventureWorks
```

Lists all snapshots on database AdventureWorks.

### Example 4
```powershell
Get-SqlDatabaseSnapshot -ServerInstance MyServer -DatabaseSnapshotName AdventureWorksSnapshot
```

Lists all snapshot AdventureWorksSnapshot.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to gather snapshots.

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

### -DatabaseSnapshotName
Specifies the name of the snapshot.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### SqlServerMaintenance.DatabaseSnapshot

## NOTES

## RELATED LINKS
