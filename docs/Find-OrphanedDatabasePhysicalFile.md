---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Find-OrphanedDatabasePhysicalFile

## SYNOPSIS
Finds database files that are currently not associated with any attached database.

## SYNTAX

### ServerInstance (Default)
```
Find-OrphanedDatabasePhysicalFile
	-ServerInstance <String>
	[<CommonParameters>]
```

### SmoServerObject
```
Find-OrphanedDatabasePhysicalFile
	-SmoServerObject <Server>
	[<CommonParameters>]
```

## DESCRIPTION
Finds database files that are currently not associated with any attached database.

## EXAMPLES

### Example 1
```powershell
Get-OrphanedDatabasePhysicalFile -ServerInstance MySqlServer
```

Finds the orphaned database files on SQL instance MySqlServer.

### Example 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-OrphanedDatabasePhysicalFile -SmoServerObject $SmoServer
```

Finds the orphaned database files using SmoServer object.

## PARAMETERS

### -ServerInstance
SQL Server host name and instance name.

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

### SqlServerMaintenance.OrphanedDatabasePhysicalFile

## NOTES

## RELATED LINKS
