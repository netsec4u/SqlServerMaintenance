---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-DatabaseRecovery

## SYNOPSIS
Generates TSQL to restore a database.

## SYNTAX

### ServerInstanceWithStopAt (Default)
```
Get-DatabaseRecovery
	-ServerInstance <String>
	[-TimeZoneId <String>]
	-BackupPath <DirectoryInfo>
	[-Exclude <FileInfo[]>]
	-DatabaseName <String>
	[-NewDatabaseName <String>]
	-RecoveryDateTime <DateTimeOffset>
	[-LastDatabaseBackup]
	[-Stats <Int32>]
	[-Replace]
	[-NoRecovery]
	[<CommonParameters>]
```

### ServerInstanceWithStopBeforeMark
```
Get-DatabaseRecovery
	-ServerInstance <String>
	[-TimeZoneId <String>]
	-BackupPath <DirectoryInfo>
	[-Exclude <FileInfo[]>]
	-DatabaseName <String>
	[-NewDatabaseName <String>]
	[-LastDatabaseBackup]
	[-Stats <Int32>]
	[-Replace]
	-StopBeforeMark <String>
	-MarkDateTime <DateTimeOffset>
	[-NoRecovery]
	[<CommonParameters>]
```

### ServerInstanceBackupFileInfo
```
Get-DatabaseRecovery
	-ServerInstance <String>
	[-TimeZoneId <String>]
	[-NewDatabaseName <String>]
	[-LastDatabaseBackup]
	[-Stats <Int32>]
	[-Replace]
	-BackupFileInfo <BackupFileInfo[]>
	[-SkipLogChainCheck]
	[-NoRecovery]
	[<CommonParameters>]
```

### SmoServerWithStopBeforeMark
```
Get-DatabaseRecovery
	-SmoServerObject <Server>
	[-TimeZoneId <String>]
	-BackupPath <DirectoryInfo>
	[-Exclude <FileInfo[]>]
	-DatabaseName <String>
	[-NewDatabaseName <String>]
	[-LastDatabaseBackup]
	[-Stats <Int32>]
	[-Replace]
	-StopBeforeMark <String>
	-MarkDateTime <DateTimeOffset>
	[-NoRecovery]
	[<CommonParameters>]
```

### SmoServerWithStopAt
```
Get-DatabaseRecovery
	-SmoServerObject <Server>
	[-TimeZoneId <String>]
	-BackupPath <DirectoryInfo>
	[-Exclude <FileInfo[]>]
	-DatabaseName <String>
	[-NewDatabaseName <String>]
	-RecoveryDateTime <DateTimeOffset>
	[-LastDatabaseBackup]
	[-Stats <Int32>]
	[-Replace]
	[-NoRecovery]
	[<CommonParameters>]
```

### SmoServerBackupFileInfo
```
Get-DatabaseRecovery
	-SmoServerObject <Server>
	[-TimeZoneId <String>]
	[-NewDatabaseName <String>]
	[-LastDatabaseBackup]
	[-Stats <Int32>]
	[-Replace]
	-BackupFileInfo <BackupFileInfo[]>
	[-SkipLogChainCheck]
	[-NoRecovery]
	[<CommonParameters>]
```

## DESCRIPTION
Generates TSQL to restore full/differential backups, restore transaction log backups to point in time or to marked transaction.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -RecoveryDateTime "6/4/2021 13:00:00 -04:00" -ServerInstance MySqlServer
```

Get database recovery commands for AdventureWorks database to recover to "6/4/2021 13:00:00 -04:00" using SQL instance MySqlServer.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -RecoveryDateTime "6/4/2021 13:00:00 -04:00" -SmoServerObject $SmoServer
```

Get database recovery commands for AdventureWorks database to recover to "6/4/2021 13:00:00 -04:00" using SmoServer object.

### EXAMPLE 3
```powershell
Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -StopBeforeMark "MyMarkedTransaction" -MarkDateTime "6/4/2021 13:00:00 -04:00" -ServerInstance MySqlServer
```

