@{

# Script module or binary module file associated with this manifest.
RootModule = 'SqlServerMaintenance.psm1'

# Version number of this module.
ModuleVersion = '3.0.3.0'

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
	@{ModuleName='SqlServerTools'; ModuleVersion='3.7.5.0'; GUID='0dbb8289-ae5b-4633-afc8-dfaf0acbe06c'},
	@{ModuleName='MailTools'; ModuleVersion='2.3.0.0'; GUID='2e6c86d5-98ac-4bb7-bc9a-9ff2fab701a0'}
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
		<Version>3.1.0</Version>
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
				<CheckDB TableName="Statistics_CheckDB" RetentionDays="90" />
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
		v310 = "IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{1}'
		)
		BEGIN
			CREATE TABLE [{0}].[{1}](
				[StatisticID] [int] IDENTITY(1,1) NOT NULL,
				[CollectionDate] [datetimeoffset](0) NOT NULL,
				[DatabaseName] [nvarchar](128) NOT NULL,
				[DatabaseGUID] [uniqueidentifier] NOT NULL,
				[IsNoIndex] [bit] NOT NULL,
				[CheckDbOptions] [varchar](256) NULL,
				[Status] [char](1) NOT NULL
			);
		END
GO

UPDATE [{0}].[{2}]
SET Version = '3.1.0';
"

	}

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://netsec4u.github.io/Help/SqlServerMaintenance/'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

