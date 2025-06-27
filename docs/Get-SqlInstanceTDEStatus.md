---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-SqlInstanceTDEStatus

## SYNOPSIS
Get database TDE status information.

## SYNTAX

### ServerInstance (Default)
```
Get-SqlInstanceTDEStatus
	-ServerInstance <String>
	[-DatabaseName <String>]
	[<CommonParameters>]
```

### SqlConnection
```
Get-SqlInstanceTDEStatus
	-SqlConnection <SqlConnection>
	[-DatabaseName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Get database Transparent Database Encryption (TDE) status information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SqlInstanceTDEStatus -ServerInstance .
```

Get transparent database encryption (TDE) status for all databases.

### EXAMPLE 2
```powershell
Get-SqlInstanceTDEStatus -ServerInstance . -DatabaseName AdventureWorks
```

Get transparent database encryption (TDE) status for AdventureWorks database.

### EXAMPLE 3
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-SqlInstanceTDEStatus -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

Get transparent database encryption (TDE) status for AdventureWorks database using the specified sql connection.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to gather status information.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Data.DataRow

## NOTES

## RELATED LINKS