Get database recovery commands for AdventureWorks database to recover to before marked transaction before "6/4/2021 13:00:00 -04:00" using SQL instance MySqlServer.

### EXAMPLE 4
```powershell
Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -StopBeforeMark "MyMarkedTransaction" -MarkDateTime "6/4/2021 13:00:00 -04:00" -SmoServerObject $SmoServer
```

Get database recovery commands for AdventureWorks database to recover to before marked transaction before "6/4/2021 13:00:00 -04:00" using SmoServer object.

### EXAMPLE 5
```powershell
$BackupFileInfo = [SqlServerMaintenance.BackupFileInfo]::New('C:\MyBackup.bak')

Get-DatabaseRecovery -BackupFileInfo $BackupFileInfo -ServerInstance MySqlServer
```

Get database recovery commands from backup file list to recover using SQL instance MySqlServer.

### EXAMPLE 6
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
$BackupFileInfo = [SqlServerMaintenance.BackupFileInfo]::New('C:\MyBackup.bak')

Get-DatabaseRecovery -BackupFileInfo $BackupFileInfo -SmoServerObject $SmoServer
```

Get database recovery commands from backup file list to recover using SmoServer object.

## PARAMETERS

### -BackupFileInfo
BackupFileInfo Object.

```yaml
Type: BackupFileInfo[]
Parameter Sets: ServerInstanceBackupFileInfo, SmoServerBackupFileInfo
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackupPath
Backup Root folder.

```yaml
Type: DirectoryInfo
Parameter Sets: ServerInstanceWithStopAt, ServerInstanceWithStopBeforeMark, SmoServerWithStopBeforeMark, SmoServerWithStopAt
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Name of database.

```yaml
Type: String
Parameter Sets: ServerInstanceWithStopAt, ServerInstanceWithStopBeforeMark, SmoServerWithStopBeforeMark, SmoServerWithStopAt
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
Full or differential Backup files to exclude.

```yaml
Type: FileInfo[]
Parameter Sets: ServerInstanceWithStopAt, ServerInstanceWithStopBeforeMark, SmoServerWithStopBeforeMark, SmoServerWithStopAt
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastDatabaseBackup
Restore only last full or differential before recovery datetime.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MarkDateTime
Recovery stops just before the first mark having the specified name exactly at or after datetime.
Datetime must be near marked transaction.

```yaml
Type: DateTimeOffset
Parameter Sets: ServerInstanceWithStopBeforeMark, SmoServerWithStopBeforeMark
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewDatabaseName
Alternate name to restore database to.

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

### -NoRecovery
Specifies no recovery for last restore.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecoveryDateTime
Date and time to recover database to.

```yaml
Type: DateTimeOffset
Parameter Sets: ServerInstanceWithStopAt, SmoServerWithStopAt
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Replace
Include Replace option in full database restore.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
SQL Server host name and instance name.

```yaml
Type: String
Parameter Sets: ServerInstanceWithStopAt, ServerInstanceWithStopBeforeMark, ServerInstanceBackupFileInfo
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipLogChainCheck
Specifies to skip log chain checks on transaction log backups.

```yaml
Type: SwitchParameter
Parameter Sets: ServerInstanceBackupFileInfo, SmoServerBackupFileInfo
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
Parameter Sets: SmoServerWithStopBeforeMark, SmoServerWithStopAt, SmoServerBackupFileInfo
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stats
Reports the percentage complete as of the threshold for reporting the next interval.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopBeforeMark
Specifies recovery up to a specified marked transaction recovery point.
Can stopped on marked transaction or log sequence number (LSN).

```yaml
Type: String
Parameter Sets: ServerInstanceWithStopBeforeMark, SmoServerWithStopBeforeMark
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZoneId
SQL Server instance time zone id where backups were created.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### SqlServerMaintenance.Restore

## NOTES

Does not support multiple backups in Full and Differential backup files.  Also, does not support different backup types within a single backup file.

Does not support backups with Full Text Catalog files from SQL Server 2005 backups.

Future development needed to make function time zone aware.

https://sqlbak.com/academy/log-sequence-number

## RELATED LINKS
