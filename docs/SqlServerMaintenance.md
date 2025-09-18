---
document type: module
Help Version: 2.0.0.0
HelpInfoUri: https://github.com/netsec4u/SqlServerMaintenance/blob/main/docs/SqlServerMaintenance.md
Locale: en-US
Module Guid: c571c8da-cef7-4b95-ba3d-bda6e5f2fee9
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: SqlServerMaintenance Module
---

# SqlServerMaintenance Module

## Description

Provides maintenance functions to manage SQL Server.

## SqlServerMaintenance

### [Add-LogShippedDatabase](Add-LogShippedDatabase.md)

Add database to log shipping.

### [Checkpoint-SqlDatabaseSnapshot](Checkpoint-SqlDatabaseSnapshot.md)

Create database snapshot.

### [Find-OrphanedDatabasePhysicalFile](Find-OrphanedDatabasePhysicalFile.md)

Finds database files that are currently not associated with any attached database.

### [Find-OrphanedDatabaseUser](Find-OrphanedDatabaseUser.md)

Find orphaned database users.

### [Get-AvailabilityGroupDatabaseReplicaStatus](Get-AvailabilityGroupDatabaseReplicaStatus.md)

Get availability group database replica status information.

### [Get-AvailabilityGroupSeedingStatus](Get-AvailabilityGroupSeedingStatus.md)

Get availability group seeding status information.

### [Get-DatabasePrimaryFile](Get-DatabasePrimaryFile.md)

Retrieves database information from SQL database MDF data file.

### [Get-DatabaseRecovery](Get-DatabaseRecovery.md)

Generates TSQL to restore full/differential backups, restore transaction log backups to point in time or to marked transaction.

### [Get-DatabaseTransactionLogInfo](Get-DatabaseTransactionLogInfo.md)

Get database transaction log information.

### [Get-LSPrimaryDatabase](Get-LSPrimaryDatabase.md)

Retrieve log shipping databases for primary role.

### [Get-LSSecondaryDatabase](Get-LSSecondaryDatabase.md)

Retrieve log shipping databases for secondary role.

### [Get-SqlDatabaseSnapshot](Get-SqlDatabaseSnapshot.md)

Lists database snapshots.

### [Get-SqlInstanceDataFileUsage](Get-SqlInstanceDataFileUsage.md)

Gets data file usage on all databases or a specified database.

### [Get-SqlInstanceLogFileGrowthRate](Get-SqlInstanceLogFileGrowthRate.md)

Evaluates log file auto growth rate to alert when rate is less than 12.5% of log file size.

### [Get-SqlInstanceLogFileVLFCount](Get-SqlInstanceLogFileVLFCount.md)

Evaluates virtual log file (VLF) count.

### [Get-SqlInstanceQueryStoreUsage](Get-SqlInstanceQueryStoreUsage.md)

Gets query store usage on all databases or a specified database.

### [Get-SqlInstanceTDEStatus](Get-SqlInstanceTDEStatus.md)

Get database Transparent Database Encryption (TDE) status information.

### [Get-SqlServerMaintenanceConfiguration](Get-SqlServerMaintenanceConfiguration.md)

Get module configuration.

### [Initialize-SqlServerMaintenanceDatabase](Initialize-SqlServerMaintenanceDatabase.md)

Creates supporting tables for various functions within the module.

### [Invoke-CycleFullTextIndexLog](Invoke-CycleFullTextIndexLog.md)

Perform full text index maintenance on all databases or a specified database.

### [Invoke-LogShipping](Invoke-LogShipping.md)

Perform Log Shipping backup, copy, or restore operation.

### [Invoke-SqlBackupVerification](Invoke-SqlBackupVerification.md)

Verify database backups through iterating through SQL instance and database folders.

### [Invoke-SqlInstanceBackup](Invoke-SqlInstanceBackup.md)

Perform a backup all databases on instance or specified database to a local or network disk.

### [Invoke-SqlInstanceCheckDb](Invoke-SqlInstanceCheckDb.md)

Perform CheckDb on all databases or a specified database.

### [Invoke-SqlInstanceColumnStoreMaintenance](Invoke-SqlInstanceColumnStoreMaintenance.md)

Perform column store index maintenance on all databases or a specified database.

### [Invoke-SqlInstanceCycleErrorLog](Invoke-SqlInstanceCycleErrorLog.md)

Recycle error logs for SQL Server and SQL Server Agent.

### [Invoke-SqlInstanceFullTextIndexMaintenance](Invoke-SqlInstanceFullTextIndexMaintenance.md)

Perform full text index maintenance on all databases or a specified database.

### [Invoke-SqlInstanceIndexMaintenance](Invoke-SqlInstanceIndexMaintenance.md)

Perform index maintenance on all databases or a specified database.

### [Invoke-SqlInstanceStatisticsMaintenance](Invoke-SqlInstanceStatisticsMaintenance.md)

Perform table statistics maintenance on all databases or a specified database.

### [Move-SqlBackupFile](Move-SqlBackupFile.md)

Move SQL backup files to new location.

### [Move-SqlDatabaseTable](Move-SqlDatabaseTable.md)

Move database objects to a specified filegroup.

### [Read-SqlAgentAlert](Read-SqlAgentAlert.md)

Retrieves SQL Agent alerts and sends email alerts.

### [Remove-DbStatistic](Remove-DbStatistic.md)

Remove database statistic from statistics table.

### [Remove-DbTest](Remove-DbTest.md)

Remove database test from tests table.

### [Remove-LogShippedDatabase](Remove-LogShippedDatabase.md)

Remove database from log shipping.

### [Remove-SqlAgentAlertHistory](Remove-SqlAgentAlertHistory.md)

Remove SQL Agent alert history beyond retention period.

### [Remove-SqlBackupFile](Remove-SqlBackupFile.md)

Removes SQL backup file older than retention period while retaining at least one full backup.

### [Remove-SqlDatabaseSnapshot](Remove-SqlDatabaseSnapshot.md)

Remove database snapshot.

### [Remove-SqlInstanceFileHistory](Remove-SqlInstanceFileHistory.md)

Removes SQL file history older than retention period.

### [Remove-SqlInstanceHistory](Remove-SqlInstanceHistory.md)

Removes SQL instance history older than retention period.

### [Resize-DatabaseLogicalFile](Resize-DatabaseLogicalFile.md)

Resize database data file to specified size.

### [Resize-DatabaseTransactionLog](Resize-DatabaseTransactionLog.md)

Resizes transaction log to specified size.

### [Restore-SqlDatabaseSnapshot](Restore-SqlDatabaseSnapshot.md)

Restore database to snapshot.

### [Save-SqlInstanceDatabaseStatistic](Save-SqlInstanceDatabaseStatistic.md)

Save database statistics on all databases or a specified database.

### [Save-SqlInstanceQueryStoreOption](Save-SqlInstanceQueryStoreOption.md)

Save query store statistics on all databases or a specified database.

### [Send-DatabaseMail](Send-DatabaseMail.md)

Send Email using SQL Server Database Mail.

### [Set-SqlServerMaintenanceConfiguration](Set-SqlServerMaintenanceConfiguration.md)

Set module configuration.

### [Switch-SqlInstanceTDECertificate](Switch-SqlInstanceTDECertificate.md)

Change certificate used to protect the database encryption key.

