---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-AvailabilityGroupDatabaseReplicaStatus

## SYNOPSIS
Get availability group database replica status information.

## SYNTAX

### ServerInstance (Default)
```
Get-AvailabilityGroupDatabaseReplicaStatus
	-ServerInstance <String>
	[-AvailabilityGroupName <String>]
	[-DatabaseName <String>]
	[<CommonParameters>]
```

### SmoServerObject
```
Get-AvailabilityGroupDatabaseReplicaStatus
	-SmoServerObject <Server>
	[-AvailabilityGroupName <String>]
	[-DatabaseName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Get availability group database replica status information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AvailabilityGroupDatabaseReplicaStatus -ServerInstance .
```

Get availability group database replica status for all databases.

### EXAMPLE 2
```powershell
Get-AvailabilityGroupDatabaseReplicaStatus -ServerInstance . -DatabaseName AdventureWorks
```

Get availability group database replica status for AdventureWorks database.

### EXAMPLE 3
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-AvailabilityGroupDatabaseReplicaStatus -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

Get availability group database replica status for AdventureWorks database.

## PARAMETERS

### -AvailabilityGroupName
Specifies availability group name.

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

### Microsoft.SqlServer.Management.Smo.DatabaseReplicaState

## NOTES

## RELATED LINKS
