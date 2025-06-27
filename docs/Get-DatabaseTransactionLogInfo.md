---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-DatabaseTransactionLogInfo

## SYNOPSIS
Get database transaction log information.

## SYNTAX

### ServerInstance (Default)
```
Get-DatabaseTransactionLogInfo
	-ServerInstance <String>
	-DatabaseName <String[]>
	[<CommonParameters>]
```

### SqlConnection
```
Get-DatabaseTransactionLogInfo
	-SqlConnection <SqlConnection>
	-DatabaseName <String[]>
	[<CommonParameters>]
```

## DESCRIPTION
Get database transaction log information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DatabaseTransactionLogInfo -ServerInstance . -DatabaseName AdventureWorks
```

Get transaction log information from database AdventureWorks.

### EXAMPLE 2
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-DatabaseTransactionLogInfo -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

Get transaction log information from database AdventureWorks.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to gather log file information.

```yaml
Type: String[]
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

### SqlServerMaintenance.DatabaseTransactionLogInfo

## NOTES

## RELATED LINKS
