---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-SqlInstanceBackup
---

# Invoke-SqlInstanceBackup

## SYNOPSIS

Perform a backup all databases on instance or specified database to a local or network disk.

## SYNTAX

### Default-ServerInstance (Default)

```
Invoke-SqlInstanceBackup
  -ServerInstance <string>
  -BackupType <BackupType>
  [-DatabaseName <string[]>]
  [-DiffBackupThreshold <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### TailLog-ServerInstance

```
Invoke-SqlInstanceBackup
  -ServerInstance <string>
  -DatabaseName <string[]>
  -BackupType <BackupType>
  -TailLog
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### CopyOnly-ServerInstance

```
Invoke-SqlInstanceBackup
  -ServerInstance <string>
  -DatabaseName <string[]>
  -BackupType <BackupType>
  -CopyOnly
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### TailLog-SmoServerObject

```
Invoke-SqlInstanceBackup
  -SmoServerObject <Server>
  -DatabaseName <string[]>
  -BackupType <BackupType>
  -TailLog
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### Default-SmoServerObject

```
Invoke-SqlInstanceBackup
  -SmoServerObject <Server>
  -BackupType <BackupType>
  [-DatabaseName <string[]>]
  [-DiffBackupThreshold <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### CopyOnly-SmoServerObject

```
Invoke-SqlInstanceBackup
  -SmoServerObject <Server>
  -DatabaseName <string[]>
  -BackupType <BackupType>
  -CopyOnly
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Perform a backup all databases on instance or specified database to a local or network disk.

## EXAMPLES

### Example 1

```powershell
Invoke-SqlInstanceBackup -ServerInstance . -BackupType Full
```

Performs ful backup for all database on local server.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Invoke-SqlInstanceBackup -SmoServerObject $SmoServer -BackupType Full
```

Performs ful backup for all database using the specified Smo session.

### Example 3

```powershell
Invoke-SqlInstanceBackup -ServerInstance . -DatabaseName AdventureWorks -BackupType Full -CopyOnly
```

Performs copy only ful backup for database AdventureWorks on local server.

### Example 4

```powershell
Invoke-SqlInstanceBackup -ServerInstance . -DatabaseName AdventureWorks -BackupType Log -TailLog
```

Performs tail log backup for database AdventureWorks on local server.

## PARAMETERS

### -BackupType

Specifies the type of backup operation to perform.

```yaml
Type: BackupType
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- cf
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

### -CopyOnly

Indicates that the backup is a copy-only backup.
A copy-only backup does not affect the normal sequence of your regularly scheduled conventional backups.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: CopyOnly-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: CopyOnly-ServerInstance
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
- Name: TailLog-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TailLog-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-ServerInstance
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: CopyOnly-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: CopyOnly-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DiffBackupThreshold

Specifies the differential backup threshold Percentage.

```yaml
Type: System.Int32
DefaultValue: 60
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-ServerInstance
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
- Name: TailLog-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: CopyOnly-ServerInstance
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
- Name: TailLog-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: CopyOnly-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TailLog

Indicates that the backup is a tail log backup.
Database will be in recovery on completion of log backup.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: TailLog-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TailLog-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- wi
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

### SqlServerMaintenance.Backup



## NOTES

* must add the ability to support failover clusters
    ```PowerShell
    if ($SmoServer.IsClustered) {
          #Determine how to find active node for instance.
    }

    if ($SmoServer.IsMemberOfWsfcCluster) {
      #determine preferred backup
      #SELECT sys.fn_hadr_backup_is_preferred_replica ( 'AdventureWorks' )
    }

    $Databases = $Databases | Select-Object Name, RecoveryModel, LastBackupDate, AvailabilityGroupName
    ```


## RELATED LINKS

None.

