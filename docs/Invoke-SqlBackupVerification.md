---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Invoke-SqlBackupVerification

## SYNOPSIS
Verify database backups.

## SYNTAX

### Default (Default)
```
Invoke-SqlBackupVerification
	[<CommonParameters>]
```

### Default-SqlInstance
```
Invoke-SqlBackupVerification
	[-TestBackupSqlInstance <String>]
	-BackupPath <DirectoryInfo[]>
	[<CommonParameters>]
```

### ByServerInstance-SqlInstance
```
Invoke-SqlBackupVerification
	[-TestBackupSqlInstance <String>]
	-BackupPath <DirectoryInfo[]>
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

### ByInstancePath-SqlInstance
```
Invoke-SqlBackupVerification
	[-TestBackupSqlInstance <String>]
	-SqlInstanceBackupPath <DirectoryInfo[]>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

### Default-SqlConnection
```
Invoke-SqlBackupVerification
	-SqlConnection <SqlConnection>
	-BackupPath <DirectoryInfo[]>
	[<CommonParameters>]
```

### ByServerInstance-SqlConnection
```
Invoke-SqlBackupVerification
	-SqlConnection <SqlConnection>
	-BackupPath <DirectoryInfo[]>
	-ServerInstance <String>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

### ByInstancePath-SqlConnection
```
Invoke-SqlBackupVerification
	-SqlConnection <SqlConnection>
	-SqlInstanceBackupPath <DirectoryInfo[]>
	[-DatabaseName <String[]>]
	[<CommonParameters>]
```

## DESCRIPTION
Verify database backups.
SQL instance folders and database folders will be iterated through to verify each database backup.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlBackupVerification -TestBackupSqlInstance . -BackupPath C:\MSSQLServer\Backup
```

Test all SQL backups within specified folder.

### EXAMPLE 2
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Invoke-SqlBackupVerification -SqlConnection $SqlConnection -BackupPath C:\MSSQLServer\Backup
```

Test all SQL backups within specified folder using the specified Sql connection.

### EXAMPLE 3
```powershell
Invoke-SqlBackupVerification -TestBackupSqlInstance . -SqlInstanceBackupPath C:\MSSQLServer\Backup
```

Loops though all database folders to test backups.

### EXAMPLE 4
```powershell
Invoke-SqlBackupVerification -TestBackupSqlInstance . -BackupPath C:\MSSQLServer\Backup -ServerInstance MySQLServer
```

Loops though specified server instance folder and database folders to test backups.

### EXAMPLE 5
```powershell
Invoke-SqlBackupVerification -TestBackupSqlInstance . -BackupPath C:\MSSQLServer\Backup -ServerInstance MySQLServer -DatabaseName AdventureWorks
```

Test all SQL backups for specified database folder within the instance folder.

### EXAMPLE 6
```powershell
Invoke-SqlBackupVerification -TestBackupSqlInstance . -SqlInstanceBackupPath C:\MSSQLServer\Backup -DatabaseName AdventureWorks
```

Test all SQL backups within specified database folder.

## PARAMETERS

### -BackupPath
Backup Root folder.
Folder contains a folder for each SQL instance.

```yaml
Type: DirectoryInfo[]
Parameter Sets: Default-SqlInstance, ByServerInstance-SqlInstance, Default-SqlConnection, ByServerInstance-SqlConnection
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
Parameter Sets: ByServerInstance-SqlInstance, ByInstancePath-SqlInstance, ByServerInstance-SqlConnection, ByInstancePath-SqlConnection
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target of the backup operation.

```yaml
Type: String
Parameter Sets: ByServerInstance-SqlInstance, ByServerInstance-SqlConnection
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
Parameter Sets: Default-SqlConnection, ByServerInstance-SqlConnection, ByInstancePath-SqlConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlInstanceBackupPath
SQL Instance backup folder.
Folder contains a folder for each database.

```yaml
Type: DirectoryInfo[]
Parameter Sets: ByInstancePath-SqlInstance, ByInstancePath-SqlConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestBackupSqlInstance
Specifies the name of a SQL Server instance to perform backup tests.

```yaml
Type: String
Parameter Sets: Default-SqlInstance, ByServerInstance-SqlInstance, ByInstancePath-SqlInstance
Aliases:

Required: False
Position: Named
Default value: .
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
BackupTypes
		F - Full
		D - Differential
		L - Transaction log
Statuses
		E - Error
		F - Failure
		S - Success
		O - Orphaned

## RELATED LINKS
