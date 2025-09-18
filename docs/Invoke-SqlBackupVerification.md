---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-SqlBackupVerification
---

# Invoke-SqlBackupVerification

## SYNOPSIS

Verify database backups through iterating through SQL instance and database folders.

## SYNTAX

### Default (Default)

```
Invoke-SqlBackupVerification
  [<CommonParameters>]
```

### Default-SqlInstance

```
Invoke-SqlBackupVerification
  -BackupPath <DirectoryInfo[]>
  [-TestBackupSqlInstance <string>]
  [<CommonParameters>]
```

### ByServerInstance-SqlInstance

```
Invoke-SqlBackupVerification
  -BackupPath <DirectoryInfo[]>
  -ServerInstance <string>
  [-TestBackupSqlInstance <string>]
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

### ByInstancePath-SqlInstance

```
Invoke-SqlBackupVerification
  -SqlInstanceBackupPath <DirectoryInfo[]>
  [-TestBackupSqlInstance <string>]
  [-DatabaseName <string[]>]
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
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

### ByInstancePath-SqlConnection

```
Invoke-SqlBackupVerification
  -SqlConnection <SqlConnection>
  -SqlInstanceBackupPath <DirectoryInfo[]>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Verify database backups through iterating through SQL instance and database folders.

## EXAMPLES

### EXAMPLE 1

Invoke-SqlBackupVerification -TestBackupSqlInstance . -BackupPath C:\MSSQLServer\Backup

Test all SQL backups within specified folder.

### EXAMPLE 2

$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Invoke-SqlBackupVerification -SqlConnection $SqlConnection -BackupPath C:\MSSQLServer\Backup

Test all SQL backups within specified folder using the specified Sql connection.

### EXAMPLE 3

Invoke-SqlBackupVerification -TestBackupSqlInstance . -SqlInstanceBackupPath C:\MSSQLServer\Backup

Loops though all database folders to test backups.

### EXAMPLE 4

Invoke-SqlBackupVerification -TestBackupSqlInstance . -BackupPath C:\MSSQLServer\Backup -ServerInstance MySQLServer

Loops though specified server instance folder and database folders to test backups.

### EXAMPLE 5

Invoke-SqlBackupVerification -TestBackupSqlInstance . -BackupPath C:\MSSQLServer\Backup -ServerInstance MySQLServer -DatabaseName AdventureWorks

Test all SQL backups for specified database folder within the instance folder.

### EXAMPLE 6

Invoke-SqlBackupVerification -TestBackupSqlInstance . -SqlInstanceBackupPath C:\MSSQLServer\Backup -DatabaseName AdventureWorks

Test all SQL backups within specified database folder.

## PARAMETERS

### -BackupPath

Backup Root folder.
Folder contains a folder for each SQL instance.

```yaml
Type: System.IO.DirectoryInfo[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default-SqlInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByServerInstance-SqlInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByServerInstance-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatabaseName

Specifies the name of the database(s) to back up.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByServerInstance-SqlInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByServerInstance-SqlConnection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByInstancePath-SqlInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByInstancePath-SqlConnection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServerInstance

Specifies the name of a SQL Server instance.
This server instance becomes the target of the backup operation.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByServerInstance-SqlInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByServerInstance-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SqlConnection

Specifies SQL connection object.

```yaml
Type: Microsoft.Data.SqlClient.SqlConnection
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByServerInstance-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByInstancePath-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SqlInstanceBackupPath

SQL Instance backup folder.
Folder contains a folder for each database.

```yaml
Type: System.IO.DirectoryInfo[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByInstancePath-SqlInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByInstancePath-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TestBackupSqlInstance

Specifies the name of a SQL Server instance to perform backup tests.

```yaml
Type: System.String
DefaultValue: .
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default-SqlInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByServerInstance-SqlInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByInstancePath-SqlInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void



## NOTES

BackupTypes:
  - F - Full
  - D - Differential
  - L - Transaction log

Statuses
  - E - Error
  - F - Failure
  - S - Success
  - O - Orphaned


## RELATED LINKS

None.

