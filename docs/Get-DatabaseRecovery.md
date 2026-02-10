---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-DatabaseRecovery
---

# Get-DatabaseRecovery

## SYNOPSIS

Generates TSQL to restore full/differential backups, restore transaction log backups to point in time or to marked transaction.

## SYNTAX

### ServerInstanceWithStopAt (Default)

```
Get-DatabaseRecovery
  -ServerInstance <string>
  -BackupPath <DirectoryInfo>
  -DatabaseName <string>
  -RecoveryDateTime <DateTimeOffset>
  [-TimeZoneId <string>]
  [-Exclude <FileInfo[]>]
  [-NewDatabaseName <string>]
  [-LastDatabaseBackup]
  [-Stats <int>]
  [-Replace]
  [-NoRecovery]
  [<CommonParameters>]
```

### ServerInstanceWithStopBeforeMark

```
Get-DatabaseRecovery
  -ServerInstance <string>
  -BackupPath <DirectoryInfo>
  -DatabaseName <string>
  -StopBeforeMark <string>
  -MarkDateTime <DateTimeOffset>
  [-TimeZoneId <string>]
  [-Exclude <FileInfo[]>]
  [-NewDatabaseName <string>]
  [-LastDatabaseBackup]
  [-Stats <int>]
  [-Replace]
  [-NoRecovery]
  [<CommonParameters>]
```

### ServerInstanceBackupFileInfo

```
Get-DatabaseRecovery
  -ServerInstance <string>
  -BackupFileInfo <BackupFileInfo[]>
  -SkipLogChainCheck
  [-TimeZoneId <string>]
  [-NewDatabaseName <string>]
  [-LastDatabaseBackup]
  [-Stats <int>]
  [-Replace]
  [-NoRecovery]
  [<CommonParameters>]
```

### SmoServerWithStopBeforeMark

```
Get-DatabaseRecovery
  -SmoServerObject <Server>
  -BackupPath <DirectoryInfo>
  -DatabaseName <string>
  -StopBeforeMark <string>
  -MarkDateTime <DateTimeOffset>
  [-TimeZoneId <string>]
  [-Exclude <FileInfo[]>]
  [-NewDatabaseName <string>]
  [-LastDatabaseBackup]
  [-Stats <int>]
  [-Replace]
  [-NoRecovery]
  [<CommonParameters>]
```

### SmoServerWithStopAt

```
Get-DatabaseRecovery
  -SmoServerObject <Server>
  -BackupPath <DirectoryInfo>
  -DatabaseName <string>
  -RecoveryDateTime <DateTimeOffset>
  [-TimeZoneId <string>]
  [-Exclude <FileInfo[]>]
  [-NewDatabaseName <string>]
  [-LastDatabaseBackup]
  [-Stats <int>]
  [-Replace]
  [-NoRecovery]
  [<CommonParameters>]
```

### SmoServerBackupFileInfo

```
Get-DatabaseRecovery
  -SmoServerObject <Server>
  -BackupFileInfo <BackupFileInfo[]>
  -SkipLogChainCheck
  [-TimeZoneId <string>]
  [-NewDatabaseName <string>]
  [-LastDatabaseBackup]
  [-Stats <int>]
  [-Replace]
  [-NoRecovery]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Generates TSQL to restore full/differential backups, restore transaction log backups to point in time or to marked transaction.

## EXAMPLES

### Example 1

```powershell
Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -RecoveryDateTime "6/4/2021 13:00:00 -04:00" -ServerInstance MySqlServer
```

Get database recovery commands for AdventureWorks database to recover to "6/4/2021 13:00:00 -04:00" using SQL instance MySqlServer.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -RecoveryDateTime "6/4/2021 13:00:00 -04:00" -SmoServerObject $SmoServer
```

Get database recovery commands for AdventureWorks database to recover to "6/4/2021 13:00:00 -04:00" using SmoServer object.

### Example 3

```powershell
Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -StopBeforeMark "MyMarkedTransaction" -MarkDateTime "6/4/2021 13:00:00 -04:00" -ServerInstance MySqlServer
```

Get database recovery commands for AdventureWorks database to recover to before marked transaction before "6/4/2021 13:00:00 -04:00" using SQL instance MySqlServer.

### Example 4

```powershell
Get-DatabaseRecovery -BackupPath "D:\MSSQL\Backup" -DatabaseName "AdventureWorks" -StopBeforeMark "MyMarkedTransaction" -MarkDateTime "6/4/2021 13:00:00 -04:00" -SmoServerObject $SmoServer
```

Get database recovery commands for AdventureWorks database to recover to before marked transaction before "6/4/2021 13:00:00 -04:00" using SmoServer object.

### Example 5

```powershell
$BackupFileInfo = [SqlServerMaintenance.BackupFileInfo]::New('C:\MyBackup.bak')
Get-DatabaseRecovery -BackupFileInfo $BackupFileInfo -ServerInstance MySqlServer
```

Get database recovery commands from backup file list to recover using SQL instance MySqlServer.

### Example 6

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
Type: SqlServerMaintenance.BackupFileInfo[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerBackupFileInfo
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceBackupFileInfo
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -BackupPath

Backup Root folder.

```yaml
Type: System.IO.DirectoryInfo
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerWithStopAt
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopAt
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

Name of database.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerWithStopAt
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopAt
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Exclude

Full or differential Backup files to exclude.

```yaml
Type: System.IO.FileInfo[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerWithStopBeforeMark
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerWithStopAt
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopBeforeMark
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopAt
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -LastDatabaseBackup

Restore only last full or differential before recovery datetime.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MarkDateTime

Recovery stops just before the first mark having the specified name exactly at or after datetime.
Datetime must be near marked transaction.

```yaml
Type: System.DateTimeOffset
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NewDatabaseName

Alternate name to restore database to.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoRecovery

Specifies no recovery for last restore.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RecoveryDateTime

Date and time to recover database to.

```yaml
Type: System.DateTimeOffset
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerWithStopAt
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopAt
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Replace

Include Replace option in full database restore.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
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

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ServerInstanceWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopAt
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceBackupFileInfo
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipLogChainCheck

Specifies to skip log chain checks on transaction log backups.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerBackupFileInfo
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceBackupFileInfo
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SmoServerObject

An existing SMO Server object representing the SQL Server instance.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerWithStopAt
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerBackupFileInfo
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Stats

Reports the percentage complete as of the threshold for reporting the next interval.

```yaml
Type: System.Int32
DefaultValue: 5
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StopBeforeMark

Specifies recovery up to a specified marked transaction recovery point.
Can stopped on marked transaction or log sequence number (LSN).

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstanceWithStopBeforeMark
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TimeZoneId

SQL Server instance time zone id where backups were created.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
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

### SqlServerMaintenance.Restore



## NOTES

Does not support multiple backups in Full and Differential backup files.
 Also, does not support different backup types within a single backup file.

Does not support backups with Full Text Catalog files from SQL Server 2005 backups.

Future development needed to make function time zone aware.

https://sqlbak.com/academy/log-sequence-number


## RELATED LINKS

None.

