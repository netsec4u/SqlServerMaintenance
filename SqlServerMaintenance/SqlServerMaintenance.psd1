@{

# Script module or binary module file associated with this manifest.
RootModule = 'SqlServerMaintenance.psm1'

# Version number of this module.
ModuleVersion = '2.5.4.0'

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
Description = 'Module provides management of SQL Server.'

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
	@{ModuleName="SqlServerTools"; ModuleVersion="3.6.0.0"; GUID="0dbb8289-ae5b-4633-afc8-dfaf0acbe06c"},
	@{ModuleName="MailTools"; ModuleVersion="2.2.5.0"; GUID="2e6c86d5-98ac-4bb7-bc9a-9ff2fab701a0"}
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
	'Get-AvailabilityGroupDatabaseReplicaStatus',
	'Get-AvailabilityGroupSeedingStatus',
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

		# Prerelease string of this module
		# Prerelease = ''

		# Flag to indicate whether the module requires explicit user acceptance for install/update/save
		# RequireLicenseAcceptance = $true

		# External dependent modules of this module
		# ExternalModuleDependencies = @()
	} # End of PSData hashtable

	DefaultConfiguration = '<Config>
		<SmtpSettings SmtpDeliveryMethod="SpecifiedPickupDirectory" SmtpServer="mail" SmtpPort="25" UseTls="False" PickupDirectoryPath="C:\ProgramData\PowerShell\SQLServerMaintenance\Email\" />
		<EmailTemplates TemplatePath="Templates">
			<EmailTemplate Name="Message" TemplateName="Message.xsl" />
		</EmailTemplates>
		<EmailNotification>
			<SenderAddress>hostname_MSSQLSERVER&lt;hostname_MSSQLSERVER@emaildomain.com&gt;</SenderAddress>
			<Recipients>
				<Recipient>DBATeam&lt;dbateam@emaildomain.com&gt;</Recipient>
			</Recipients>
		</EmailNotification>
		<AdminDatabase DatabaseName="Admin">
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

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/netsec4u/SqlServerMaintenance/blob/main/docs/SqlServerMaintenance.md'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
