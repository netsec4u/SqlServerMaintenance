---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-AvailabilityGroupSeedingStatus

## SYNOPSIS
Get availability group seeding status information.

## SYNTAX

### ServerInstance (Default)
```
Get-AvailabilityGroupSeedingStatus
	-ServerInstance <String>
	[-DatabaseName <String>]
	[<CommonParameters>]
```

### SqlConnection
```
Get-AvailabilityGroupSeedingStatus
	-SqlConnection <SqlConnection>
	[-DatabaseName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Get availability group seeding status information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AvailabilityGroupSeedingStatus -ServerInstance .
```

Get availability group seeding status for all databases.

### EXAMPLE 2
```powershell
Get-AvailabilityGroupSeedingStatus -ServerInstance . -DatabaseName AdventureWorks
```

Get availability group seeding status for AdventureWorks database.

### EXAMPLE 3
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-AvailabilityGroupSeedingStatus -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

Get availability group seeding status for AdventureWorks database.

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