# SIG # Begin signature block
# MIInywYJKoZIhvcNAQcCoIInvDCCJ7gCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBRXZCsUc3G5yhk
# C+BGqk3LBsYsH9jVUAjqqMqFtrTwQqCCINswggWNMIIEdaADAgECAhAOmxiO+dAt
# 5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNV
# BAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBa
# Fw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lD
# ZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3E
# MB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKy
# unWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsF
# xl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU1
# 5zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJB
# MtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObUR
# WBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6
# nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxB
# YKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5S
# UUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+x
# q4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIB
# NjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwP
# TzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMC
# AYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENB
# LmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0Nc
# Vec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnov
# Lbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65Zy
# oUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFW
# juyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPF
# mCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9z
# twGpn1eqXijiuZQwgga0MIIEnKADAgECAhANx6xXBf8hmS5AQyIMOkmGMA0GCSqG
# SIb3DQEBCwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRy
# dXN0ZWQgUm9vdCBHNDAeFw0yNTA1MDcwMDAwMDBaFw0zODAxMTQyMzU5NTlaMGkx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYg
# MjAyNSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0eDHTCphB
# cr48RsAcrHXbo0ZodLRRF51NrY0NlLWZloMsVO1DahGPNRcybEKq+RuwOnPhof6p
# vF4uGjwjqNjfEvUi6wuim5bap+0lgloM2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHe
# HYNnQxqXmRinvuNgxVBdJkf77S2uPoCj7GH8BLuxBG5AvftBdsOECS1UkxBvMgEd
# gkFiDNYiOTx4OtiFcMSkqTtF2hfQz3zQSku2Ws3IfDReb6e3mmdglTcaarps0wjU
# jsZvkgFkriK9tUKJm/s80FiocSk1VYLZlDwFt+cVFBURJg6zMUjZa/zbCclF83bR
# VFLeGkuAhHiGPMvSGmhgaTzVyhYn4p0+8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeS
# LsJygoLPp66bkDX1ZlAeSpQl92QOMeRxykvq6gbylsXQskBBBnGy3tW/AMOMCZIV
# NSaz7BX8VtYGqLt9MmeOreGPRdtBx3yGOP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL
# 6s36czwzsucuoKs7Yk/ehb//Wx+5kMqIMRvUBDx6z1ev+7psNOdgJMoiwOrUG2Zd
# SoQbU2rMkpLiQ6bGRinZbI4OLu9BMIFm1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFU
# eEY0qVjPKOWug/G6X5uAiynM7Bu2ayBjUwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/
# BAgwBgEB/wIBADAdBgNVHQ4EFgQU729TSunkBnx6yuKQVvYv1Ensy04wHwYDVR0j
# BBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1Ud
# JQQMMAoGCCsGAQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0
# cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8E
# PDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVz
# dGVkUm9vdEc0LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEw
# DQYJKoZIhvcNAQELBQADggIBABfO+xaAHP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/
# T8ObXAZz8OjuhUxjaaFdleMM0lBryPTQM2qEJPe36zwbSI/mS83afsl3YTj+IQhQ
# E7jU/kXjjytJgnn0hvrV6hqWGd3rLAUt6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9r
# EVKChHyfpzee5kH0F8HABBgr0UdqirZ7bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y
# 1IsA0QF8dTXqvcnTmpfeQh35k5zOCPmSNq1UH410ANVko43+Cdmu4y81hjajV/gx
# dEkMx1NKU4uHQcKfZxAvBAKqMVuqte69M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3t
# y9qIijanrUR3anzEwlvzZiiyfTPjLbnFRsjsYg39OlV8cipDoq7+qNNjqFzeGxcy
# tL5TTLL4ZaoBdqbhOhZ3ZRDUphPvSRmMThi0vw9vODRzW6AxnJll38F0cuJG7uEB
# YTptMSbhdhGQDpOXgpIUsWTjd6xpR6oaQf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud
# /v4+7RWsWCiKi9EOLLHfMR2ZyJ/+xhCx9yHbxtl5TPau1j/1MIDpMPx0LckTetiS
# uEtQvLsNz3Qbp7wGWqbIiOWCnb5WqxL3/BAPvIXKUjPSxyZsq8WhbaM2tszWkPZP
# ubdcMIIGuTCCBKGgAwIBAgIRAJmjgAomVTtlq9xuhKaz6jkwDQYJKoZIhvcNAQEM
# BQAwgYAxCzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2ll
# cyBTLkEuMScwJQYDVQQLEx5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkx
# JDAiBgNVBAMTG0NlcnR1bSBUcnVzdGVkIE5ldHdvcmsgQ0EgMjAeFw0yMTA1MTkw
# NTMyMThaFw0zNjA1MTgwNTMyMThaMFYxCzAJBgNVBAYTAlBMMSEwHwYDVQQKExhB
# c3NlY28gRGF0YSBTeXN0ZW1zIFMuQS4xJDAiBgNVBAMTG0NlcnR1bSBDb2RlIFNp
# Z25pbmcgMjAyMSBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJ0j
# zwQwIzvBRiznM3M+Y116dbq+XE26vest+L7k5n5TeJkgH4Cyk74IL9uP61olRsxs
# U/WBAElTMNQI/HsE0uCJ3VPLO1UufnY0qDHG7yCnJOvoSNbIbMpT+Cci75scCx7U
# sKK1fcJo4TXetu4du2vEXa09Tx/bndCBfp47zJNsamzUyD7J1rcNxOw5g6FJg0Im
# Iv7nCeNn3B6gZG28WAwe0mDqLrvU49chyKIc7gvCjan3GH+2eP4mYJASflBTQ3HO
# s6JGdriSMVoD1lzBJobtYDF4L/GhlLEXWgrVQ9m0pW37KuwYqpY42grp/kSYE4BU
# QrbLgBMNKRvfhQPskDfZ/5GbTCyvlqPN+0OEDmYGKlVkOMenDO/xtMrMINRJS5SY
# +jWCi8PRHAVxO0xdx8m2bWL4/ZQ1dp0/JhUpHEpABMc3eKax8GI1F03mSJVV6o/n
# mmKqDE6TK34eTAgDiBuZJzeEPyR7rq30yOVw2DvetlmWssewAhX+cnSaaBKMEj9O
# 2GgYkPJ16Q5Da1APYO6n/6wpCm1qUOW6Ln1J6tVImDyAB5Xs3+JriasaiJ7P5KpX
# eiVV/HIsW3ej85A6cGaOEpQA2gotiUqZSkoQUjQ9+hPxDVb/Lqz0tMjp6RuLSKAR
# sVQgETwoNQZ8jCeKwSQHDkpwFndfCceZ/OfCUqjxAgMBAAGjggFVMIIBUTAPBgNV
# HRMBAf8EBTADAQH/MB0GA1UdDgQWBBTddF1MANt7n6B0yrFu9zzAMsBwzTAfBgNV
# HSMEGDAWgBS2oVQ5AsOgP46KvPrU+Bym0ToO/TAOBgNVHQ8BAf8EBAMCAQYwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwMAYDVR0fBCkwJzAloCOgIYYfaHR0cDovL2NybC5j
# ZXJ0dW0ucGwvY3RuY2EyLmNybDBsBggrBgEFBQcBAQRgMF4wKAYIKwYBBQUHMAGG
# HGh0dHA6Ly9zdWJjYS5vY3NwLWNlcnR1bS5jb20wMgYIKwYBBQUHMAKGJmh0dHA6
# Ly9yZXBvc2l0b3J5LmNlcnR1bS5wbC9jdG5jYTIuY2VyMDkGA1UdIAQyMDAwLgYE
# VR0gADAmMCQGCCsGAQUFBwIBFhhodHRwOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJ
# KoZIhvcNAQEMBQADggIBAHWIWA/lj1AomlOfEOxD/PQ7bcmahmJ9l0Q4SZC+j/v0
# 9CD2csX8Yl7pmJQETIMEcy0VErSZePdC/eAvSxhd7488x/Cat4ke+AUZZDtfCd8y
# HZgikGuS8mePCHyAiU2VSXgoQ1MrkMuqxg8S1FALDtHqnizYS1bIMOv8znyJjZQE
# Sp9RT+6NH024/IqTRsRwSLrYkbFq4VjNn/KV3Xd8dpmyQiirZdrONoPSlCRxCIi5
# 4vQcqKiFLpeBm5S0IoDtLoIe21kSw5tAnWPazS6sgN2oXvFpcVVpMcq0C4x/CLSN
# e0XckmmGsl9z4UUguAJtf+5gE8GVsEg/ge3jHGTYaZ/MyfujE8hOmKBAUkVa7NMx
# RSB1EdPFpNIpEn/pSHuSL+kWN/2xQBJaDFPr1AX0qLgkXmcEi6PFnaw5T17UdIIn
# A58rTu3mefNuzUtse4AgYmxEmJDodf8NbVcU6VdjWtz0e58WFZT7tST6EWQmx/Oo
# HPelE77lojq7lpsjhDCzhhp4kfsfszxf9g2hoCtltXhCX6NqsqwTT7xe8LgMkH4h
# Vy8L1h2pqGLT2aNCx7h/F95/QvsTeGGjY7dssMzq/rSshFQKLZ8lPb8hFTmiGDJN
# yHga5hZ59IGynk08mHhBFM/0MLeBzlAQq1utNjQprztZ5vv/NJy8ua9AGbwkMWkO
# MIIG4DCCBMigAwIBAgIQQ7s0QZ8qUnHOP66HyvajHjANBgkqhkiG9w0BAQsFADBW
# MQswCQYDVQQGEwJQTDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEu
# MSQwIgYDVQQDExtDZXJ0dW0gQ29kZSBTaWduaW5nIDIwMjEgQ0EwHhcNMjYwOTEy
# MjEzNTQ3WhcNMjcwOTEyMjEzNTQ2WjCBhTELMAkGA1UEBhMCVVMxFzAVBgNVBAgM
# DlNvdXRoIENhcm9saW5hMREwDwYDVQQHDAhOZXdiZXJyeTEeMBwGA1UECgwVT3Bl
# biBTb3VyY2UgRGV2ZWxvcGVyMSowKAYDVQQDDCFPcGVuIFNvdXJjZSBEZXZlbG9w
# ZXIgUm9iZXJ0IEVkZXIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC6
# 72ybkWUB620cgb49nkhI4VvtWKABeSD8277f0Jww+/5fKUxoX2vC77QjmaSXU+I9
# LB2YTj8yCSTDVlxIwJoS7KgsIN9P2EC6ehJe9FRI0n2Rt33/VlRY8kuSh2XsIVGg
# i6Y3RooWVjVmYCAOXuV5zrqjGY1P72nrSIekxcGCTo1Y0nmRwsECCIYn7b3ZM065
# u9b3AtYf3oI4grblWhtY0kbuHNCSeDjpp+qExQgeIs6OpFACJSDASFiDnF8+L+bB
# V+UtUcFbvlu0WpQyblXw9vdN7BEIdqZ/1fxyhjHxqpSuOoTqoZcyDjilXtnMOfWp
# gfgdKPFRc6NHwrmxUyNLAYHOsqBC+bMxamurB1qCJ/16lFbW/YWJRrJsaeA2WaPw
# 8ulkUnZUoP9JgyVE1nwZbhZOgE3YwlVLmBBsAKsRiyJWBYqG1VdaMpfzLYJVNTc8
# 4F/90uC2BvIoafcFfNyc8dIpdd7Ni17JmYuD0+/u1gqUi3p+Qdlk/y+Vgsb1x+0z
# kaMA6CzjFA83szdzwRLFDDnaUOVngyRR8+JLnSNuEw9nNM3G5WWRGBDOkLbwq+NO
# H1gWWAaJJYOlTARrg7ea2JHLl66CBJaaledp2u8hBl1Y5yQTpIkVYx0VPt1Oa7Nq
# kOkXlNjmmlYsZm5pe3fSTBPx5YdUOeIl1sAWXGH/+QIDAQABo4IBeDCCAXQwDAYD
# VR0TAQH/BAIwADA9BgNVHR8ENjA0MDKgMKAuhixodHRwOi8vY2NzY2EyMDIxLmNy
# bC5jZXJ0dW0ucGwvY2NzY2EyMDIxLmNybDBzBggrBgEFBQcBAQRnMGUwLAYIKwYB
# BQUHMAGGIGh0dHA6Ly9jY3NjYTIwMjEub2NzcC1jZXJ0dW0uY29tMDUGCCsGAQUF
# BzAChilodHRwOi8vcmVwb3NpdG9yeS5jZXJ0dW0ucGwvY2NzY2EyMDIxLmNlcjAf
# BgNVHSMEGDAWgBTddF1MANt7n6B0yrFu9zzAMsBwzTAdBgNVHQ4EFgQUCdHvF5Qw
# xL78QY6vfJNPC89uTWEwSwYDVR0gBEQwQjAIBgZngQwBBAEwNgYLKoRoAYb2dwIF
# AQQwJzAlBggrBgEFBQcCARYZaHR0cHM6Ly93d3cuY2VydHVtLnBsL0NQUzATBgNV
# HSUEDDAKBggrBgEFBQcDAzAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBADGvhUwApFlOiMwxr4muEgH+EK8xGwyw7qZGQZYdHQZV7E6ev+4i0u2ywMbF
# H0XcYpaB4xubprYIGbltJhIXoIM+BmIB6mgzgAtKMJBIWMECnACZKPAWPJ5vp3Xu
# GLCg0gwQGZEKJInwEFLzplH3G5g8hTO8KSLmWLVWoWHTTA3WI4LgTf/XRs3QYqur
# bB1gWRWa+vx8J/4I6znbpnpRDxy/jCYh9qtv21Dk3BovIPnfaj50JOWJhWeongQ6
# Dgd4/FZhM/U1Fj/g1W7WDMal9q43MABwmrHPbxrIEK1V5vXwAhK1m9eSaZ8bqbeA
# SId0wOYzIyEziquoO5TCdf/lSi8nD4BIm2E+h738pLQXWvr6tYWyvqaUN0uk5f27
# NsXlVRYp8EUZPP83BJMaQJFgTsYPMeZejAndk3nuqPVGeCL6WW90M7eK5sPbTAmW
# WrSnYFx4pgnMR3X3s14074ytJ3o3ycKa0bxjhMcoCTfMDmV7jUUhATpW8iZ2/E4b
# +0s7DmbN37VsBngsj04vMyVxhcNLSwdFDTQEgkEwHccChlw0anfoZJ7Xui4x5RSr
# j3rOyyrf7mFYIpsbDYjVxBo5/JVJuu5h2+BRxY9MLoSMknm391tCI7aVC/XTl/zW
# rX1kJeCx0nYBnZnmjWCRrCXWOX5V8QaLAnK/R6durGeXnlo3MIIG7TCCBNWgAwIB
# AgIQCE/cM09+RU7bww+P+ZIYNTANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJV
# UzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRy
# dXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0ExMB4X
# DTI2MDgwNTAwMDAwMFoXDTM3MTEwNDIzNTk1OVowYzELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBTSEEyNTYg
# UlNBNDA5NiBUaW1lc3RhbXAgUmVzcG9uZGVyIDIwMjYgMTCCAiIwDQYJKoZIhvcN
# AQEBBQADggIPADCCAgoCggIBALZ7pvLJ/s1K+NSbTGWz/TjGMPh8CQ6RucZCLv5a
# nHzWJjF/NWJrFIhy24fcpKXlgRiky4WAawDfU3YP0BMxt9l3Dm5oCG5Z69AqEN1k
# gHg2epx+l+lZBcmJCcN0ASURML5uFIS80sZsDwO3BSkUxDjLJhBI+qiZP3aixAC/
# qEGLjsBNlLol9VZ7pfGEXiMlneJIC5/YKuizVzNFKZZEeoy/0B8Zm+nzKBgSWG52
# lCO1w+nCg6XpCtklTJXeIg283hw7TmmsZXR+SMbjbrEOvZ3fP2VxIgeR28Y90ZSt
# d3F9VuA5RVynb/whITPAo9b75Zr4Ta6Mj3URm26QZYMn/FnbuTegcoRcFEZ9FOqM
# 5T6MTdtr/n74lIT/ug0eeOzmZ6QTFg33otX+bFRsIolvykE1jive4PuESaT8zzVe
# FWDAMDtozNgLctkGD1ZjkEyZtJrLl5ya0m5doH/ScpaZCZVl6pNUOCybMc/kxC6E
# AmSJY24L0yYKD1Nkddsnb/ItVKi/2nXpQNMu1PT5prW83vV8d67WowuUs0HdY4H8
# AMLGvdL/WHEj3ZnqMqAQQP9u3Ai9t+5eQ02GDwy0ODjdzi0xlp70W+ow63/0++YD
# EX1M0iwgUHwbrJvfpklkZQvw3+kv3vUPItdwroczk9icflf55W1zOEKAcJVAIXpc
# MCU9AgMBAAGjggGVMIIBkTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBQUyWOKMC7U
# SvtulPPm40B+9ezN4jAfBgNVHSMEGDAWgBTvb1NK6eQGfHrK4pBW9i/USezLTjAO
# BgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwgZUGCCsGAQUF
# BwEBBIGIMIGFMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20w
# XQYIKwYBBQUHMAKGUWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy
# dFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYyMDI1Q0ExLmNydDBf
# BgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkRzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5jcmww
# IAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUA
# A4ICAQCNxTphHp1SCt+ZrAmAfn0oQLFr0mLywSLaDXQIENoyKqxrFbJblzCVP/pk
# XmwXOdrOpWygLzlT12os5ipDCy35RBCg2UMeApEtrfGhz45F4Wt4WGdNdIbRWt3Y
# TYJmpR+b7lr4d7Uwn+H600u4D7RnOGf8Wj4UNgAdZkfHhHv1mx9EVh71SJelcEN/
# oORSjXzdjfw1iZH9d8Nh/thn6hH23d+VsPAr6GAYyzSA02nXD1nYLI7Ijmiv+xLC
# iYC41DSFYL3GhTiy0PxpawPtGRyaBVGzq+UiTfM8pD7KVyF5aQyWP4KhVGUUTnmm
# /RlYJoW3TiXA/+t0YcT2oRVBm3JETjajHug2AL+v5jhtKVnd3D0rbHXEu27o+Q8p
# 4sEWPMqKDB+qbceb6T/6WcwTwXmQ9lOCLLYcsQeSWmvKqzpAec9etE14jOQAzLKW
# dE3w/TCaKtLRaRT7LCkRYVnhA2D73FLje1O5b3HR5eHs0NzU/+xX7NbEdcofy0W3
# Wdwd1XOqtlpg/JgwtKfZM5dqO94lbUveOiJBI+xZEbGRsMNbXmMREUTgu+Oca7Y7
# 3MPWcslIx2VhkSKSXjDbD6rgg39H5Mh7QfieAIjWagkJNt68Yfim6cjEzVSiLSeZ
# fdkr5dtFPTW6jATlWJdYeeDRGCyatf8R1hSjzSvdN8yWQPT9gzGCBkYwggZCAgEB
# MGowVjELMAkGA1UEBhMCUEwxITAfBgNVBAoTGEFzc2VjbyBEYXRhIFN5c3RlbXMg
# Uy5BLjEkMCIGA1UEAxMbQ2VydHVtIENvZGUgU2lnbmluZyAyMDIxIENBAhBDuzRB
# nypScc4/rofK9qMeMA0GCWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAI
# oAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIB
# CzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIJCrDy5kylBLMeLx2yLk
# 3pVK7ih+Cn/V13JqZMXIHZ0eMA0GCSqGSIb3DQEBAQUABIICAKoNFm0Xjp2e5tGo
# wVcaLLpCzd8C6iMVoq3QgVU/msh3sHMGMTZvvLxksYYUvCFnXAYwHZyIaQz3b6lU
# G+O9vKtek+qQjhbYZncOqEXGP0QxZ11oPozgCLkGq/hzkzP3pHNa7ruyokq/0J2H
# pL+pP+XtiXHePFIXQPa3P8q7Xi31pccEqz09WVCB3Nr1jFlgYMvV59KutWYrqYhk
# xU8NbqwaHneXHkatQLKwTed3W+rUFdleVWxNjAgOd/f09a09U5pKS79bucL+S4E9
# UsqsGRxrKzqYgb9VHYekbwPFLGpxJuGt9fVioK19RhMV1//yOxWeXovNa8hPBE/H
# 6PW86fjHduNjOnWJ1//tWRwBnntaivgY6POM8qObj9ilfKceP/WyiW8qc5DP8YwC
# u9ZdDC219BKoNScsfjDq02pCoqW0sKqS3meoK4HpaUtKSS/ft+7ave+3rNxcL/tN
# 31VIBio95c82ZPBKZ4E+Na9osBUZtAqsE+Q8+eSjQLotxdXyajmXxwGvLJ3ICnv2
# K7F2E2jEKN4bvtkHE4zYgxd6QvIO5MN3tOMwGl3UOjQUGpW+VYazzvNChL10OXt0
# vAl8Sv6ehT3//+A3EDqwEk4IURASERk8OvuIYwUxxeC2c1Q3Tr7IHRESi2GfDy2q
# PEGwvvJz2mY6txF/Sm8LdnPXLSiqoYIDJjCCAyIGCSqGSIb3DQEJBjGCAxMwggMP
# AgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEw
# PwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2
# IFNIQTI1NiAyMDI1IENBMQIQCE/cM09+RU7bww+P+ZIYNTANBglghkgBZQMEAgEF
# AKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
# MDkxMzE5MzYyM1owLwYJKoZIhvcNAQkEMSIEIItRAJpR7MT/yWl659D7V6YZD0Ve
# ERlvU7O2zblCmwDoMA0GCSqGSIb3DQEBAQUABIICAG4QMxNjGcubkIPZ8ghu9e8v
# AhmactZMELcdB4si2YoPkUy9zg2j+VYz9xOSt8gT90Gny3ZTNvk8tF2PyZLWI+Wh
# CVR/Ca+U169RBH6FvV+R9e6tgdGzhvK+S/o/1WXPsekA0BR8xxwwzZCVW6vV8J8h
# cNzD1eVEhEW+jaxweX1v4gL8m25h++pqR+L3pIKD3hS2KXtS0TcNy1VvC0UpwtGI
# 0b5EPpif+sDAISHXtbru8Y7MCRO2SNqg2DK+LY4oMeY0cTPOhOVzX0+W9STinyGd
# cKtJ5MO+jKwepLI+dRxrmV6AINe3vYiTqMG3RwL99PdRFQ3FUKopB9Y+L9PnuJvu
# TZ1YrEXIUM7KrHmCIPdjUEs57JH7AMcJC13PxHQd8i5HJTij04PzV0bh85FaWCrJ
# KDaVXo8xRXLyOZlcwkqnMgB6ITaOaom/33dy3fa7EGs4P+DsGKwUjK8ci1OoLmvY
# efbxxxQ+6yz4BFHCb/wZobDIHeh6F4ryXul4J77Flz1+BCyF2OGtOFd6ssAyAjss
# s4lKb736fKOHfWS+4huv/927f/ro3+1bV04DQFblhUKCc0u03iCdES4N0hYSXkQl
# PNOZRdU++Wi3zxaQnp3KnqGgbAmOkToNMAWocY9CNGcwW5rcwmCklfniqXfSelsH
# ev9lPAj3j5agjnlBgDwS
# SIG # End signature block
