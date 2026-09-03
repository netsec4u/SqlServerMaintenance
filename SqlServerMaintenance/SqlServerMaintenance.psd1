@{

# Script module or binary module file associated with this manifest.
RootModule = 'SqlServerMaintenance.psm1'

# Version number of this module.
ModuleVersion = '3.0.2.0'

# Supported PSEditions
CompatiblePSEditions = @('Core', 'Desktop')

# ID used to uniquely identify this module
GUID = 'c571c8da-cef7-4b95-ba3d-bda6e5f2fee9'

# Author of this module
Author = 'Robert Eder'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2021 Robert Eder. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Provides maintenance functions to manage SQL Server.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(
	@{ModuleName='SqlServerTools'; ModuleVersion='3.7.4.0'; GUID='0dbb8289-ae5b-4633-afc8-dfaf0acbe06c'},
	@{ModuleName='MailTools'; ModuleVersion='2.2.10.5'; GUID='2e6c86d5-98ac-4bb7-bc9a-9ff2fab701a0'}
)

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @(
	'SqlServerMaintenance.Types.ps1xml'
)

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @(
	'SqlServerMaintenance.Format.ps1xml'
)

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
	'Add-LogShippedDatabase',
	'Checkpoint-SqlDatabaseSnapshot',
	'Find-OrphanedDatabasePhysicalFile',
	'Find-OrphanedDatabaseUser',
	'Get-DatabasePrimaryFile',
	'Get-DatabaseRecovery',
	'Get-DatabaseTransactionLogInfo',
	'Get-LSPrimaryDatabase',
	'Get-LSSecondaryDatabase',
	'Get-SqlDatabaseSnapshot',
	'Get-SqlInstanceDataFileUsage',
	'Get-SqlInstanceLogFileGrowthRate',
	'Get-SqlInstanceLogFileVLFCount',
	'Get-SqlInstanceQueryStoreUsage',
	'Get-SqlInstanceTDEStatus',
	'Get-SqlServerMaintenanceConfiguration',
	'Initialize-SqlServerMaintenanceDatabase',
	'Invoke-CycleFullTextIndexLog',
	'Invoke-LogShipping',
	'Invoke-SqlBackupVerification',
	'Invoke-SqlInstanceBackup',
	'Invoke-SqlInstanceCheckDb',
	'Invoke-SqlInstanceColumnStoreMaintenance',
	'Invoke-SqlInstanceCycleErrorLog',
	'Invoke-SqlInstanceFullTextIndexMaintenance',
	'Invoke-SqlInstanceIndexMaintenance',
	'Invoke-SqlInstanceStatisticsMaintenance',
	'Move-SqlBackupFile',
	'Move-SqlDatabaseTable',
	'Read-SqlAgentAlert',
	'Remove-DbStatistic',
	'Remove-DbTest',
	'Remove-LogShippedDatabase',
	'Remove-SqlAgentAlertHistory',
	'Remove-SqlBackupFile',
	'Remove-SqlDatabaseSnapshot',
	'Remove-SqlInstanceFileHistory',
	'Remove-SqlInstanceHistory',
	'Resize-DatabaseLogicalFile',
	'Resize-DatabaseTransactionLog',
	'Restore-SqlDatabaseSnapshot',
	'Save-SqlInstanceDatabaseStatistic',
	'Save-SqlInstanceQueryStoreOption',
	'Send-DatabaseMail',
	'Set-SqlServerMaintenanceConfiguration',
	'Switch-SqlInstanceTDECertificate'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
# CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @(
	'New-SqlDatabaseSnapshot'
)

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @(
	'SqlServerMaintenance.psm1',
	'SqlServerMaintenance.Format.ps1xml',
	'SqlServerMaintenance.Types.ps1xml',
	'Templates/Message.xsl'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

	PSData = @{

		# Tags applied to this module. These help with module discovery in online galleries.
		Tags = @('SQLServer', 'LogShipping', 'SQLBackup', 'IndexMaintenance', 'CheckDb', 'StatisticMaintenance', 'FullTextIndexMaintenance', 'DatabaseRecovery')

		# A URL to the license for this module.
		LicenseUri = 'https://raw.githubusercontent.com/netsec4u/SqlServerMaintenance/main/LICENSE'

		# A URL to the main website for this project.
		ProjectUri = 'https://github.com/netsec4u/SqlServerMaintenance'

		# A URL to an icon representing this module.
		# IconUri = ''

		# ReleaseNotes of this module
		ReleaseNotes = 'Release Notes

		Known Issues
			* Checkpoint-SqlDatabaseSnapshot
				* SQL on Linux returns error "A database snapshot cannot be created because it failed to start."
			* Invoke-SqlInstanceCheckDb
				* returns error, even in ssms
			* Invoke-SqlInstanceStatisticsMaintenance
				* SmoServer ambagious parameter set selection
		'

		ExternalReferences = '
			ScottPlot (https://scottplot.net/)
				Licensed under the MIT License (MIT)
				Documentation: https://scottplot.net/api/5/
		'

		# Prerelease string of this module
		# Prerelease = ''

		# Flag to indicate whether the module requires explicit user acceptance for install/update/save
		# RequireLicenseAcceptance = $true

		# External dependent modules of this module
		# ExternalModuleDependencies = @()
	} # End of PSData hashtable

	DefaultConfiguration = '<Config>
		<Version>3.0.0</Version>
		<SmtpSettings SmtpDeliveryMethod="SpecifiedPickupDirectory">
			<PickupDirectory Path="C:\ProgramData\PowerShell\SQLServerMaintenance\Email\" />
			<Network>
				<SmtpServer>mail.domain.com</SmtpServer>
				<SmtpPort>587</SmtpPort>
				<UseTls>True</UseTls>
				<SmtpAuthentication Method="Basic">
					<SmtpUsername>username</SmtpUsername>
					<SmtpPassword EncryptedBase64String="EncryptedBase64String" Thumbprint="Thumbprint" CertificatePath="CertificatePath" KeyPath="KeyPath" />
				</SmtpAuthentication>
			</Network>
		</SmtpSettings>
		<EmailTemplates TemplatePath="Templates">
			<EmailTemplate Name="Message" TemplateName="Message.xsl" />
		</EmailTemplates>
		<EmailNotification>
			<SenderAddress>hostname_MSSQLSERVER&lt;hostname_MSSQLSERVER@emaildomain.com&gt;</SenderAddress>
			<Recipients>
				<Recipient>DBATeam&lt;dbateam@emaildomain.com&gt;</Recipient>
			</Recipients>
		</EmailNotification>
		<AdminDatabase DatabaseName="Admin" SchemaName="dbo">
			<DatabaseVersion TableName="DatabaseVersion" />
			<Statistics>
				<Backup TableName="Statistics_Backup" RetentionDays="90" />
				<ColumnStore TableName="Statistics_ColumnStore" RetentionDays="60" />
				<Database TableName="Statistics_Database" RetentionDays="365" />
				<FullTextIndex TableName="Statistics_FullTextIndex" RetentionDays="60" />
				<Index TableName="Statistics_Index" RetentionDays="60" />
				<QueryStore TableName="Statistics_QueryStore" RetentionDays="60" />
				<TableStatistics TableName="Statistics_TableStatistics" RetentionDays="60" />
			</Statistics>
			<Tests>
				<Backup TableName="Tests_Backup" RetentionDays="40" />
			</Tests>
			<SqlAgentAlerts TableName="SQLAgentAlertEvents" RetentionDays="30" />
		</AdminDatabase>
	</Config>'

	MaintenanceDatabaseDDL = @{
		BaseDDL = "IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{1}'
		)
		BEGIN
			CREATE TABLE [{0}].[{1}](
				[Version] [varchar](16) NOT NULL,
			);

			INSERT INTO [{0}].[{1}] (Version)
			VALUES ('1.0.0');
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{2}'
		)
		BEGIN
			CREATE TABLE [{0}].[{2}](
				[SQLAgentAlertEventID] [int] IDENTITY(1,1) NOT NULL,
				[EventDateTime] [datetime2](0) NULL,
				[ComputerName] [nvarchar](128) NULL,
				[ServerName] [nvarchar](128) NULL,
				[InstanceName] [nvarchar](128) NULL,
				[SQLServerInstance] [nvarchar](128) NULL,
				[MasterSQLServerAgentServiceName] [nvarchar](128) NULL,
				[DatabaseName] [nvarchar](128) NULL,
				[JobID] [uniqueidentifier] NULL,
				[JobName] [nvarchar](128) NULL,
				[JobStartDateTime] [datetime2](0) NULL,
				[StepID] [int] NULL,
				[StepName] [nvarchar](128) NULL,
				[StepCount] [int] NULL,
				[OSCommand] [nvarchar](128) NULL,
				[SQLDirectory] [nvarchar](128) NULL,
				[SQLLogDirectory] [nvarchar](128) NULL,
				[ErrorNumber] [int] NULL,
				[Severity] [tinyint] NULL,
				[MessageText] [nvarchar](2048) NULL,
				[SentDateTime] [datetimeoffset](7) NULL,
				[ClientIPAddress] [varchar](15) NULL,
				CONSTRAINT [PK_SQLAgentAlertEvents] PRIMARY KEY CLUSTERED
				(
					[SQLAgentAlertEventID] ASC
				),
				INDEX [IX_SentDateTime] NONCLUSTERED (
					[SentDateTime] ASC,
					[EventDateTime] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{3}'
		)
		BEGIN
			CREATE TABLE [{0}].[{3}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[DatabaseGUID] [uniqueidentifier] NOT NULL,
				[MediaName] [nvarchar](128) NOT NULL,
				[BackupType] [char](4) NOT NULL,
				[Pages] [bigint] NOT NULL,
				[Seconds] [decimal](9, 4) NOT NULL,
				[MBPerSecond] [decimal](9, 4) NOT NULL,
				CONSTRAINT [PK_Statistics_Backup] PRIMARY KEY CLUSTERED
				(
					[StatisticID] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{4}'
		)
		BEGIN
			CREATE TABLE [{0}].[{4}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[SchemaName] [nvarchar](128) NOT NULL,
				[ObjectID] [int] NOT NULL,
				[ObjectName] [nvarchar](128) NOT NULL,
				[IndexID] [int] NOT NULL,
				[IndexName] [nvarchar](128) NULL,
				[IndexType] [nvarchar](60) NOT NULL,
				[PartitionNumber] [int] NOT NULL,
				[CountRGs] [int] NOT NULL,
				[CountRGsResult] [int] NOT NULL,
				[TotalRows] [bigint] NOT NULL,
				[AvgRowsPerRG] [bigint] NOT NULL,
				[AvgRowsPerRGResult] [bigint] NOT NULL,
				[CountRGLessThanQualityMeasure] [int] NOT NULL,
				[CountRGLessThanQualityMeasureResult] [int] NOT NULL,
				[PercentageRGLessThanQualityMeasure] [decimal](5, 2) NOT NULL,
				[PercentageRGLessThanQualityMeasureResult] [decimal](5, 2) NOT NULL,
				[DeletedRowsPercent] [decimal](5, 2) NOT NULL,
				[DeletedRowsPercentResult] [decimal](5, 2) NOT NULL,
				[NumRowgroupsWithDeletedRows] [int] NOT NULL,
				[NumRowgroupsWithDeletedRowsResult] [int] NOT NULL,
				CONSTRAINT [PK_Statistics_ColumnStore] PRIMARY KEY CLUSTERED
				(
					[StatisticID] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{5}'
		)
		BEGIN
			CREATE TABLE [{0}].[{5}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[DatabaseGuid] [char](36) NULL,
				[LogicalFileName] [nvarchar](128) NOT NULL,
				[PhysicalFileName] [nvarchar](512) NOT NULL,
				[IsPrimaryFile] [bit] NOT NULL,
				[IsLogFile] [bit] NOT NULL,
				[IsOffline] [bit] NOT NULL,
				[IsReadOnly] [bit] NOT NULL,
				[RecoveryModel] [nvarchar](16) NOT NULL,
				[CompatibilityLevel] [char](10) NULL,
				[FileSizeMB] [decimal](18, 2) NOT NULL,
				[UsedSpaceMB] [decimal](18, 2) NOT NULL,
				[GrowthMB] [decimal](18, 2) NULL,
				CONSTRAINT [PK_Statistics_Database] PRIMARY KEY CLUSTERED
				(
					[StatisticID] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{6}'
		)
		BEGIN
			CREATE TABLE [{0}].[{6}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[SchemaName] [nvarchar](128) NOT NULL,
				[ObjectID] [int] NOT NULL,
				[ObjectName] [nvarchar](128) NOT NULL,
				[CatalogId] [int] NOT NULL,
				[CatalogName] [nvarchar](128) NOT NULL,
				[UniqueIndexID] [int] NOT NULL,
				[IndexSizeMb] [decimal](9, 2) NOT NULL,
				[IndexSizeMbResult] [decimal](9, 2) NULL,
				[FragmentsCount] [int] NOT NULL,
				[FragmentsCountResult] [int] NULL,
				[LargestFragmentMb] [decimal](9, 2) NOT NULL,
				[LargestFragmentMbResult] [decimal](9, 2) NULL,
				[IndexFragmentationSpaceMb] [decimal](9, 2) NOT NULL,
				[IndexFragmentationSpaceMbResult] [decimal](9, 2) NULL,
				[IndexFragmentationPct] [decimal](5, 2) NOT NULL,
				[IndexFragmentationPctResult] [decimal](5, 2) NULL,
				CONSTRAINT [PK_FullTextIndexStats] PRIMARY KEY CLUSTERED
				(
					[StatisticID] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{7}'
		)
		BEGIN
			CREATE TABLE [{0}].[{7}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[SchemaName] [nvarchar](128) NOT NULL,
				[ObjectID] [int] NOT NULL,
				[ObjectName] [nvarchar](128) NOT NULL,
				[IndexID] [int] NOT NULL,
				[IndexName] [nvarchar](128) NULL,
				[IndexType] [nvarchar](60) NOT NULL,
				[PartitionNumber] [int] NOT NULL,
				[AllowPageLocks] [bit] NOT NULL,
				[FillFactor] [tinyint] NOT NULL,
				[FillFactorResult] [tinyint] NULL,
				[PageCount] [bigint] NOT NULL,
				[PageCountResult] [bigint] NULL,
				[AvgFragmentation] [float] NOT NULL,
				[AvgFragmentationResult] [float] NULL,
				[ForwardedRecordCount] [bigint] NULL,
				[ForwardedRecordCountResult] [bigint] NULL,
				[AvgPageSpaceUsed] [float] NULL,
				[AvgPageSpaceUsedResult] [float] NULL,
				CONSTRAINT [PK_IndexStats] PRIMARY KEY CLUSTERED
				(
					[StatisticID] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{8}'
		)
		BEGIN
			CREATE TABLE [{0}].[{8}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[DesiredState] [nvarchar](60) NOT NULL,
				[ActualState] [nvarchar](60) NOT NULL,
				[ReadOnlyReason] [int] NOT NULL,
				[CurrentStorageSizeInMB] [bigint] NOT NULL,
				[MaxStorageSizeInMB] [bigint] NOT NULL,
				CONSTRAINT [PK_Statistics_QueryStore] PRIMARY KEY CLUSTERED
				(
					[StatisticID] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{9}'
		)
		BEGIN
			CREATE TABLE [{0}].[{9}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[SchemaName] [nvarchar](128) NOT NULL,
				[ObjectName] [nvarchar](128) NOT NULL,
				[StatisticsName] [nvarchar](128) NOT NULL,
				[RowCount] [bigint] NULL,
				[RowCountResult] [bigint] NULL,
				[RowsSampled] [bigint] NULL,
				[RowsSampledResult] [bigint] NULL,
				[LastUpdated] [datetime2](7) NULL,
				[LastUpdatedResult] [datetime2](7) NULL,
				[ModificationCount] [bigint] NULL,
				[ModificationCountResult] [bigint] NULL,
				CONSTRAINT [PK_Statistics_Stats] PRIMARY KEY CLUSTERED
				(
					[StatisticID] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				)
			);
		END

		IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{10}'
		)
		BEGIN
			CREATE TABLE [{0}].[{10}](
				[TestID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[BackupDateTime] [datetime2](0) NOT NULL,
				[ServerName] [nvarchar](128) NOT NULL,
				[BackupFolder] [nvarchar](256) NOT NULL,
				[BackupFileName] [nvarchar](128) NOT NULL,
				[BackupType] [char](1) NOT NULL,
				[DatabaseName] [nvarchar](128) NULL,
				[DatabaseGUID] [uniqueidentifier] NULL,
				[FirstLSN] [numeric](25, 0) NULL,
				[LastLSN] [numeric](25, 0) NULL,
				[CheckpointLSN] [numeric](25, 0) NULL,
				[DatabaseBackupLSN] [numeric](25, 0) NULL,
				[TestStatus] [char](1) NULL,
				[TestDateTime] [datetimeoffset](0) NULL,
				[BackupPosition] [smallint] NOT NULL,
				CONSTRAINT [PK_Tests_Backup] PRIMARY KEY CLUSTERED
				(
					[TestID] ASC
				),
				CONSTRAINT [AK_BackupFileName] UNIQUE NONCLUSTERED
				(
					[BackupFileName] ASC,
					[BackupFolder] ASC,
					[BackupPosition] ASC
				),
				INDEX [IX_CollectionDate]
				(
					[CollectionDate] ASC
				),
				INDEX [IX_BackupFolder]
				(
					[BackupFolder] ASC,
					[BackupDateTime] ASC,
					[BackupType] ASC,
					[TestStatus] ASC
				)
			);
		END"

		v300 = "IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{1}'
		)
		BEGIN
			CREATE TABLE [{0}].[{1}](
				[Version] [varchar](16) NOT NULL,
			);

			INSERT INTO [{0}].[{1}] (Version)
			VALUES ('3.0.0');
		END
GO

CREATE OR ALTER VIEW [{0}].[BackupGrowthRate_D]
AS
WITH xy AS (
	SELECT database_name AS DatabaseName
	,	database_guid
	,	[type]
	,	CAST(backup_start_date AS decimal(34, 7)) - FIRST_VALUE(CAST(backup_start_date AS decimal(34, 7))) OVER (PARTITION BY database_name, [type] ORDER BY backup_start_date ROWS UNBOUNDED PRECEDING) AS X
--	,	CAST(backup_size / 1048576.0 AS decimal(20, 4)) AS Y
	,	CAST(compressed_backup_size / 1048576.0 AS decimal(20, 4)) AS Y
	,	backup_start_date
	FROM msdb.dbo.backupset
	WHERE [type] = 'D'
		AND is_snapshot = 0
		AND backup_start_date >= DATEADD(minute, -86400, SYSDATETIMEOFFSET())
), s AS (
	SELECT DatabaseName
	,	database_guid
	,	[type]
	,	SUM(x) AS Sx
	,	SUM(y) AS Sy
	,	SUM(x * x) AS Sxx
	,	SUM(x * y) AS Sxy
	,	SUM(y * y) AS Syy
	,	CAST(COUNT(*) AS decimal(10, 0)) AS N
	,	MIN(backup_start_date) AS StartDateTime
	FROM xy
	GROUP BY DatabaseName
	,	database_guid
	,	[type]
)
SELECT DatabaseName
,	database_guid
,	[type]
,	CASE WHEN N * Sxx = Sx * Sx THEN NULL ELSE ((N * Sxy) - (Sx * Sy)) / ((N * Sxx) - (Sx * Sx)) END AS M
,	CASE WHEN N * Sxx = Sx * Sx THEN NULL ELSE ((Sy * Sxx) - (Sx * Sxy)) / ((N * Sxx) - (Sx * Sx)) END AS B
,	CASE WHEN ((N * Sxx) - (Sx * Sx)) * ((N * Syy) - (Sy * Sy)) <= 0 THEN NULL ELSE ((N * Sxy) - (Sx * Sy)) / SQRT(((N * Sxx) - (Sx * Sx)) * ((N * Syy) - (Sy * Sy))) END AS R
,	StartDateTime
FROM s;
GO

CREATE OR ALTER VIEW [{0}].[BackupGrowthRate_L]
AS
WITH dbk AS (
	SELECT database_name
	,	database_guid
	,	[type]
	,	CAST(backup_start_date AS int) AS BackupDate
--	,	SUM(backup_size) AS DailyBackupSize
	,	SUM(compressed_backup_size) AS DailyBackupSize
	FROM msdb.dbo.backupset
	WHERE [type] = 'L'
		AND backup_start_date >= DATEADD(minute, -86400, SYSDATETIMEOFFSET())
	GROUP BY database_name
	,	database_guid
	,	[type]
	,	CAST(backup_start_date AS int)
),  xy AS (
	SELECT database_name AS DatabaseName
	,	database_guid
	,	[type]
	,	CAST(BackupDate AS decimal(34, 7)) - FIRST_VALUE(CAST(BackupDate AS decimal(34, 7))) OVER (PARTITION BY database_name, [type] ORDER BY BackupDate ROWS UNBOUNDED PRECEDING) AS X
	,	CAST(DailyBackupSize / 1048576.0 AS decimal(20, 4)) AS Y
	,	BackupDate
	FROM dbk
), s AS (
	SELECT DatabaseName
	,	database_guid
	,	[type]
	,	SUM(x) AS Sx
	,	SUM(y) AS Sy
	,	SUM(x * x) AS Sxx
	,	SUM(x * y) AS Sxy
	,	SUM(y * y) AS Syy
	,	CAST(COUNT(*) AS decimal(10, 0)) AS N
	,	MIN(BackupDate) AS StartDateTime
	FROM xy
	GROUP BY DatabaseName
	,	database_guid
	,	[type]
)
SELECT DatabaseName
,	database_guid
,	[type]
,	CASE WHEN N * Sxx = Sx * Sx THEN NULL ELSE ((N * Sxy) - (Sx * Sy)) / ((N * Sxx) - (Sx * Sx)) END AS M
,	CASE WHEN N * Sxx = Sx * Sx THEN NULL ELSE ((Sy * Sxx) - (Sx * Sxy)) / ((N * Sxx) - (Sx * Sx)) END AS B
,	CASE WHEN ((N * Sxx) - (Sx * Sx)) * ((N * Syy) - (Sy * Sy)) <= 0 THEN NULL ELSE ((N * Sxy) - (Sx * Sy)) / SQRT(((N * Sxx) - (Sx * Sx)) * ((N * Syy) - (Sy * Sy))) END AS R
,	StartDateTime
FROM s;
GO

CREATE OR ALTER VIEW [{0}].[DailyBackupSize]
AS
SELECT database_name AS DatabaseName
,	database_guid
,	DATEADD(DAY, DATEDIFF(DAY, 0, backup_start_date), 0) AS BackupDate
,	[type]
,	CAST(SUM(backup_size / 1048576) AS decimal(18, 2)) AS DailyBackupSizeMB
,	CAST(SUM(compressed_backup_size / 1048576) AS decimal(18, 2)) AS DailyCompressedBackupSizeMB
,	CAST(AVG(backup_size / compressed_backup_size) AS decimal(8, 2)) AS DailyAvgCompressionRatio
FROM msdb.dbo.backupset b
WHERE ([type] = 'L' AND DATEADD(DAY, DATEDIFF(DAY, 0, backup_start_date), 0) < DATEADD(DAY, DATEDIFF(DAY, 0, CURRENT_TIMESTAMP), 0))
	OR ([type] = 'D' AND is_snapshot = 0)
GROUP BY database_name
,	database_guid
,	[type]
,	DATEADD(DAY, DATEDIFF(DAY, 0, backup_start_date), 0);
GO

CREATE OR ALTER VIEW [{0}].[DatabaseGrowthRate]
AS
WITH xy AS (
	SELECT DatabaseName
	,	DatabaseGuid
	,	LogicalFileName
	,	X = DATEDIFF(second, FIRST_VALUE(CollectionDate) OVER (PARTITION BY DatabaseName, LogicalFileName ORDER BY CollectionDate ROWS UNBOUNDED PRECEDING), CollectionDate) / 60.0 / 60.0 / 24.0
	,	Y = UsedSpaceMB
	,	CollectionDate
	FROM [{0}].[{2}]
	WHERE IsLogFile = 0
		AND CollectionDate >= DATEADD(minute, -43200, SYSDATETIMEOFFSET())
), s AS (
	SELECT DatabaseName
	,	DatabaseGuid
	,	LogicalFileName
	,	Sx = SUM(x)
	,	Sy = SUM(y)
	,	Sxx = SUM(x * x)
	,	Sxy = SUM(x * y)
	,	Syy = SUM(y * y)
	,	N = COUNT(*)
	,	StartDateTime = MIN(CollectionDate)
	FROM xy
	GROUP BY DatabaseName
	,	DatabaseGuid
	,	LogicalFileName
)
SELECT DatabaseName
,	DatabaseGuid
,	LogicalFileName
,	M = CASE WHEN N * Sxx = Sx * Sx THEN NULL ELSE ((N * Sxy) - (Sx * Sy)) / ((N * Sxx) - (Sx * Sx)) END
,	B = CASE WHEN N * Sxx = Sx * Sx THEN NULL ELSE ((Sy * Sxx) - (Sx * Sxy)) / ((N * Sxx) - (Sx * Sx)) END
,	R = CASE WHEN ((N * Sxx) - (Sx * Sx)) * ((N * Syy) - (Sy * Sy)) <= 0 THEN NULL ELSE ((N * Sxy) - (Sx * Sy)) / SQRT(((N * Sxx) - (Sx * Sx)) * ((N * Syy) - (Sy * Sy))) END
,	StartDateTime
FROM s;
GO

UPDATE [{0}].[{1}]
SET Version = '3.0.0';
"
	}

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://netsec4u.github.io/Help/SqlServerMaintenance/'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
