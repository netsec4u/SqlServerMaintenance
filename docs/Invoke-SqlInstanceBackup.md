---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-SqlInstanceBackup

## SYNOPSIS
Backup an sql database to local or remote disk.

## SYNTAX

### Default-ServerInstance (Default)
```
Invoke-SqlInstanceBackup
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	-BackupType <BackupType>
	[-DiffBackupThreshold <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### TailLog-ServerInstance
```
Invoke-SqlInstanceBackup
	-ServerInstance <String>
	-DatabaseName <String[]>
	-BackupType <BackupType>
	[-TailLog]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### CopyOnly-ServerInstance
```
Invoke-SqlInstanceBackup
	-ServerInstance <String>
	-DatabaseName <String[]>
	-BackupType <BackupType>
	[-CopyOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### TailLog-SmoServerObject
```
Invoke-SqlInstanceBackup
	-SmoServerObject <Server>
	-DatabaseName <String[]>
	-BackupType <BackupType>
	[-TailLog]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### Default-SmoServerObject
```
Invoke-SqlInstanceBackup
	-SmoServerObject <Server>
	[-DatabaseName <String[]>]
	-BackupType <BackupType>
	[-DiffBackupThreshold <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### CopyOnly-SmoServerObject
```
Invoke-SqlInstanceBackup
	-SmoServerObject <Server>
	-DatabaseName <String[]>
	-BackupType <BackupType>
	[-CopyOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Perform a backup all databases on instance or specified database to a local or network disk.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlInstanceBackup -ServerInstance . -BackupType Full
```

Performs ful backup for all database on local server.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Invoke-SqlInstanceBackup -SmoServerObject $SmoServer -BackupType Full
```

Performs ful backup for all database using the specified Smo session.

### EXAMPLE 3
```powershell
Invoke-SqlInstanceBackup -ServerInstance . -DatabaseName AdventureWorks -BackupType Full -CopyOnly
```

Performs copy only ful backup for database AdventureWorks on local server.

### EXAMPLE 4
```powershell
Invoke-SqlInstanceBackup -ServerInstance . -DatabaseName AdventureWorks -BackupType Log -TailLog
```

Performs tail log backup for database AdventureWorks on local server.

## PARAMETERS

### -BackupType
Specifies the type of backup operation to perform.

```yaml
Type: BackupType
Parameter Sets: (All)
Aliases:
Accepted values: full, diff, log

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CopyOnly
Indicates that the backup is a copy-only backup.
A copy-only backup does not affect the normal sequence of your regularly scheduled conventional backups.

```yaml
Type: SwitchParameter
Parameter Sets: CopyOnly-ServerInstance, CopyOnly-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Specifies the name of the database(s) to back up.

```yaml
Type: String[]
Parameter Sets: Default-ServerInstance, Default-SmoServerObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String[]
Parameter Sets: TailLog-ServerInstance, CopyOnly-ServerInstance, TailLog-SmoServerObject, CopyOnly-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiffBackupThreshold
Specifies the differential backup threshold Percentage.

```yaml
Type: Int32
Parameter Sets: Default-ServerInstance, Default-SmoServerObject
Aliases:

Required: False
Position: Named
Default value: 60
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target of the backup operation.

```yaml
Type: String
Parameter Sets: Default-ServerInstance, TailLog-ServerInstance, CopyOnly-ServerInstance
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
Parameter Sets: TailLog-SmoServerObject, Default-SmoServerObject, CopyOnly-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TailLog
Indicates that the backup is a tail log backup.
Database will be in recovery on completion of log backup.

```yaml
Type: SwitchParameter
Parameter Sets: TailLog-ServerInstance, TailLog-SmoServerObject
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

### None

## OUTPUTS

### SqlServerMaintenance.Backup

## NOTES
* must add the ability to support failover clusters
	if ($SmoServer.IsClustered) {
		#Determine how to find active node for instance.
	}

if ($SmoServer.IsMemberOfWsfcCluster) {
	#determine preferred backup
	#SELECT sys.fn_hadr_backup_is_preferred_replica ( 'AdventureWorks' )
}

$Databases = $Databases | Select-Object Name, RecoveryModel, LastBackupDate, AvailabilityGroupName

## RELATED LINKS
