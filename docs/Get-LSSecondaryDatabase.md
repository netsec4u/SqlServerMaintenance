---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-LSSecondaryDatabase

## SYNOPSIS
Retrieve log shipping databases for secondary role.

## SYNTAX

### ServerInstance (Default)
```
Get-LSSecondaryDatabase
	-ServerInstance <String>
	[-DatabaseName <String>]
	[<CommonParameters>]
```

### SqlConnection
```
Get-LSSecondaryDatabase
	-SqlConnection <SqlConnection>
	[-DatabaseName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Retrieve log shipping databases for secondary role.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-LSSecondaryDatabase -ServerInstance .
```

List all log shipping secondary databases on local server.

### EXAMPLE 2
```powershell
Get-LSSecondaryDatabase -ServerInstance . -DatabaseName AdventureWorks
```

List log shipping secondary database AdventureWorks on local server.

### EXAMPLE 3
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-LSSecondaryDatabase -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

List log shipping secondary database AdventureWorks using the specified sql connection.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to return.

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

### SqlServerMaintenance.SqlLogShippingSecondary

## NOTES

## RELATED LINKS
