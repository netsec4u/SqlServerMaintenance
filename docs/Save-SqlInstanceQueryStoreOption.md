---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Save-SqlInstanceQueryStoreOption

## SYNOPSIS
Save query store statistics.

## SYNTAX

### ServerInstance (Default)
```
Save-SqlInstanceQueryStoreOption
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

### SmoServerObject
```
Save-SqlInstanceQueryStoreOption
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

## DESCRIPTION
Save query store statistics on all databases or a specified database.

## EXAMPLES

### EXAMPLE 1
```powershell
Save-SqlInstanceQueryStoreOption -ServerInstance .
```

Save query store options for all databases on SQL instance.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Save-SqlInstanceQueryStoreOption -SmoServerObject $SmoServer
```

Save query store options for all databases using the specified Smo session.

### EXAMPLE 3
```powershell
Save-SqlInstanceQueryStoreOption -ServerInstance . -DatabaseName AdventureWorks
```

Save query store options for AdventureWorks database.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to store query store options.

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
This server instance becomes the target of saving query store options.

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

### System.Void

## NOTES
Query Store cannot be enabled for the master or tempdb databases.

## RELATED LINKS
