param(
	[Parameter(
		Mandatory = $false
	)]
	[ValidateSet($null, 'Interactive', 'NonInteractive')]
	[string]$Mode
)

Set-StrictMode -Version Latest

#Region Global Configuration
try {
	if ($PSVersionTable.PSEdition -eq 'Core') {
		if ($PSVersionTable.Platform -eq 'Win32NT') {
			$AllUsersProfile = $Env:ALLUSERSPROFILE
			$DomainName = $Env:USERDNSDOMAIN
		} else {
			$AllUsersProfile = '/etc'
			$DomainName = [Environment]::UserDomainName
		}
	} else {
		$AllUsersProfile = $Env:ALLUSERSPROFILE
		$DomainName = $Env:USERDNSDOMAIN
	}

	$ModuleName = ($PSCommandPath -as [System.IO.FileInfo]).BaseName

	$ConfigurationPath = Join-Path -Path $(Join-Path -Path $AllUsersProfile -ChildPath 'PowerShell') -ChildPath $ModuleName
	$EmailPath = Join-Path -Path $ConfigurationPath -ChildPath 'Email'

	$Script:ConfigurationFile = Join-Path -Path $ConfigurationPath -ChildPath "$ModuleName.config"

	if (-not (Test-Path -LiteralPath $ConfigurationPath)) {
		[void][System.IO.Directory]::CreateDirectory($ConfigurationPath)
	}

	if (-not (Test-Path -LiteralPath $EmailPath)) {
		[void][System.IO.Directory]::CreateDirectory($EmailPath)
	}

	if (-not (Test-Path -Path $Script:ConfigurationFile)) {
		$PSManifestFile = $PSCommandPath -replace '.psm1$', '.psd1'

		$PrivateData = (Import-PowerShellDataFile -LiteralPath $PSManifestFile).PrivateData
		[xml]$DefaultConfiguration = $PrivateData.DefaultConfiguration

		$DefaultConfiguration.Config.SMTPSettings.PickupDirectoryPath = [string]$EmailPath
		$DefaultConfiguration.Config.EmailNotification.SenderAddress = [string]::Format('{0}_MSSQLSERVER<{0}_MSSQLSERVER@{1}>', [Environment]::MachineName, $DomainName)

		$DefaultConfiguration.Save($Script:ConfigurationFile)
	}

	[xml]$Script:PSMConfig = Get-Content $Script:ConfigurationFile -Raw

	if (-not $PSBoundParameters.ContainsKey('Mode')) {
		if ([Environment]::UserInteractive) {
			$Mode = 'Interactive'
		} else {
			$Mode = 'NonInteractive'
		}
	}

	if ($Mode -eq 'Interactive') {
		$Script:OutputMethod = 'ConsoleHost'
	} else {
		$Script:OutputMethod = 'Email'

		$Script:TemplatePath = Join-Path -Path $PSScriptRoot -ChildPath $Script:PSMConfig.Config.EMailTemplates.TemplatePath -Resolve

		$Script:BaseMailMessageParameters = @{
			'MailFrom' = $Script:PSMConfig.Config.EmailNotification.SenderAddress
			'MailTo' = [string]::Join(',', $($Script:PSMConfig.Config.EmailNotification.Recipients.Recipient))
			'BodyAsHtml' = $true
		}

		switch ($Script:PSMConfig.Config.SMTPSettings.SmtpDeliveryMethod) {
			'Network' {
				$Script:BaseMailMessageParameters.Add('SmtpDeliveryMethod', 'Network')
				$Script:BaseMailMessageParameters.Add('SmtpServer', $Script:PSMConfig.Config.SMTPSettings.SmtpServer)
				$Script:BaseMailMessageParameters.Add('SmtpPort', $Script:PSMConfig.Config.SMTPSettings.SmtpPort)
				$Script:BaseMailMessageParameters.Add('UseTls', [System.Convert]::ToBoolean($Script:PSMConfig.Config.SMTPSettings.UseTls))
			}
			'SpecifiedPickupDirectory' {
				if (Test-Path -Path $Script:PSMConfig.Config.SMTPSettings.PickupDirectoryPath -PathType Container) {
					$Script:BaseMailMessageParameters.Add('SmtpDeliveryMethod', 'SpecifiedPickupDirectory')
					$Script:BaseMailMessageParameters.Add('PickupDirectoryPath', $Script:PSMConfig.Config.SMTPSettings.PickupDirectoryPath)
				} else {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Pickup directory not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$Script:PSMConfig.Config.SMTPSettings.PickupDirectoryPath
					)
				}
			}
			Default {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Unknown SMTP delivery method.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidType,
					$Script:PSMConfig.Config.SMTPSettings.SmtpDeliveryMethod
				)
			}
		}
	}
}
catch {
	throw $_
}
#EndRegion

#Region Enumerations
enum BackupType {
	full
	diff
	log
}

enum DbMailSensitivity {
	Normal
	Personal
	Private
	Confidential
}

enum IndexEvalMethod {
	Fragmentation
	PageSpaceUsed
}

enum LogFileHistory {
	AgentJobOutput
	Dump
	ExtendedEvent
	Trace
}

enum LogHistory {
	AgentJob
	Backup
	DatabaseMail
	LogShipping
	MaintenancePlan
	MultiServerAdministration
	PolicyBasedManagement
}

enum LSOperation {
	Backup
	Copy
	Restore
}

enum SqlServerMaintenanceSetting {
	SmtpSettings
	EmailNotification
	AdminDatabase
	Statistics
	Tests
	SqlAgentAlerts
}

$EnumString =
@"
	public enum DbStatistic
	{
		`n$(foreach ($Name in $Script:PSMConfig.SelectNodes("//Config/AdminDatabase/Statistics/*").Get_Name()){"`t$Name`,"})`n
	}

	public enum DbTest
	{
		`n$(foreach ($Name in $Script:PSMConfig.SelectNodes("//Config/AdminDatabase/Tests/*").Get_Name()){"`t$Name`,"})`n
	}
"@

Add-Type -TypeDefinition $EnumString

Remove-Variable -Name EnumString
#EndRegion

#Region Classes
Class ArgumentCompleterResult {
	#properties

	#Method
	static [System.Management.Automation.CompletionResult[]] GetArgumentCompleterResult([System.Array]$Arguments) {
		#[string]$CommandName = $Arguments[0]
		[string]$ParameterName = $Arguments[1]
		[string]$WordToComplete = $Arguments[2]
		#[System.Management.Automation.Language.CommandAst]$CommandAst = $Arguments[3]
		#[Hashtable]$FakeBoundParameters = $Arguments[4]

		$ParameterValueList = $null

		switch ($ParameterName) {
			'TimeZoneId' {
				$SystemTimeZones = [System.TimeZoneInfo]::GetSystemTimeZones()

				$ParameterValueList = $SystemTimeZones.Id
			}
			Default {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Unknown argument completer.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ParameterName
				)
			}
		}

		$SelectedParameters = $ParameterValueList.where({ $_ -like "$WordToComplete*" }) | Sort-Object

		$CompletionResultList = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::New()

		foreach ($Parameter in $SelectedParameters) {
			if ($Parameter -match '\s|''') {
				$CompletionText = [string]::Format("'{0}'", $($Parameter.Replace("'", "''")))
			} else {
				$CompletionText = $Parameter
			}

			$ListItemText = $Parameter
			$ResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
			$ToolTip = $Parameter

			$CompletionResultList.Add([System.Management.Automation.CompletionResult]::New($CompletionText, $ListItemText, $ResultType, $ToolTip))
		}

		return $CompletionResultList
	}
}

class ValidateInterval : System.Management.Automation.ValidateArgumentsAttribute {
	[object]$LowerBound
	[object]$UpperBound
	[bool]$IncludeLowerBound
	[bool]$IncludeUpperBound

	ValidateInterval([object]$LowerBound, [object]$UpperBound, [bool]$IncludeLowerBound, [bool]$IncludeUpperBound) {
		$this.LowerBound = $LowerBound
		$this.UpperBound = $UpperBound
		$this.IncludeLowerBound = $IncludeLowerBound
		$this.IncludeUpperBound = $IncludeUpperBound
	}

	[void]Validate([object]$ArgumentValue, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
		[string]$ErrorFormatTemplate = 'The {0} argument is {2} the {3} allowed range of {1}. Supply an argument that is {4} {1} and then try the command again.'

		if (-not $this.IncludeLowerBound -and -not $this.IncludeUpperBound) {
			if ($ArgumentValue -le $this.LowerBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.LowerBound, 'less than or equal to', 'minimum', 'greater than')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}

			if ($ArgumentValue -ge $this.UpperBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.UpperBound, 'greater than or equal to', 'maximum', 'less than')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}
		}

		if (-not $this.IncludeLowerBound -and $this.IncludeUpperBound) {
			if ($ArgumentValue -le $this.LowerBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.LowerBound, 'less than or equal to', 'minimum', 'greater than')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}

			if ($ArgumentValue -gt $this.UpperBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.UpperBound, 'greater than', 'maximum', 'less than or equal to')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}
		}

		if ($this.IncludeLowerBound -and -not $this.IncludeUpperBound) {
			if ($ArgumentValue -lt $this.LowerBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.LowerBound, 'less than', 'minimum', 'greater than or equal to')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}

			if ($ArgumentValue -ge $this.UpperBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.UpperBound, 'greater than or equal to', 'maximum', 'less than')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}
		}

		if ($this.IncludeLowerBound -and $this.IncludeUpperBound) {
			if ($ArgumentValue -lt $this.LowerBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.LowerBound, 'less than', 'minimum', 'greater than or equal to')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}

			if ($ArgumentValue -gt $this.UpperBound) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New([string]::Format($ErrorFormatTemplate, $ArgumentValue, $this.UpperBound, 'greater than', 'maximum', 'less than or equal to')),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$ArgumentValue
				)
			}
		}
	}
}

class ValidatePathExists : System.Management.Automation.ValidateArgumentsAttribute {
	[string]$PathType = 'Any'

	ValidatePathExists([string]$PathType) {
		$this.PathType = $PathType
	}

	[void]Validate([object]$Path, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
		if([string]::IsNullOrWhiteSpace($Path)) {
			throw [System.ArgumentNullException]::New()
		}

		if(-not (Test-Path -Path $Path -PathType $this.PathType)) {
			switch ($this.PathType) {
				'Container' {
					throw [System.IO.DirectoryNotFoundException]::New()
				}
				'Leaf' {
					throw [System.IO.FileNotFoundException]::New()
				}
				Default {
					throw [System.InvalidOperationException]::New('An unexpected error has occurred.')
				}
			}
		}
	}
}
#EndRegion

#Region Type Definitions
$TypeDefinition = @'
using System;
using System.Collections.Generic;
using System.Security;
using System.Security.Cryptography;
using System.Text.RegularExpressions;

public class RandomPassword
{
	public string Prop { get; internal set; }

	public static SecureString Generate(int MinPasswordLength, int MaxPasswordLength)
	{
		return Generate(MinPasswordLength, MaxPasswordLength, false);
	}

	public static SecureString Generate(int MinPasswordLength, int MaxPasswordLength, bool AlphaNumericOnly)
	{
		if (MinPasswordLength < 16 || MaxPasswordLength > 128 || MinPasswordLength > MaxPasswordLength)
		{
			throw new RandomPassword.InvalidLength("Invalid password length input.");
		}

		List<char> CharacterSet = new List<char>();

		for (int a = 33; a <= 126; a++)
		{
			char Character = Convert.ToChar(a);

			if (AlphaNumericOnly)
			{
				if (Char.IsPunctuation(Character) || Char.IsSymbol(Character))
				{
					continue;
				}
			}

			CharacterSet.Add(Character);
		}

		int PasswordLength = MinPasswordLength;

		if (MinPasswordLength != MaxPasswordLength)
		{
			// GetInt32 not available in Dot NET 4.5
			// PasswordLength = RandomNumberGenerator.GetInt32(MinPasswordLength, MaxPasswordLength);
			PasswordLength = RandomInt32(MinPasswordLength, MaxPasswordLength);
		}

		SecureString Password = new SecureString();

		do
		{
			Password = new SecureString();

			/*
			// GetString not available in Dot NET 4.5
			foreach (char Character in RandomNumberGenerator.GetString(CharacterSet.ToArray(), PasswordLength))
			{
				Password.AppendChar(Character);
			}
			*/

			for (int c = 0; c < PasswordLength; c++)
			{
				Password.AppendChar(CharacterSet[RandomInt32(0,  CharacterSet.Count - 1)]);
			}
		} while (!TestPassword(Password));

		return Password;
	}


	private static int RandomInt32(int fromInclusive, int toExclusive)
	{
		if (fromInclusive >= toExclusive)
		{
			throw new RandomPassword.InvalidLength("Invalid range.");
		}

		byte[] ByteArray = new byte[4];

		RandomNumberGenerator.Create().GetBytes(ByteArray);

		int a = Math.Abs(BitConverter.ToInt32(ByteArray, 0)) % (toExclusive - fromInclusive) + fromInclusive;

		return a;
	}

	private static bool TestPassword(SecureString Password)
	{
		string PasswordRegEx = @"(?-i)(?=.{16,128})((?=.*\d)(?=.*[a-z])(?=.*[A-Z])|(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])|(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])).*";

		return Regex.IsMatch(new System.Net.NetworkCredential(string.Empty, Password).Password, PasswordRegEx);
	}

	[Serializable]
	public class InvalidLength : Exception
	{
		public InvalidLength() : base() { }
		public InvalidLength(string message) : base(message) { }
		public InvalidLength(string message, Exception inner) : base(message, inner) { }
	}
}
'@

Add-Type -TypeDefinition $TypeDefinition

$TypeDefinition = @'
using System;

namespace Regression
{
	// https://www.mssqltips.com/sqlservertip/8176/regression-analysis-in-sql/?utm_source=rss&utm_medium=rss&utm_campaign=regression-analysis-in-sql
	public class Linear
	{
		public double Slope { get; private set; }
		public double YIntercept { get; private set; }
		public double rSquared { get; private set; }
		public double MeanAbsoluteError { get; private set; }
		public double RootMeanSquaredError { get; private set; }

		public Linear(double[] X, double[] Y)
		{
			if (X.Length != Y.Length)
			{
				throw new Regression.LengthMismatch("Input values should be with the same length.");
			}

			double SumOfX = 0;
			double SumOfY = 0;
			double SumOfXSq = 0;
			double SumOfYSq = 0;
			double SumCoDeviates = 0;

			int SampleCount = X.Length;

			for (var i = 0; i < SampleCount; i++)
			{
				SumOfX += X[i];
				SumOfY += Y[i];
				SumOfXSq += X[i] * X[i];
				SumOfYSq += Y[i] * Y[i];
				SumCoDeviates += X[i] * Y[i];
			}

			double ssX = SumOfXSq - ((SumOfX * SumOfX) / SampleCount);

			double rNumerator = (SampleCount * SumCoDeviates) - (SumOfX * SumOfY);
			double rDenominator = (SampleCount * SumOfXSq - (SumOfX * SumOfX)) * (SampleCount * SumOfYSq - (SumOfY * SumOfY));
			double sCo = SumCoDeviates - ((SumOfX * SumOfY) / SampleCount);

			double MeanX = SumOfX / SampleCount;
			double MeanY = SumOfY / SampleCount;
			double dblR = rNumerator / Math.Sqrt(rDenominator);

			this.Slope = sCo / ssX;
			this.YIntercept = MeanY - ((sCo / ssX) * MeanX);
			this.rSquared = dblR * dblR;

			double MAEDenominator = 0;
			double RMSEDenominatorSquared = 0;

			for (var i = 0; i < SampleCount; i++)
			{
				MAEDenominator += Math.Abs(Y[i] - (this.YIntercept + this.Slope * X[i]));
				RMSEDenominatorSquared += Math.Pow(Y[i] - (this.YIntercept + this.Slope * X[i]), 2);
			}

			this.MeanAbsoluteError = MAEDenominator / SampleCount;
			this.RootMeanSquaredError = Math.Sqrt(RMSEDenominatorSquared / SampleCount);
		}

		public double CalculatePrediction(double x)
		{
			return (this.Slope * x) + this.YIntercept;
		}
	}

	public class ExponentialCurveFit
	{
		public double a { get; private set; }
		public double b { get; private set; }
		public double rSquared { get; private set; }
		public double MeanAbsoluteError { get; private set; }
		public double RootMeanSquaredError { get; private set; }

		public ExponentialCurveFit(double[] X, double[] Y)
		{
			if (X.Length != Y.Length)
			{
				throw new Regression.LengthMismatch("Input values should be with the same length.");
			}

			double SumOfX = 0;
			double SumOfXSquared = 0;
			double SumOfProductXLogY = 0;
			double SumOfLogY = 0;
			double SumOfLogYSquared = 0;
			double SumOfLogYByN = 0;

			int SampleCount = X.Length;

			for (var i = 0; i < SampleCount; i++)
			{
				SumOfX += X[i];
				SumOfXSquared += Math.Pow(X[i], 2);
				SumOfProductXLogY += X[i] * Math.Log(Y[i]);
				SumOfLogY += Math.Log(Y[i]);
				SumOfLogYSquared += Math.Pow(Math.Log(Y[i]), 2);
				SumOfLogYByN += Math.Log(Y[i]) / SampleCount;
			}

			this.b = (SumOfProductXLogY - SumOfX * SumOfLogY / SampleCount) / (SumOfXSquared - Math.Pow(SumOfX, 2) / SampleCount);
			this.a = Math.Exp(SumOfLogY / SampleCount - this.b * SumOfX / SampleCount);
			this.rSquared = Math.Pow(SumOfProductXLogY - SumOfX * SumOfLogY / SampleCount, 2) / ((SumOfXSquared - Math.Pow(SumOfX, 2) / SampleCount) * (SumOfLogYSquared - Math.Pow(SumOfLogY, 2) / SampleCount));

			double MAEDenominator = 0;
			double RMSEDenominatorSquared = 0;

			for (var i = 0; i < SampleCount; i++)
			{
				MAEDenominator += Math.Abs(Y[i] - this.a * Math.Exp(this.b * X[i]));
				RMSEDenominatorSquared += (Y[i] - this.a * Math.Exp(this.b * X[i])) * (Y[i] - this.a * Math.Exp(this.b * X[i]));
			}

			this.MeanAbsoluteError = MAEDenominator / SampleCount;
			this.RootMeanSquaredError = Math.Sqrt(RMSEDenominatorSquared / SampleCount);
		}

		public double CalculatePrediction(double x)
		{
			return this.a * Math.Exp(this.b * x);
		}
	}

//	public class Polynomial
//	{
//	}

	[Serializable]
	public class LengthMismatch : Exception
	{
		public LengthMismatch() : base() { }
		public LengthMismatch(string message) : base(message) { }
		public LengthMismatch(string message, Exception inner) : base(message, inner) { }
	}
}
'@

Add-Type -TypeDefinition $TypeDefinition

$TypeDefinition = @'
using System;
using System.IO;

namespace SqlServerMaintenance
{
	public class Backup
	{
		public string DatabaseName;
		public int Pages;
		public decimal seconds;
		public decimal MBPerSecond;
	}

	public class BackupFileInfo
	{
		public string FullName;
		public string Name;
		public string BaseName;
		public string Extension;
		public DateTimeOffset BackupDate;
		public string BackupType;

		private void SetBackupDate ()
		{
			try
			{
				string DateString = this.BaseName.Substring(this.BaseName.Length - 14, 14);

				this.BackupDate = DateTimeOffset.ParseExact(DateString, "yyyyMMddHHmmss", null, System.Globalization.DateTimeStyles.AssumeUniversal);
			}
			catch
			{
				throw new SqlServerMaintenance.InvalidBackupFileName(String.Format("Invalid backup file name: {0}", this.FullName));
			}
		}

		private void SetBackupType ()
		{
			switch (this.Extension.ToLower())
			{
				case ".bak":
					this.BackupType = "full";

					break;
				case ".dif":
					this.BackupType = "diff";

					break;
				case ".trn":
					this.BackupType = "log";

					break;
				default:
					throw new SqlServerMaintenance.InvalidBackupType("Unknown backup file type.");
			}
		}

		public BackupFileInfo(string FileName)
		{
			System.IO.FileInfo FileInfo = new System.IO.FileInfo(FileName);

			this.FullName = FileInfo.FullName;
			this.Name = FileInfo.Name;
			this.BaseName = FileInfo.Name.Remove(FileInfo.Name.Length - FileInfo.Extension.Length);
			this.Extension = FileInfo.Extension;

			this.SetBackupDate();
			this.SetBackupType();
		}
	}

	public class DatabasePrimaryFile
	{
		public string DatabaseName;
		public int DatabaseVersion;
		public int Collation;
		public DatabasePrimaryLogicalFile[] LogicalFile;
	}

	public class DatabasePrimaryLogicalFile
	{
		public int Status;
		public int FileID;
		public string LogicalFileName;
		public string FileName;
	}

	public class DatabaseMailItem
	{
		public string SqlInstance;
		public int MailItemID;
		public string Recipients;
		public string Subject;
	}

	public class DatabaseSnapshot
	{
		public string DatabaseSnapshotName;
		public Microsoft.SqlServer.Management.Smo.DatabaseStatus Status;
		public Microsoft.SqlServer.Management.Smo.RecoveryModel RecoveryModel;
		public Microsoft.SqlServer.Management.Smo.CompatibilityLevel CompatibilityLevel;
		public string Owner;
		public string DatabaseSnapshotBaseName;

		public Microsoft.SqlServer.Management.Smo.Database Database;

		public DatabaseSnapshot(Microsoft.SqlServer.Management.Smo.Database SmoDatabase)
		{
			this.DatabaseSnapshotName = SmoDatabase.Name;
			this.Status = SmoDatabase.Status;
			this.RecoveryModel = SmoDatabase.RecoveryModel;
			this.CompatibilityLevel = SmoDatabase.CompatibilityLevel;
			this.Owner = SmoDatabase.Owner;
			this.DatabaseSnapshotBaseName = SmoDatabase.DatabaseSnapshotBaseName;

			this.Database = SmoDatabase;
		}
	}

	public class FullTextIndex
	{
		public string SqlInstanceName;
		public string DatabaseName;
		public string SchemaName;
		public string TableName;
		public string CatalogName;
		public IndexMode Mode;
	}

	public class Index
	{
		public string SqlInstanceName;
		public string DatabaseName;
		public string SchemaName;
		public string TableName;
		public string IndexName;
		public int? PartitionNumber;
		public IndexMode Mode;
	}

	public class OrphanedDatabasePhysicalFile
	{
		public string BaseName { get; private set; }
		public string Name;
		public string DirectoryName;
		public string FullName;
		public string Extension;
		public string FileType { get; private set; }

		public OrphanedDatabasePhysicalFile(string Path)
		{
			var File = new FileInfo(Path);

			this.BaseName = System.IO.Path.GetFileNameWithoutExtension(Path);
			this.Name = File.Name;
			this.DirectoryName = File.DirectoryName;
			this.FullName = File.FullName;
			this.Extension = File.Extension;

			switch (File.Extension.ToLower())
			{
				case ".ldf":
					this.FileType = "Log Data File";
					break;

				case ".mdf":
					this.FileType = "Master Data File";
					break;

				case ".ndf":
					this.FileType = "Secondary Data File";
					break;

				case ".tuf":
					this.FileType = "Transaction Undo File";
					break;

				case ".ss":
					this.FileType = "Database Snapshot";
					break;

				default:
					this.FileType = "Unknown";
					break;
			}
		}
	}

	public class OrphanedDatabaseUser
	{
		public string DatabaseName;
		public string DatabaseUser;
		public string LoginName;
		public string SidString { get; private set; }
		public Microsoft.SqlServer.Management.Smo.AuthenticationType? AuthenticationType;
		public Microsoft.SqlServer.Management.Smo.LoginType? LoginType;

		public OrphanedDatabaseUser(Microsoft.SqlServer.Management.Smo.User DatabaseUser)
		{
			this.DatabaseName = DatabaseUser.Parent.Name;
			this.DatabaseUser = DatabaseUser.Name;
			this.SidString = BitConverter.ToString(DatabaseUser.Sid).Replace("-", string.Empty);
		}
	}

	public class Restore
	{
		public string DatabaseName;
		public string BackupDatabaseName;
		public System.Guid DatabaseGUID;
		public System.IO.FileInfo BackupFileName;
		public DateTime BackupStartDate;
		public DateTime BackupFinishDate;
		public string BackupType;
		public Int16 BackupPosition;
		public string RecoveryModel;
		public decimal FirstLSN;
		public decimal LastLSN;
		public decimal CheckpointLSN;
		public decimal DatabaseBackupLSN;
		public string RestoreDML;
	}

	public class SqlDataFileUsage
	{
		public string SqlInstance;
		public string DatabaseName;
		public string FileGroupName;
		public string DataFileName;
		public int? DataFileSize;
		public int DataFileUsedSpace;
		public int? DataFileAvailableSpace;

		public decimal? DataFileAvailablePercent
		{
			get
			{
				if (DataFileSize != null && DataFileAvailableSpace != null)
				{
					decimal percentage = Math.Round(Convert.ToDecimal(DataFileAvailableSpace.GetValueOrDefault()) / DataFileSize.GetValueOrDefault() * 100, 2, MidpointRounding.AwayFromZero);

					return percentage;
				}
				else
				{
					return null;
				}
			}
		}

		public int RecommendedDataFileSize;
		public double? Reliability;
		public int? RecommendedAutoGrowth;
		public double? DailyGrowthRate;
	}

	public class SqlLogFileGrowth
	{
		public string DatabaseName;
		public string LogFileName;
		public int LogFileSize;
		public string GrowthType;
		public int AutoGrowth;

		public decimal? AutoGrowthPercentageOfFileSize
		{
			get
			{
				decimal? AutoGrowthMB = null;

				switch (GrowthType.ToLower())
				{
					case "kb":
						AutoGrowthMB = AutoGrowth / 1024;

						break;
					case "mb":
						AutoGrowthMB = AutoGrowth;

						break;
					case "gb":
						AutoGrowthMB = AutoGrowth * 1024;

						break;
				}

				if (AutoGrowthMB != null)
				{
					decimal percentage = Math.Round(AutoGrowthMB.GetValueOrDefault() / LogFileSize * 100, 2, MidpointRounding.AwayFromZero);

					return percentage;
				}
				else
				{
					return null;
				}
			}
		}

		public int MinimumRecommendedAutoGrowth;
	}

	public class SqlLogFileVLFCount
	{
		public string SqlInstance;
		public string DatabaseName;
		public int TotalVLFCount;
	}

	public class SqlLogShip
	{
		public System.DateTime? DateTime;
		public string DatabaseName;
		public string Transcript;
	}

	public class SqlLogShippingPrimary
	{
		public string PrimaryID;
		public string PrimaryDatabase;
		public System.IO.DirectoryInfo BackupDirectory;
		public System.IO.DirectoryInfo BackupShare;
		public int BackupRetentionPeriod_Minutes;
		public string MonitorServer;
		public string ServerSecurityMode;
		public string BackupCompression;
		public string PrimaryServer;
		public int BackupThreshold_Minutes;
		public string ThresholdAlertEnabled;
		public System.IO.FileInfo LastBackupFile;
		public System.DateTime LastBackupDate;
		public int HistoryRetentionPeriod_Minutes;
		public string SecondaryServer;
		public string SecondaryDatabase;
	}

	public class SqlLogShippingSecondary
	{
		public string SecondaryID;
		public string PrimaryServer;
		public string PrimaryDatabase;
		public System.IO.DirectoryInfo BackupSourceDirectory;
		public System.IO.DirectoryInfo BackupDestinationDirectory;
		public int FileRetentionPeriod_Minutes;
		public string MonitorServer;
		public string MonitorServerSecurityMode;
		public System.IO.FileInfo LastCopiedFile;
		public System.DateTime LastCopiedDate;
		public string SecondaryDatabase;
		public int RestoreDelay_Minutes;
		public string RestoreAll;
		public string RestoreMode;
		public string DisconnectUsers;
		public int BlockSize;
		public int BufferCount;
		public int MaxTransferSize;
		public System.IO.FileInfo LastRestoredFile;
		public System.DateTime LastRestoredDate;
	}

	public class SqlQueryStore
	{
		public string DatabaseName;
		public int? CurrentStorageSizeInMB;
		public int? MaxStorageSizeInMB;

		public decimal? StorageAvailablePercent
		{
			get
			{
				decimal? AvailablePercent = null;

				if (CurrentStorageSizeInMB != null && MaxStorageSizeInMB != null)
				{
					AvailablePercent = Math.Round(Convert.ToDecimal(100 - (Convert.ToDecimal(CurrentStorageSizeInMB) / MaxStorageSizeInMB * 100)), 2, MidpointRounding.AwayFromZero);
				}

				return AvailablePercent;
			}
		}

		public string DesiredState;
		public string ActualState;
		public int? ReadOnlyReason;

		public string ReadOnlyReasonDescription
		{
			get
			{
				switch (ReadOnlyReason)
				{
					case 1:
						return "The database is in read-only mode.";
					case 2:
						return "The database is in single-user mode.";
					case 4:
						return "The database is in emergency mode";
					case 8:
						return "The database is secondary replica.";
					case 65536:
						return "The Query Store has reached the size limit set by the MAX_STORAGE_SIZE_MB option.";
					case 131072:
						return "The number of different statements in Query Store has reached the internal memory limit. Consider removing queries that you do not need or upgrading to a higher service tier to enable transferring Query Store to read-write mode.";
					case 262144:
						return "Size of in-memory items waiting to be persisted on disk has reached the internal memory limit. Query Store will be in read-only mode temporarily until the in-memory items are persisted on disk.";
					case 524288:
						return "Database has reached disk size limit. Query Store is part of user database, so if there is no more available space for a database, that means that Query Store cannot grow further anymore.";
					default:
						if (ReadOnlyReason == null || ReadOnlyReason == 0 )
						{
							return null;
						}
						else
						{
							return "Unknown read-only status: " + ReadOnlyReason;
						}
				}
			}
		}
	}

	public class DatabaseTransactionLogInfo
	{
		public string DatabaseName;
		public Int16 FileID;
		public Int64 VlfBeginOffset;
		public float VlfSizeMB;
		public Int64 VlfSequenceNumber;
		public string VlfCreateLsn;
		public float RunningSizeMB;
	}

	[Serializable]
	public class InvalidBackupType : Exception
	{
		public InvalidBackupType() : base() { }
		public InvalidBackupType(string message) : base(message) { }
		public InvalidBackupType(string message, Exception inner) : base(message, inner) { }
	}

	[Serializable]
	public class InvalidBackupFileName : Exception
	{
		public InvalidBackupFileName() : base() { }
		public InvalidBackupFileName(string message) : base(message) { }
		public InvalidBackupFileName(string message, Exception inner) : base(message, inner) { }
	}

	public enum IndexMode
	{
		None,
		Reorganize,
		Rebuild,
	}
}
'@

$ReferencedAssemblies = @(
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.Smo.dll'}).Location
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.SqlEnum.dll'}).Location
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.Management.Sdk.Sfc.dll'}).Location
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.ConnectionInfo.dll'}).Location
)

$TypeParameters = @{
	TypeDefinition = $TypeDefinition
	ReferencedAssemblies = $ReferencedAssemblies
	WarningAction = 'Ignore'
	IgnoreWarnings = $true
}

Add-Type @TypeParameters

Remove-Variable -Name @('TypeDefinition', 'ReferencedAssemblies', 'TypeParameters')
#EndRegion


function Add-LogShippedDatabase {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([PSObject])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$PrimaryServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$SecondaryServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$PrimarySmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SecondarySmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo]$StagingPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$AvailabilityGroupName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Switch]$ConfigurationOnly
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $PrimaryServerInstance
					'DatabaseName' = 'master'
				}

				$PrimarySmoServer = Connect-SmoServer @SmoServerParameters

				$SmoServerParameters = @{
					'ServerInstance' = $SecondaryServerInstance
					'DatabaseName' = 'master'
				}

				$SecondarySmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$PrimarySmoServer = $PrimarySmoServerObject
				$SecondarySmoServer = $SecondarySmoServerObject
			}

			[System.IO.DirectoryInfo]$BackupPath = $PrimarySmoServer.Settings.BackupDirectory

			if ($PrimarySmoServer.HostPlatform -eq 'Windows') {
				if ([Environment]::MachineName -ne $PrimarySmoServer.NetName) {
					if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
						if (-not $([System.Uri]$BackupPath.FullName).IsUnc) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Local backup paths are not supported for remote SQL instances.'),
								'1',
								[System.Management.Automation.ErrorCategory]::NotImplemented,
								$BackupPath
							)
						}
					} else {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Backup of SQL Server on Windows from non-Windows host is not supported.'),
							'1',
							[System.Management.Automation.ErrorCategory]::NotImplemented,
							$BackupPath
						)
					}
				}
			} else {
				if ([Environment]::MachineName -ne $PrimarySmoServer.NetName) {
					if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Backup of SQL Server on Linux from Windows host is not supported.'),
							'1',
							[System.Management.Automation.ErrorCategory]::NotImplemented,
							$BackupPath
						)
					} else {
						if (-not $(Test-Path -LiteralPath $BackupPath -PathType Container)) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Backup path must be mounted on local file system.'),
								'1',
								[System.Management.Automation.ErrorCategory]::ObjectNotFound,
								$BackupPath
							)
						}
					}
				}
			}

			$RetainMinutes = ($PrimarySmoServer.Configuration.MediaRetention.RunValue + 10) * 1440
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\PrimaryServerInstance) {
					if ($PrimaryServerInstance -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $PrimaryServerInstance
					}
				}

				if (Test-Path -Path Variable:\SecondarySmoServer) {
					if ($SecondarySmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SecondarySmoServer
					}
				}
			}

			throw $_
		}

		$Query_LSPrimary = "DECLARE @LS_Add_RetCode int
			,	@LS_BackupJobId uniqueidentifier
			,	@LS_PrimaryId uniqueidentifier
			,	@SP_Add_RetCode int;

			EXEC @SP_Add_RetCode = master.dbo.sp_add_log_shipping_primary_database
				@database = N'{0}'
			,	@backup_directory = N'{1}'
			,	@backup_share = N'{1}'
			,	@backup_job_name = N'LSBackup_{0}'
			,	@backup_retention_period = {3}
			,	@backup_compression = 2
			,	@backup_threshold = 30
			,	@threshold_alert_enabled = 1
			,	@history_retention_period = {3}
			,	@backup_job_id = @LS_BackupJobId OUTPUT
			,	@primary_id = @LS_PrimaryId OUTPUT
			,	@overwrite = 1;

			EXEC msdb.dbo.sp_delete_job
				@job_id = @LS_BackupJobId
			,	@delete_unused_schedule = 1;

			EXEC master.dbo.sp_add_log_shipping_alert_job;

			EXEC master.dbo.sp_add_log_shipping_primary_secondary
				@primary_database = N'{0}'
			,	@secondary_server = N'{2}'
			,	@secondary_database = N'{0}_LS'
			,	@overwrite = 1;"

		$Query_LSSecondary = "ALTER SERVER ROLE [dbcreator] ADD MEMBER [srvDB_Owner];

			DECLARE @backupFile AS nvarchar(4000);

			EXECUTE AS login = 'srvDB_Owner';

			{4}

			REVERT;

			ALTER SERVER ROLE [dbcreator] DROP MEMBER [srvDB_Owner];

			DECLARE @LS_Secondary__CopyJobId AS uniqueidentifier
			,	@LS_Secondary__RestoreJobId AS uniqueidentifier
			,	@LS_Secondary__SecondaryId AS uniqueidentifier
			,	@LS_Add_RetCode AS int;

			EXEC @LS_Add_RetCode = master.dbo.sp_add_log_shipping_secondary_primary
				@primary_server = N'{2}'
			,	@primary_database = N'{0}'
			,	@backup_source_directory = N'{3}'
			,	@backup_destination_directory = N'{1}'
			,	@copy_job_name = N'LSCopy_{2}_{0}'
			,	@restore_job_name = N'LSRestore_{2}_{0}'
			,	@file_retention_period = 1440
			,	@overwrite = 1
			,	@copy_job_id = @LS_Secondary__CopyJobId OUTPUT
			,	@restore_job_id = @LS_Secondary__RestoreJobId OUTPUT
			,	@secondary_id = @LS_Secondary__SecondaryId OUTPUT;

			IF (@@ERROR = 0 AND @LS_Add_RetCode = 0)
			BEGIN
				EXEC msdb.dbo.sp_delete_job
					@job_id = @LS_Secondary__CopyJobId
				,	@delete_unused_schedule = 1;

				EXEC msdb.dbo.sp_delete_job
					@job_id = @LS_Secondary__RestoreJobId
				,	@delete_unused_schedule = 1;
			END

			DECLARE @LS_Add_RetCode2 int;

			IF (@@ERROR = 0 AND @LS_Add_RetCode = 0)
			BEGIN
				EXEC @LS_Add_RetCode2 = master.dbo.sp_add_log_shipping_secondary_database
					@secondary_database = N'{0}_LS'
				,	@primary_server = N'{2}'
				,	@primary_database = N'{0}'
				,	@restore_delay = 0
				,	@restore_mode = 1
				,	@disconnect_users = 1
				,	@restore_threshold = 120
				,	@threshold_alert_enabled = 1
				,	@history_retention_period	= 43200
				,	@overwrite = 1;
			END

			IF (@@ERROR = 0 AND @LS_Add_RetCode = 0)
			BEGIN
				UPDATE msdb.dbo.log_shipping_secondary
				SET last_copied_file = N'{5}'
				,	last_copied_date = GETDATE()
				WHERE secondary_id = @LS_Secondary__SecondaryId
					AND LEN('{5}') > 0;

				UPDATE msdb.dbo.log_shipping_monitor_secondary
				SET last_copied_file = N'{5}'
				,	last_copied_date = GETDATE()
				,	last_copied_date_utc = GETUTCDATE()
				WHERE secondary_id = @LS_Secondary__SecondaryId
					AND LEN('{5}') > 0;
			END"

		if (-not $PSBoundParameters.ContainsKey('ConfigurationOnly')) {
			$ConfigurationOnly = $false
		}

		#$SqlServerModuleVersion = ((Get-Command Restore-SqlDatabase).ImplementingType.Assembly.GetReferencedAssemblies() | Where-Object { $_.Name -eq 'Microsoft.SqlServer.SmoExtended' }).Version.ToString()
		#$AssemblySqlServerSmoExtendedFullName = 'Microsoft.SqlServer.SmoExtended, Version=$SqlServerModuleVersion, Culture=neutral, PublicKeyToken=89845dcd8080cc91'

		$ProgressParameters = @{
			'Id' = 0
			'Activity' = 'Add Log Shipping database'
			'Status' = [string]::Format('Database {0} of {1}', 0, $DatabaseName.Count)
			'CurrentOperation' = ''
			'PercentComplete' = 0
		}

		if ($ConfigurationOnly) {
			[int]$TotalSubSteps = 1
		} else {
			[int]$TotalSubSteps = 6
		}
	}

	process {
		try {
			foreach ($Database in $DatabaseName) {
				$ProgressParameters.Activity = [string]::Format('Database: {0}', $Database)
				$ProgressParameters.Status = [string]::Format('Database {0} of {1}', $DatabaseName.IndexOf($Database) + 1, $DatabaseName.Count)
				$ProgressParameters.CurrentOperation = [string]::Format('Add Log Shipping to database: {0}', $Database)
				$ProgressParameters.PercentComplete = $DatabaseName.IndexOf($Database) / $DatabaseName.Count * 100

				Write-Verbose $ProgressParameters.CurrentOperation
				Write-Progress @ProgressParameters

				[int]$CurrentSubStep = 0

				$ProgressParameters1 = @{
					'Id' = 1
					'ParentID' = 0
					'Activity' = 'Log Shipping database'
					'Status' = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
					'CurrentOperation' = ''
					'PercentComplete' = ($CurrentSubStep - 1)/$TotalSubSteps * 100
				}

				$CurrentSubStep++
				$ProgressParameters1.Activity = [string]::Format('Database: {0}', $Database)
				$ProgressParameters1.Status = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
				$ProgressParameters1.CurrentOperation = [string]::Format('Database: {0}', $Database)
				$ProgressParameters1.PercentComplete = ($CurrentSubStep - 1) / $TotalSubSteps * 100

				Write-Progress @ProgressParameters1

				try {
					$DatabaseObject = $PrimarySmoServer.Databases[$Database]

					if ($null -eq $DatabaseObject) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Database not found.'),
							'1',
							[System.Management.Automation.ErrorCategory]::ObjectNotFound,
							$Database
						)
					}

					if ($DatabaseObject.RecoveryModel -ne 'Full') {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Primary database must be in Full recovery mode.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidOperation,
							$DatabaseObject
						)
					}

					if ($PrimarySmoServer.IsHadrEnabled -and [string]::IsNullOrEmpty($DatabaseObject.AvailabilityGroupName)) {
						$BackupChildPath = Invoke-ReplaceInvalidCharacter -InputString $([string]::Format('{0}.{1}', $DatabaseObject.Name, $PrimarySmoServer.NetName))
					} else {
						$BackupChildPath = Invoke-ReplaceInvalidCharacter -InputString $DatabaseObject.name
					}

					$PrimaryBackupPath = Join-Path -Path $BackupPath -ChildPath $BackupChildPath

					if ($ConfigurationOnly -eq $false) {
						if ($SecondarySmoServer.Databases.Name -contains "$($Database)_LS") {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New("Database $($Database)_LS already exists on $SecondaryServerInstance."),
								'1',
								[System.Management.Automation.ErrorCategory]::ResourceExists,
								"$($Database)_LS"
							)
						}

						#Region Gather backup information
						$CurrentSubStep++
						$ProgressParameters1.Status = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
						$ProgressParameters1.CurrentOperation = 'Gathering Backup Information'
						$ProgressParameters1.PercentComplete = ($CurrentSubStep - 1) / $TotalSubSteps * 100

						Write-Verbose $ProgressParameters1.CurrentOperation
						Write-Progress @ProgressParameters1

						$DatabaseRecoveryParameters = @{
							'SmoServerObject' = $PrimarySmoServer
							'BackupPath' = $BackupPath
							'DatabaseName' = $Database
							'LastDatabaseBackup' = $true
						}

						try {
							$DatabaseRecovery = Get-DatabaseRecovery @DatabaseRecoveryParameters -RecoveryDateTime $(Get-Date)
						}
						catch {
							$DatabaseRecovery = $null

							Write-Verbose 'No suitable backup found.'
						}

						if ($null -eq $DatabaseRecovery) {
							Invoke-SqlInstanceBackup -ServerInstance $PrimaryServerInstance -DatabaseName $Database -BackupType Full

							$DatabaseRecovery = Get-DatabaseRecovery @DatabaseRecoveryParameters -RecoveryDateTime $(Get-Date)
						} elseif ($DatabaseRecovery.where({$_.BackupType -eq 'Database'}).RecoveryModel -ne 'FULL') {
							Invoke-SqlInstanceBackup -ServerInstance $PrimaryServerInstance -DatabaseName $Database -BackupType Full

							$DatabaseRecovery = Get-DatabaseRecovery @DatabaseRecoveryParameters -RecoveryDateTime $(Get-Date)
						} else {
							if ($DatabaseRecovery.where({$_.BackupType -eq 'Database Differential'}).Count -gt 0) {
								if ($DatabaseRecovery.where({$_.BackupType -eq 'Database Differential'}).RecoveryModel -ne 'FULL') {
									Invoke-SqlInstanceBackup -ServerInstance $PrimaryServerInstance -DatabaseName $Database -BackupType Full

									$DatabaseRecovery = Get-DatabaseRecovery @DatabaseRecoveryParameters -RecoveryDateTime $(Get-Date)
								}
							}
						}

						$LastBackupFinishDate = $($DatabaseRecovery.BackupFinishDate | Measure-Object -Maximum).Maximum
						$LastBackupFile = $DatabaseRecovery.where({$_.BackupFinishDate -eq $LastBackupFinishDate})

						$LastBackupDateString = $LastBackupFile.BackupFileName.BaseName.Substring($LastBackupFile.BackupFileName.BaseName.Length - 14, 14)
						$LastBackupDate = [DateTimeOffset]::ParseExact($LastBackupDateString, 'yyyyMMddHHmmss', $null, [System.Globalization.DateTimeStyles]::AssumeUniversal)

						[SqlServerMaintenance.BackupFileInfo[]]$TransactionLogBackups = (Get-SqlBackupFile -Path $PrimaryBackupPath -BackupType log).where({$_.BackupDate -ge $LastBackupDate})
						#EndRegion
					}

					#Region Add log shipping primary database
					$CurrentSubStep++
					$ProgressParameters1.Status = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
					$ProgressParameters1.CurrentOperation = 'Add Log Shipping Primary Database'
					$ProgressParameters1.PercentComplete = ($CurrentSubStep - 1) / $TotalSubSteps * 100

					Write-Verbose $ProgressParameters1.CurrentOperation
					Write-Progress @ProgressParameters1

					$SqlCommandText = [string]::Format($Query_LSPrimary, $Database, $PrimaryBackupPath, $SecondaryServerInstance, $RetainMinutes)

					if ($PSCmdlet.ShouldProcess($PrimaryServerInstance, 'Add Log Shipping Primary')) {
						[void](Invoke-SqlClientNonQuery -ServerInstance $PrimaryServerInstance -DatabaseName master -SqlCommandText $SqlCommandText -CommandTimeout 60)
					}
					#EndRegion

					if ($ConfigurationOnly -eq $false) {
						#Region Stage Backup Files
						$CurrentSubStep++
						$ProgressParameters1.Status = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
						$ProgressParameters1.CurrentOperation = 'Stage Database Backup Files'
						$ProgressParameters1.PercentComplete = ($CurrentSubStep - 1) / $TotalSubSteps * 100

						Write-Verbose $ProgressParameters1.CurrentOperation
						Write-Progress @ProgressParameters1

						$StagingChildPath = Invoke-ReplaceInvalidCharacter -InputString $Database

						$DatabaseStagingPath = Join-Path2 -Path $StagingPath -ChildPath $StagingChildPath

						if (-not $(Test-Path -Path $DatabaseStagingPath -PathType Container)) {
							[void][System.IO.Directory]::CreateDirectory($DatabaseStagingPath)
						}

						foreach ($Item in $DatabaseRecovery) {
							$DestinationFile = Join-Path2 -Path $DatabaseStagingPath -ChildPath $Item.BackupFileName.Name

							Write-Verbose "FileName: $($Item.BackupFileName.Name)"

							[System.IO.File]::Copy($Item.BackupFileName, $DestinationFile, $true)
						}

						if ($TransactionLogBackups.Count -gt 0) {
							foreach ($TransactionLogBackup in $TransactionLogBackups) {
								$DestinationFile = Join-Path2 -Path $DatabaseStagingPath -ChildPath $TransactionLogBackup.Name

								Write-Verbose "FileName: $($TransactionLogBackup.Name)"

								[System.IO.File]::Copy($TransactionLogBackup.FullName, $DestinationFile, $true)
							}

							$LastTransactionLogBackupDate = ($TransactionLogBackups.where({$_.BackupDate -ge $LastBackupDate}).BackupDate | Measure-Object -Maximum).Maximum
							$LastTransactionLogBackup = $TransactionLogBackups.where({$_.BackupDate -eq $LastTransactionLogBackupDate}).FullName

						} else {
							$LastTransactionLogBackup = ''
						}
						#EndRegion

						#Region Add log shipping secondary database
						$CurrentSubStep++
						$ProgressParameters1.Status = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
						$ProgressParameters1.CurrentOperation = 'Add Log Shipping Secondary Database'
						$ProgressParameters1.PercentComplete = ($CurrentSubStep - 1) / $TotalSubSteps * 100

						Write-Verbose $ProgressParameters1.CurrentOperation
						Write-Progress @ProgressParameters1

						$SqlBackupFiles = Get-SqlBackupFile -Path $DatabaseStagingPath

						$DatabaseRecoveryParameters = @{
							'SmoServerObject' = $SecondarySmoServer
							'BackupFileInfo' = $SqlBackupFiles
							'NewDatabaseName' = "$($Database)_LS"
							'SkipLogChainCheck' = $true
							'NoRecovery' = $true
						}

						$DatabaseRecovery = Get-DatabaseRecovery @DatabaseRecoveryParameters

						if ($PSBoundParameters.ContainsKey('AvailabilityGroupName')) {
							$FormatStringArray = @(
								$Database,
								(Join-Path -Path $StagingPath -ChildPath $Database),
								$AvailabilityGroupName,
								$PrimaryBackupPath,
								($DatabaseRecovery.RestoreDML -join "`r`n"),
								$LastTransactionLogBackup
							)
						} else {
							$FormatStringArray = @(
								$Database,
								(Join-Path -Path $StagingPath -ChildPath $Database),
								$PrimaryServerInstance,
								$PrimaryBackupPath,
								($DatabaseRecovery.RestoreDML -join "`r`n"),
								$LastTransactionLogBackup
							)
						}

						$SqlCommandText = [string]::Format($Query_LSSecondary, $FormatStringArray)

						if ($PSCmdlet.ShouldProcess($PrimaryServerInstance, 'Add Log Shipping Secondary')) {
							[void](Invoke-SqlClientNonQuery -ServerInstance $SecondaryServerInstance -DatabaseName master -SqlCommandText $SqlCommandText -CommandTimeout 0)
						}
						#EndRegion

						#Region Perform initial log shipping restore
						$CurrentSubStep++
						$ProgressParameters1.Status = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
						$ProgressParameters1.CurrentOperation = 'Perform initial log shipping restore'
						$ProgressParameters1.PercentComplete = ($CurrentSubStep - 1) / $TotalSubSteps * 100

						Write-Verbose $ProgressParameters1.CurrentOperation
						Write-Progress @ProgressParameters1

						if ($TransactionLogBackups.Count -gt 0) {
							Invoke-LogShipping -ServerInstance $SecondaryServerInstance -DatabaseName $Database -LSOperation Restore
						}
						#EndRegion
					}
				}
				catch {
					$PSCmdlet.WriteError($_)
				}
				finally {
					Write-Progress -Id 1 -Activity "Database: $Database" -Completed
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			Write-Progress -Id 0 -Activity 'Log Shipping database' -Completed

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $PrimarySmoServer
				Disconnect-SmoServer -SmoServerObject $SecondarySmoServer
			}
		}
	}

	end {
	}
}

function Checkpoint-SqlDatabaseSnapshot {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.DatabaseSnapshot])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseSnapshotName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$DatabaseObject = Get-SmoDatabaseObject -SmoServerObject $SmoServer -DatabaseName $DatabaseName
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}

		$DDLFormatString = 'USE master;
		CREATE DATABASE [{0}]
		ON
			{1}
		AS SNAPSHOT OF [{2}];'
		$LogicalFileNameFormatString = "(NAME = {0}, FILENAME = '{1}.ss')"
	}

	process {
		try {
			$LogicalFileList = [System.Collections.Generic.List[string]]::New()

			foreach ($DataFile in $DatabaseObject.FileGroups.Files) {
				[System.IO.FileInfo]$FileName = $DataFile.FileName
				$SnapshotFileName = Join-Path2 -Path $FileName.DirectoryName -ChildPath $([string]::Concat($DatabaseSnapshotName, '_', $FileName.BaseName))
				$LogicalFileList.Add([string]::Format($LogicalFileNameFormatString, $DataFile.Name, $SnapshotFileName))
			}

			$SnapshotDDL = [string]::Format($DDLFormatString, $DatabaseSnapshotName, [string]::Join("`n,`t", $LogicalFileList), $DatabaseName)

			if ($PSCmdlet.ShouldProcess($DatabaseSnapshotName, 'Create Database Snapshot')) {
				[void]$(Invoke-SqlClientNonQuery -SqlConnection $SmoServer.ConnectionContext.SqlConnectionObject -SqlCommandText $SnapshotDDL -CommandTimeout 0)

				$SmoServer.Databases.Refresh()

				Get-SqlDatabaseSnapshot -SmoServerObject $SmoServer -DatabaseSnapshotName $DatabaseSnapshotName
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Find-OrphanedDatabasePhysicalFile {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.OrphanedDatabasePhysicalFile])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}

		$ScriptBlock = {
			param($Path)

			$FileInfo = [System.IO.FileInfo[]][System.IO.Directory]::GetFiles($Path)

			$FileInfo.Where({$_.Extension -ne '.cer'})
		}
	}

	process {
		try {
			$Databases = $SmoServer.Databases.where({$_.Status -eq 'Normal'})

			if ($SmoServer.Databases.where({$_.Status -ne 'Normal'}).Count -gt 0) {
				Write-Warning 'Offline databases exists.  Results will include files from offline databases.'
			}

			$SqlFileList = [System.Collections.Generic.List[string]]::New()

			$SqlFileList.AddRange([string[]]$Databases.FileGroups.Files.FileName)
			$SqlFileList.AddRange([string[]]$Databases.LogFiles.FileName)

			$Paths = @(
				$SmoServer.DefaultFile
				$SmoServer.DefaultLog
				$SmoServer.MasterDBLogPath
				$SmoServer.MasterDBPath
			)

			$PathList = [System.Collections.Generic.List[string]]::New()

			foreach ($Path in $Paths) {
				if (-not $PathList.Contains($Path.Trim('\'))) {
					$PathList.Add($Path.Trim('\'))
				}
			}

			foreach ($Path in $SmoServer.Databases.PrimaryFilePath) {
				if (-not $PathList.Contains($Path.Trim('\'))) {
					$PathList.Add($Path.Trim('\'))
				}
			}

			if ($SmoServer.NetName -ne [System.Net.Dns]::GetHostName()) {
				$PSSession = New-PSSession -ComputerName $SmoServer.Information.FullyQualifiedNetName
			}

			$PhysicalFileList = [System.Collections.Generic.List[string]]::New()

			foreach ($Path in $PathList) {
				$CommandParameters = @{
					ScriptBlock = $ScriptBlock
					ArgumentList = @($Path)
				}

				if ($SmoServer.NetName -ne [System.Net.Dns]::GetHostName()) {
					$CommandParameters.Add('Session', $PSSession)
				}

				$Files = Invoke-Command @CommandParameters

				$PhysicalFileList.AddRange([string[]]$Files.FullName)
			}

			$PhysicalFileList.Sort()

			foreach ($File in $PhysicalFileList) {
				if ($File -notin $SqlFileList) {
					[SqlServerMaintenance.OrphanedDatabasePhysicalFile]::New($File)
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Find-OrphanedDatabaseUser {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.OrphanedDatabaseUser])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if (-not $PSBoundParameters.ContainsKey('DatabaseName')) {
				$DatabaseName = $SmoServer.Databases.Name
			}

			foreach ($Database in $DatabaseName) {
				$DatabaseObject = Get-SmoDatabaseObject -SmoServerObject $SmoServer -DatabaseName $Database

				if ($DatabaseObject.Status -ne 'Normal') {
					Write-Error "Database $Database is not online."

					continue
				}

				$DatabaseUsers = $DatabaseObject.Users.where({$_.Name -eq 'dbo' -or ($_.IsSystemObject -eq $false -and $_.AuthenticationType -NotIn @('Database', 'None'))})

				foreach ($DatabaseUser in $DatabaseUsers) {
					$OrphanedDatabaseUser = [SqlServerMaintenance.OrphanedDatabaseUser]::New($DatabaseUser)

					$OrphanedDatabaseUser.AuthenticationType = $DatabaseUser.AuthenticationType
					$OrphanedDatabaseUser.LoginType = $DatabaseUser.LoginType

					$Login = $SmoServer.Logins.where({[System.BitConverter]::ToString($_.Sid).Replace("-", "") -eq $OrphanedDatabaseUser.SidString})

					if ($Login.Count -eq 0) {
						$OrphanedDatabaseUser
					} else {
						$OrphanedDatabaseUser.LoginName = $Login.Name

						if ($DatabaseUser.Name -ne 'dbo' -and $DatabaseUser.Name -ne $Login.Name) {
							$OrphanedDatabaseUser
						}
					}
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Get-AvailabilityGroupDatabaseReplicaStatus {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.DatabaseReplicaState])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AvailabilityGroupName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Refresh()
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$AvailabilityGroupParameters = @{
				'SmoServerObject' = $SmoServer
			}

			if ($PSBoundParameters.ContainsKey('AvailabilityGroupName')) {
				$AvailabilityGroupParameters.Add('AvailabilityGroupName', $AvailabilityGroupName)
			}

			$AvailabilityGroup = Get-SmoAvailabilityGroup @AvailabilityGroupParameters

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Output = $AvailabilityGroup.DatabaseReplicaStates.where({$_.AvailabilityDatabaseName -eq $DatabaseName})
			} else {
				$Output = $AvailabilityGroup.DatabaseReplicaStates
			}

			$Output
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					Disconnect-SmoServer -SmoServerObject $SmoServer
				}
			}
		}
	}

	end {
	}
}

function Get-AvailabilityGroupSeedingStatus {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Data.DataRow])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName
	)

	begin {
		$StatusFormatString = "SELECT dhas.ag_db_id
			,	ag.name AS AvailabilityGroupName
			,	adb.database_name
			,	dhas.start_time
			,	dhas.completion_time
			,	dhas.current_state
			,	dhas.performed_seeding
			,	dhas.failure_state
			,	dhas.failure_state_desc
			,	ss.internal_state_desc
			,	ss.remote_machine_name
			,	DatabaseSizeMB = ss.database_size_bytes / 1045876
			,	TransferredSizeMB = ss.transferred_size_bytes / 1045876
			,	TransferRateMBS = ss.transfer_rate_bytes_per_second / 1045876
			,	TimeRemainingSec = CASE WHEN ss.transfer_rate_bytes_per_second = 0 THEN NULL ELSE (ss.database_size_bytes - ss.transferred_size_bytes) / ss.transfer_rate_bytes_per_second END
			,	TimeRemaining = CASE WHEN ss.transfer_rate_bytes_per_second = 0 THEN NULL
				ELSE
					CASE WHEN ((ss.database_size_bytes - ss.transferred_size_bytes) / ss.transfer_rate_bytes_per_second) < 360000 THEN '0' ELSE '' END
						+ RTRIM(((ss.database_size_bytes - ss.transferred_size_bytes) / ss.transfer_rate_bytes_per_second) / 3600)
						+ ':' + RIGHT('0' + RTRIM(((ss.database_size_bytes - ss.transferred_size_bytes) / ss.transfer_rate_bytes_per_second) % 3600 / 60), 2)
						+ ':' + RIGHT('0' + RTRIM(((ss.database_size_bytes - ss.transferred_size_bytes) / ss.transfer_rate_bytes_per_second) % 60), 2)
				END
			FROM sys.dm_hadr_automatic_seeding dhas
			JOIN sys.availability_databases_cluster adb ON dhas.ag_db_id = adb.group_database_id
			JOIN sys.availability_groups ag ON dhas.ag_id = ag.group_id
			LEFT JOIN sys.dm_hadr_physical_seeding_stats ss ON dhas.operation_id = ss.local_physical_seeding_id{0}
			ORDER BY ag.name
			,	adb.database_name
			,	dhas.completion_time DESC;"

		$WhereClauseFormatString = "`r`n`t`tWHERE adb.database_name = N'{0}'"
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$WhereClause = [string]::Format($WhereClauseFormatString, $DatabaseName)
			} else {
				$WhereClause = ''
			}

			$SqlClientDataSetParameters = @{
				'DatabaseName' = 'master'
				'SqlCommandText' = [string]::Format($StatusFormatString, $WhereClause)
				'OutputAs' = 'DataRow'
			}

			if ($PSBoundParameters.ContainsKey('ServerInstance')) {
				$SqlClientDataSetParameters.Add('ServerInstance', $ServerInstance)
			}

			if ($PSBoundParameters.ContainsKey('SqlConnection')) {
				$SqlClientDataSetParameters.Add('SqlConnection', $SqlConnection)
			}

			$StatusDataTable = Get-SqlClientDataSet @SqlClientDataSetParameters

			$StatusDataTable
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-DatabasePrimaryFile {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'None',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.DatabasePrimaryFile])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo]$MDFPath
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName 'master'
			}
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SqlConnection) {
					Disconnect-SqlServerInstance -SqlConnection $SqlConnection
				}
			}

			throw $ErrorRecord
		}

		$CheckPrimaryFileFormatString = "DBCC CHECKPRIMARYFILE(N'{0}', {1}) WITH NO_INFOMSGS;"
	}

	process {
		try {
			#Region Test for Primary Database File
			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'SqlCommandText' = [string]::Format($CheckPrimaryFileFormatString, $MDFPath, 0)
				'OutputAs' = 'DataRow'
			}

			$SqlClientDataSet = Get-SqlClientDataSet @SqlClientDataSetParameters

			if ($SqlClientDataSet.IsMDF -eq 0) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File is not a primary database file.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$MDFPath
				)
			}
			#EndRegion

			#Region Database Information
			$SqlClientDataSetParameters.SqlCommandText = [string]::Format($CheckPrimaryFileFormatString, $MDFPath, 2)

			$DatabaseInformation = Get-SqlClientDataSet @SqlClientDataSetParameters

			$DatabasePrimaryFile = [SqlServerMaintenance.DatabasePrimaryFile]@{
				DatabaseName = $DatabaseInformation.where({$_.property -eq 'Database name'}).value
				DatabaseVersion = $DatabaseInformation.where({$_.property -eq 'Database version'}).value
				Collation = $DatabaseInformation.where({$_.property -eq 'Collation'}).value
			}

			$SqlClientDataSetParameters.SqlCommandText = [string]::Format($CheckPrimaryFileFormatString, $MDFPath, 3)

			$DataFileInformation = Get-SqlClientDataSet @SqlClientDataSetParameters

			$LogicalFiles = [System.Collections.Generic.List[SqlServerMaintenance.DatabasePrimaryLogicalFile]]::New()

			foreach ($Row in $DataFileInformation) {
				$LogicalFile = [SqlServerMaintenance.DatabasePrimaryLogicalFile]::New()

				$LogicalFile.Status = $Row.status
				$LogicalFile.FileID = $Row.fileid
				$LogicalFile.LogicalFileName = $Row.name.Trim()
				$LogicalFile.FileName = $Row.filename.Trim()

				$LogicalFiles.Add($LogicalFile)
			}

			$DatabasePrimaryFile.LogicalFile = $LogicalFiles
			#EndRegion

			$DatabasePrimaryFile
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Get-DatabaseRecovery {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'None',
		DefaultParameterSetName = 'ServerInstanceWithStopAt'
	)]

	[OutputType([SqlServerMaintenance.Restore])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceBackupFileInfo'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopAt'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopBeforeMark'
		)]
		[ValidateLength(1, 128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerBackupFileInfo'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopAt'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopBeforeMark'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$TimeZoneId,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopAt'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopBeforeMark'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopAt'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopBeforeMark'
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo]$BackupPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopAt'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopBeforeMark'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopAt'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopBeforeMark'
		)]
		[System.IO.FileInfo[]]$Exclude,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopAt'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopBeforeMark'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopAt'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopBeforeMark'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$NewDatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopAt'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopAt'
		)]
		[ValidateScript({
			if (-not $($_ -le [System.DateTimeOffset]::Now)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New('Date and time must be in the past.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$_
				)
			}
			return $true
		})]
		[System.DateTimeOffset]$RecoveryDateTime,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$LastDatabaseBackup,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$Stats = 5,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Replace,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopBeforeMark'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopBeforeMark'
		)]
		[ValidateLength(1, 128)]
		[string]$StopBeforeMark,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceWithStopBeforeMark'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerWithStopBeforeMark'
		)]
		[ValidateScript({
			if (-not $($_ -le [System.DateTimeOffset]::Now)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New('Date and time must be in the past.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$_
				)
			}
			return $true
		})]
		[System.DateTimeOffset]$MarkDateTime,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceBackupFileInfo'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerBackupFileInfo'
		)]
		[SqlServerMaintenance.BackupFileInfo[]]$BackupFileInfo,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstanceBackupFileInfo'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerBackupFileInfo'
		)]
		[switch]$SkipLogChainCheck,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$NoRecovery
	)

	begin {
		try {
			$BackupFileInfoParameterSets = @('ServerInstanceBackupFileInfo', 'SmoServerBackupFileInfo')
			$SmoParameterSets = @('SmoServerBackupFileInfo', 'SmoServerWithStopAt', 'SmoServerWithStopBeforeMark')
			$StopBeforeMarkParameterSets = @('ServerInstanceWithStopBeforeMark', 'SmoServerWithStopBeforeMark')
			$StopAtParameterSets = @('ServerInstanceWithStopAt', 'SmoServerWithStopAt')

			if ($PSCmdlet.ParameterSetName -NotIn $SmoParameterSets) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance -DatabaseName master
			}

			if ($PSCmdlet.ParameterSetName -in $StopBeforeMarkParameterSets) {
				$RecoveryDateTime = $MarkDateTime
			}

			if ($PSCmdlet.ParameterSetName -in $BackupFileInfoParameterSets) {
				$DatabaseBackupPath = Split-Path -LiteralPath $BackupFileInfo[0].FullName
				[System.DateTimeOffset]$RecoveryDateTime = Get-Date
			} else {
				$PathParameters = @{
					'Path' = (Resolve-Path -Path $BackupPath).ProviderPath
					'ChildPath' = Invoke-ReplaceInvalidCharacter -InputString $DatabaseName
					'ErrorAction' = 'Stop'
				}

				$DatabaseBackupPath = (Resolve-Path -Path (Join-Path @PathParameters)).ProviderPath
			}

			if ($PSBoundParameters.ContainsKey('TimeZoneId')) {
				$TimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneId)
			} else{
				$TimeZone = Get-SqlServerTimeZone -SmoServerObject $SmoServerObject
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -NotIn $SmoParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}

		[int]$CurrentStep = 0

		if ($LastDatabaseBackup) {
			[int]$TotalSteps = 2
		} else {
			[int]$TotalSteps = 3
		}

		$ProgressParameters = @{
			'Id' = 0
			'Activity' = 'Building Database Recovery'
			'Status' = [string]::Format('Step {0} of {1}', $CurrentStep, $TotalSteps)
			'CurrentOperation' = ''
			'PercentComplete' = 0
		}

		$RestoreList = [System.Collections.Generic.List[PsCustomObject]]::New()
	}

	process {
		try {
			#Region Build Full Backup Restore
			$CurrentStep++
			$ProgressParameters.Status = [string]::Format('Step {0} of {1}', $CurrentStep, $TotalSteps)
			$ProgressParameters.CurrentOperation = 'Getting Full backup files'
			$ProgressParameters.PercentComplete = ($CurrentStep - 1) / $TotalSteps * 100

			Write-Verbose $ProgressParameters.CurrentOperation
			Write-Progress @ProgressParameters

			if ($PSCmdlet.ParameterSetName -In $BackupFileInfoParameterSets) {
				$FullBackups = $BackupFileInfo.where({$_.Extension -eq '.bak'}) | Sort-Object -Property BackupDate -Descending
			} else {
				$SqlBackupFileParameters = @{
					'Path' = $DatabaseBackupPath
					'BackupType' = 'full'
				}

				if ($PSBoundParameters.ContainsKey('Exclude')) {
					$SqlBackupFileParameters.Add('Exclude', $Exclude)
				}

				$FullBackups = $(Get-SqlBackupFile @SqlBackupFileParameters).where({$_.BackupDate -lt $RecoveryDateTime}) | Sort-Object -Property BackupDate -Descending
			}

			foreach ($FullBackup in $FullBackups) {
				$FullBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $FullBackup.FullName -SmoServerObject $SmoServerObject

				if ($($FullBackupHeader | Measure-Object).Count -gt 1) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Multiple backups in backup file is not supported'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$FullBackup.FullName
					)
				}

				if ($FullBackupHeader.IsCopyOnly) {
					$FullBackupHeader = $null
					$LastFullBackup = $null
				} else {
					$LastFullBackup = $FullBackup

					break
				}
			}

			if ($null -eq $FullBackups -or $null -eq $LastFullBackup) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('No suitable Full Backup found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseBackupPath
				)
			}

			$RestoreOptions = [System.Collections.Generic.List[string]]@(
				[string]::Format('FILE = {0}', $FullBackupHeader.Position)
				'NORECOVERY',
				[string]::Format('STATS = {0}', $Stats)
			)

			if ($PSBoundParameters.ContainsKey('Replace')) {
				[void]$RestoreOptions.Add('REPLACE')
			}

			if ($PSBoundParameters.ContainsKey('NewDatabaseName')) {
				$EscapedDatabaseName = Invoke-ReplaceInvalidCharacter -InputString $NewDatabaseName

				$BackupFileList = Get-SmoBackupFileList -DatabaseBackupPath $LastFullBackup.FullName -SmoServerObject $SmoServerObject

				$FileGroupObjectGroups = $BackupFileList | Group-Object -Property FileGroupName

				foreach ($FileGroupObjectGroup in $FileGroupObjectGroups) {
					$i = 0

					foreach ($LogicalFile in $FileGroupObjectGroup.Group) {
						$i++

						[System.IO.FileInfo]$PhysicalFile = $LogicalFile.PhysicalName

						$JoinPathParameters = @{}

						switch ($LogicalFile.Type) {
							'D' {
								if (Test-Path -Path $PhysicalFile.Directory.FullName) {
									$JoinPathParameters.Add('Path', $PhysicalFile.Directory.FullName)
								} else {
									$JoinPathParameters.Add('Path', $SmoServerObject.DefaultFile)
								}

								if ($FileGroupObjectGroup.Count -gt 1) {
									$LogicalFileNumber = $i
								} else {
									$LogicalFileNumber = $null
								}

								if ($LogicalFile.FileGroupName -eq 'PRIMARY') {
									$JoinPathParameters.Add('ChildPath', [string]::Format('{0}{1}{2}', $EscapedDatabaseName, $LogicalFileNumber, $PhysicalFile.Extension))
								} else {
									$JoinPathParameters.Add('ChildPath', [string]::Format('{0}_{1}{2}{3}', $EscapedDatabaseName, $(Invoke-ReplaceInvalidCharacter -InputString $LogicalFile.FileGroupName), $LogicalFileNumber, $PhysicalFile.Extension))
								}
							}
							'L' {
								if (Test-Path -Path $PhysicalFile.Directory.FullName) {
									$JoinPathParameters.Add('Path', $PhysicalFile.Directory.FullName)
								} else {
									$JoinPathParameters.Add('Path', $SmoServerObject.DefaultLog)
								}

								$JoinPathParameters.Add('ChildPath', [string]::Format('{0}_log{1}', $EscapedDatabaseName, $PhysicalFile.Extension))
							}
							'S' {
								if (Test-Path -Path $PhysicalFile.Directory.FullName) {
									$JoinPathParameters.Add('Path', $PhysicalFile.Directory.FullName)
								} else {
									$JoinPathParameters.Add('Path', $SmoServerObject.DefaultFile)
								}

								$JoinPathParameters.Add('ChildPath', [string]::Format('{0}_{1}_{2}', $EscapedDatabaseName, $(Invoke-ReplaceInvalidCharacter -InputString $LogicalFile.FileGroupName), $(Invoke-ReplaceInvalidCharacter -InputString $LogicalFile.LogicalName)))

								if ($JoinPathParameters.Path.Length + $JoinPathParameters.ChildPath.Length + 1 -gt 160) {
									$JoinPathParameters.ChildPath = [string]::Format('{0}_{1}', $EscapedDatabaseName, [Guid]::NewGuid().ToString("N"))

									if ($JoinPathParameters.Path.Length + $EscapedDatabaseName.Length + 37 -gt 160) {
										$JoinPathParameters.ChildPath = $JoinPathParameters.ChildPath.SubString(0, 159 - $JoinPathParameters.Path.Length)
									}
								}
							}
							Default {
								throw [System.Management.Automation.ErrorRecord]::New(
									[Exception]::New('Logical file type not supported.'),
									'1',
									[System.Management.Automation.ErrorCategory]::NotImplemented,
									$LogicalFile.Type
								)
							}
						}

						$NewPhysicalFileName = Join-Path @JoinPathParameters

						[void]$RestoreOptions.Add([string]::Format("MOVE '{0}' TO '{1}'", $LogicalFile.LogicalName, $NewPhysicalFileName))
					}
				}
			} else {
				if ($PSBoundParameters.ContainsKey('DatabaseName')) {
					$NewDatabaseName = $DatabaseName
				} else {
					$NewDatabaseName = $FullBackupHeader.DatabaseName
				}
			}

			$RestoreList.Add($([PsCustomObject]@{
				'DatabaseName' = $NewDatabaseName
				'BackupDatabaseName' = $FullBackupHeader.DatabaseName
				'DatabaseGUID' = $FullBackupHeader.BindingID
				'BackupFileName' = $LastFullBackup
				'BackupStartDate' = $FullBackupHeader.BackupStartDate
				'BackupFinishDate' = $FullBackupHeader.BackupFinishDate
				'BackupPosition' = $FullBackupHeader.Position
				'BackupType' = $FullBackupHeader.BackupTypeDescription
				'RecoveryModel' = $FullBackupHeader.RecoveryModel
				'FirstLSN' = $FullBackupHeader.FirstLSN
				'LastLSN' = $FullBackupHeader.LastLSN
				'CheckpointLSN' = $FullBackupHeader.CheckpointLSN
				'DatabaseBackupLSN' = $FullBackupHeader.DatabaseBackupLSN
				'RestoreOptions' = $RestoreOptions
			}))

			$LastBackupHeader = $FullBackupHeader

			Write-Verbose "Filename: $($LastFullBackup.Name)"
			#EndRegion

			#Region Build Diff Backup Restore
			$CurrentStep++
			$ProgressParameters.Status = [string]::Format('Step {0} of {1}', $CurrentStep, $TotalSteps)
			$ProgressParameters.CurrentOperation = 'Getting Differential backup files'
			$ProgressParameters.PercentComplete = ($CurrentStep - 1) / $TotalSteps * 100

			Write-Verbose $ProgressParameters.CurrentOperation
			Write-Progress @ProgressParameters

			if ($PSCmdlet.ParameterSetName -In $BackupFileInfoParameterSets) {
				[SqlServerMaintenance.BackupFileInfo[]]$DiffBackups = $BackupFileInfo.where({$_.Extension -eq '.dif'})
			} else {
				$SqlBackupFileParameters.BackupType = 'diff'

				$DiffBackups = Get-SqlBackupFile @SqlBackupFileParameters
				[SqlServerMaintenance.BackupFileInfo[]]$DiffBackups = $DiffBackups.where({$_.BackupDate -gt $LastBackupHeader.BackupStartDate -and $_.BackupDate -lt $RecoveryDateTime.UtcDateTime}) | Sort-Object -Property Name -Descending
			}

			foreach ($DiffBackup in $DiffBackups) {
				$DiffBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $DiffBackup.FullName -SmoServerObject $SmoServerObject

				if ($($DiffBackupHeader | Measure-Object).Count -gt 1) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Multiple backups in backup file is not supported'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$DiffBackup.FullName
					)
				}

				if (-not $SkipLogChainCheck -and $DiffBackupHeader.DatabaseBackupLSN -ne $LastBackupHeader.CheckpointLSN) {
					Write-Warning "Diff Backup Name: $($DiffBackup.Name)"
					Write-Warning 'Differential backup chain broken'
					Write-Warning "Full Backup Checkpoint LSN: $($LastBackupHeader.CheckpointLSN)"
					Write-Warning "Diff Database Backup LSN: $($DiffBackupHeader.DatabaseBackupLSN)"
				} else {
					$LastBackupHeader = $DiffBackupHeader

					$RestoreOptions = [System.Collections.Generic.List[string]]@(
						[string]::Format('FILE = {0}', $DiffBackupHeader.Position)
						[string]::Format('STATS = {0}', $Stats)
					)

					if (-not $LastDatabaseBackup) {
						[void]$RestoreOptions.Add('NORECOVERY')
					}

					$RestoreList.Add($([PsCustomObject]@{
						'DatabaseName' = $NewDatabaseName
						'BackupDatabaseName' = $LastBackupHeader.DatabaseName
						'DatabaseGUID' = $LastBackupHeader.BindingID
						'BackupFileName' = $DiffBackup
						'BackupStartDate' = $LastBackupHeader.BackupStartDate
						'BackupFinishDate' = $LastBackupHeader.BackupFinishDate
						'BackupPosition' = $LastBackupHeader.Position
						'BackupType' = $LastBackupHeader.BackupTypeDescription
						'RecoveryModel' = $LastBackupHeader.RecoveryModel
						'FirstLSN' = $LastBackupHeader.FirstLSN
						'LastLSN' = $LastBackupHeader.LastLSN
						'CheckpointLSN' = $LastBackupHeader.CheckpointLSN
						'DatabaseBackupLSN' = $LastBackupHeader.DatabaseBackupLSN
						'RestoreOptions' = $RestoreOptions
					}))

					Write-Verbose "Filename: $($DiffBackup.Name)"

					break
				}
			}
			#EndRegion

			#Region Build Log Backup Restore
			if ($FullBackupHeader.RecoveryModel -ne 'SIMPLE' -and -not $LastDatabaseBackup) {
				$CurrentStep++
				$ProgressParameters.Status = [string]::Format('Step {0} of {1}', $CurrentStep, $TotalSteps)
				$ProgressParameters.CurrentOperation = 'Getting transaction log backup files'
				$ProgressParameters.PercentComplete = ($CurrentStep - 1) / $TotalSteps * 100

				Write-Verbose $ProgressParameters.CurrentOperation
				Write-Progress @ProgressParameters

				if ($PSBoundParameters.ContainsKey('Exclude')) {
					$SqlBackupFileParameters.Remove('Exclude')
				}

				if ($PSCmdlet.ParameterSetName -In $BackupFileInfoParameterSets) {
					[SqlServerMaintenance.BackupFileInfo[]]$TrnBackups = $BackupFileInfo.where({$_.Extension -eq '.trn'}) | Sort-Object -Property Name
				} else {
					$SqlBackupFileParameters.BackupType = 'log'

					$TrnBackups = Get-SqlBackupFile @SqlBackupFileParameters
					[SqlServerMaintenance.BackupFileInfo[]]$TrnBackups = $TrnBackups.where({$_.BackupDate -ge $LastBackupHeader.BackupStartDate}) | Sort-Object -Property Name
				}

				$TotalSubSteps = [Math]::Ceiling($(New-TimeSpan -Start $LastBackupHeader.BackupStartDate -End $RecoveryDateTime.UtcDateTime).TotalMinutes / 15)
				$CurrentSubStep = 0

				$ProgressParameters1 = @{
					'Id' = 1
					'ParentID' = 0
					'Activity' = 'Evaluate transaction log backups'
					'Status' = [string]::Format('Step {0} of {1}', $CurrentSubStep, $TotalSubSteps)
					'CurrentOperation' = ''
					'PercentComplete' = ($CurrentSubStep - 1) / $TotalSubSteps * 100
				}

				:ParentLoop foreach ($TrnBackup in $TrnBackups) {
					$ProgressParameters1.Activity = 'Evaluating transaction log backups'
					$ProgressParameters1.Status = [string]::Format('File {0} of {1}', $TrnBackups.IndexOf($TrnBackup) + 1, $TrnBackups.Count)
					$ProgressParameters1.CurrentOperation = [string]::Format('File Name: {0}', $TrnBackup.Name)
					$ProgressParameters1.PercentComplete = $TrnBackups.IndexOf($TrnBackup) / $TrnBackups.Count * 100

					Write-Verbose $ProgressParameters1.CurrentOperation
					Write-Progress @ProgressParameters1

					$TrnBackupHeaders = Get-SmoBackupHeader -DatabaseBackupPath $TrnBackup.FullName -SmoServerObject $SmoServerObject | Sort-Object -Property Position

					foreach ($TrnBackupHeader in $TrnBackupHeaders) {
						$BackupFinishDate = [DateTimeOffset]::New($TrnBackupHeader.BackupFinishDate, $TimeZone.GetUtcOffset($TrnBackupHeader.BackupFinishDate))

						$RestoreOptions = [System.Collections.Generic.List[string]]@(
							[string]::Format('FILE = {0}', $TrnBackupHeader.Position),
							[string]::Format('STATS = {0}', $Stats)
						)

						switch ($LastBackupHeader.BackupTypeDescription) {
							'DATABASE' {
								if (-not $SkipLogChainCheck) {
									if ($TrnBackupHeader.FirstLSN -gt $LastBackupHeader.CheckpointLSN) {
										throw [System.Management.Automation.ErrorRecord]::new(
											[Exception]::New([string]::Format('Transaction log chain broken between database backup {0} and transaction log backup {1}.', $LastFullBackup.Name, $TrnBackup.Name)),
											'1',
											[System.Management.Automation.ErrorCategory]::InvalidResult,
											$TrnBackup.Name
										)
									}
								}

								if ($TrnBackupHeader.LastLSN -lt $LastBackupHeader.LastLSN) {
									Write-Warning -Message ([string]::Format('Transaction log too early.  Skipping file {0}.', $TrnBackup.FullName))

									$LastBackupHeader = $TrnBackupHeader

									continue ParentLoop
								}
							}
							'TRANSACTION LOG' {
								if (-not $SkipLogChainCheck) {
									if ($LastBackupHeader.LastLSN -ne $TrnBackupHeader.FirstLSN) {
										throw [System.Management.Automation.ErrorRecord]::new(
											[Exception]::New([string]::Format('Transaction log chain broken at transaction log backup {0}.', $TrnBackup.Name)),
											'1',
											[System.Management.Automation.ErrorCategory]::InvalidResult,
											$TrnBackup.Name
										)
									}
								}
							}
							'DATABASE DIFFERENTIAL' {
								if (-not $SkipLogChainCheck) {
									if ($TrnBackupHeader.FirstLSN -gt $LastBackupHeader.CheckpointLSN) {
										throw [System.Management.Automation.ErrorRecord]::new(
											[Exception]::New([string]::Format('Transaction log chain broken between differential backup {0} and transaction log backup {1}.', $DiffBackup.Name, $TrnBackup.Name)),
											'1',
											[System.Management.Automation.ErrorCategory]::InvalidResult,
											$TrnBackup.Name
										)
									}
								}

								if ($TrnBackupHeader.LastLSN -lt $LastBackupHeader.LastLSN) {
									Write-Warning -Message ([string]::Format('Transaction log too early.  Skipping file {0}.', $TrnBackup.FullName))

									$LastBackupHeader = $TrnBackupHeader

									continue ParentLoop
								}
							}
							Default {
								throw [System.Management.Automation.ErrorRecord]::New(
									[Exception]::New('Unsupported backup type.'),
									'1',
									[System.Management.Automation.ErrorCategory]::NotImplemented,
									$LastBackupHeader.BackupTypeDescription
								)
							}
						}

						if ($BackupFinishDate -lt $RecoveryDateTime) {
							[void]$RestoreOptions.Add('NORECOVERY')
						} else {
							switch ($PSCmdlet.ParameterSetName) {
								{$_ -in $StopBeforeMarkParameterSets} {
									[void]$RestoreOptions.Add([string]::Format("STOPBEFOREMARK = '{0}' AFTER '{1}'", $StopBeforeMark, $RecoveryDateTime.LocalDatetime.ToString()))
								}
								{$_ -in $StopAtParameterSets} {
									[void]$RestoreOptions.Add([string]::Format("STOPAT = '{0}'", $RecoveryDateTime.LocalDatetime.ToString()))
								}
								Default {
									throw [System.Management.Automation.ErrorRecord]::New(
										[Exception]::New('Unhandled parameter set.'),
										'1',
										[System.Management.Automation.ErrorCategory]::InvalidOperation,
										$PSCmdlet.ParameterSetName
									)
								}
							}
						}

						$RestoreList.Add($([PsCustomObject]@{
							'DatabaseName' = $NewDatabaseName
							'BackupDatabaseName' = $LastBackupHeader.DatabaseName
							'DatabaseGUID' = $TrnBackupHeader.BindingID
							'BackupFileName' = $TrnBackup
							'BackupStartDate' = $TrnBackupHeader.BackupStartDate
							'BackupFinishDate' = $TrnBackupHeader.BackupFinishDate
							'BackupPosition' = $TrnBackupHeader.Position
							'BackupType' = $TrnBackupHeader.BackupTypeDescription
							'RecoveryModel' = $TrnBackupHeader.RecoveryModel
							'FirstLSN' = $TrnBackupHeader.FirstLSN
							'LastLSN' = $TrnBackupHeader.LastLSN
							'CheckpointLSN' = $TrnBackupHeader.CheckpointLSN
							'DatabaseBackupLSN' = $TrnBackupHeader.DatabaseBackupLSN
							'RestoreOptions' = $RestoreOptions
						}))

						if ($BackupFinishDate -ge $RecoveryDateTime) {
							break ParentLoop
						}

						$LastBackupHeader = $TrnBackupHeader
					}
				}

				Write-Progress -Id 1 -Activity $ProgressParameters1.Activity -Completed

				if ($null -ne $TrnBackups) {
					if ($BackupFinishDate -lt $RecoveryDateTime) {
						Write-Warning -Message ([string]::Format("No transaction log found containing date '{0}' found.", $RecoveryDateTime.LocalDatetime.ToString()))
					}
				}
			}
			#EndRegion

			if (-not $NoRecovery) {
				[void]$($RestoreList | Select-Object -Last 1).RestoreOptions.Remove('NORECOVERY')
			}

			foreach ($RestoreItem in $RestoreList) {
				$Output = [SqlServerMaintenance.Restore]::New()

				$Output.DatabaseName = $NewDatabaseName
				$Output.BackupDatabaseName = $RestoreItem.BackupDatabaseName
				$Output.DatabaseGUID = $RestoreItem.DatabaseGUID
				$Output.BackupFileName = [System.IO.FileInfo]$RestoreItem.BackupFileName.FullName
				$Output.BackupStartDate = $RestoreItem.BackupStartDate
				$Output.BackupFinishDate = $RestoreItem.BackupFinishDate
				$Output.BackupPosition = $RestoreItem.BackupPosition
				$Output.BackupType = $RestoreItem.BackupType
				$Output.RecoveryModel = $RestoreItem.RecoveryModel
				$Output.FirstLSN = $RestoreItem.FirstLSN
				$Output.LastLSN = $RestoreItem.LastLSN
				$Output.CheckpointLSN = $RestoreItem.CheckpointLSN
				$Output.DatabaseBackupLSN = $RestoreItem.DatabaseBackupLSN

				switch ($RestoreItem.BackupType) {
					'Database' {
						$RestoreMethod = 'DATABASE'
					}
					'Database Differential' {
						$RestoreMethod = 'DATABASE'
					}
					'Transaction Log' {
						$RestoreMethod = 'LOG'
					}
				}

				$FormatStringArray = @(
					$RestoreMethod,
					$NewDatabaseName,
					$RestoreItem.BackupFileName.FullName,
					[string]::Join("`n,`t", $RestoreItem.RestoreOptions)
				)

				$Output.RestoreDML = [string]::Format("RESTORE {0} [{1}]`nFROM DISK = N'{2}'`nWITH {3};", $FormatStringArray)

				$Output
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -NotIn $SmoParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}

			if (Test-Path -Path Variable:\ProgressParameters1) {
				Write-Progress -Id 1 -Activity $ProgressParameters1.Activity -Completed
			}

			Write-Progress -Id 0 -Activity 'Gathering Backup information' -Completed
		}
	}

	end {
	}
}

function Get-DatabaseTransactionLogInfo {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.DatabaseTransactionLogInfo])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlServerInstanceParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SqlConnection = Connect-SqlServerInstance @SqlServerInstanceParameters
			}
		}
		catch {
			throw $_
		}
	}

	process {
		foreach ($Database in $DatabaseName) {
			try {
				$VLFDataTable = Get-DatabaseTransactionLogInfoDataSet -SqlConnection $SqlConnection -DatabaseName $Database

				foreach ($Row in $VLFDataTable.Tables.Rows) {
					$Output = [SqlServerMaintenance.DatabaseTransactionLogInfo]::New()

					$Output.DatabaseName = $Database
					$Output.FileID = $Row.file_id
					$Output.VlfBeginOffset = $Row.vlf_begin_offset
					$Output.VlfSizeMB = $Row.vlf_size_mb
					$Output.VlfSequenceNumber = $Row.vlf_sequence_number
					$Output.VlfCreateLsn = $Row.vlf_create_lsn
					$Output.RunningSizeMB = $Row.RunningSize

					$Output
				}
			}
			catch {
				throw $_
			}
			finally {
				if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
					Disconnect-SqlServerInstance -SqlConnection $SqlConnection
				}
			}
		}
	}

	end {
	}
}

function Get-DatabaseTransactionLogInfoDataSet {
	<#
	.SYNOPSIS
	Get database transaction log information.
	.DESCRIPTION
	Get database transaction log information.
	.PARAMETER ServerInstance
	Specifies the name of a SQL Server instance.
	.PARAMETER SqlConnection
	Specifies SQL Server connection.
	.PARAMETER DatabaseName
	Specifies the name of the database to gather log file information.
	.EXAMPLE
	Get-DatabaseTransactionLogInfoDataSet -ServerInstance . -DatabaseName MyDatabase
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Data.DataSet])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName
	)

	begin {
		$Query_VLFs = 'SELECT file_id
			,	vlf_begin_offset
			,	vlf_size_mb
			,	vlf_sequence_number
			,	vlf_create_lsn
			,	RunningSize = SUM(vlf_size_mb) OVER (PARTITION BY file_id ORDER BY vlf_begin_offset)
			FROM sys.dm_db_log_info(DEFAULT)
			ORDER BY vlf_begin_offset;'
	}

	process {
		try {
			$SqlClientDataSetParameters = @{
				'SqlCommandText' = $Query_VLFs
				'OutputAs' = 'Dataset'
			}

			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SqlClientDataSetParameters.Add('ServerInstance', $ServerInstance)
				$SqlClientDataSetParameters.Add('DatabaseName', $DatabaseName)
			} else {
				$SqlConnection.ChangeDatabase($DatabaseName)

				$SqlClientDataSetParameters.Add('SqlConnection', $SqlConnection)
			}

			$VLFDataTable = Get-SqlClientDataSet @SqlClientDataSetParameters

			$VLFDataTable
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-LSPrimaryDatabase {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.SqlLogShippingPrimary])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName
	)

	begin {
		$Query_LogShipping = "SELECT PrimaryID = pd.primary_id
			,	PrimaryDatabase = pd.primary_database
			,	BackupDirectory = pd.backup_directory
			,	BackupShare = pd.backup_share
			,	BackupRetentionPeriod_Minutes = pd.backup_retention_period
			,	MonitorServer = pd.monitor_server
			,	ServerSecurityMode = CASE pd.monitor_server_security_mode
					WHEN 0 THEN 'SQL Server Authentication'
					WHEN 1 THEN 'Windows Authentication' END
			,	BackupCompression = CASE pd.backup_compression
					WHEN 0 THEN 'Disabled'
					WHEN 1 THEN 'Enabled'
					WHEN 2 THEN 'Server Default' END
			,	PrimaryServer = mp.primary_server
			,	BackupThreshold_Minutes = mp.backup_threshold
			,	ThresholdAlertEnabled = mp.threshold_alert_enabled
			,	LastBackupFile = mp.last_backup_file
			,	LastBackupDate = mp.last_backup_date
			,	HistoryRetentionPeriod_Minutes = mp.history_retention_period
			,	SecondaryServer = ps.secondary_server
			,	SecondaryDatabase = ps.secondary_database
			FROM msdb.dbo.log_shipping_primary_databases pd
			INNER JOIN msdb.dbo.log_shipping_monitor_primary mp ON pd.primary_id = mp.primary_id
			INNER JOIN msdb.dbo.log_shipping_primary_secondaries ps ON pd.primary_id = ps.primary_id
			{0}
			ORDER BY PrimaryDatabase;"

		if ($PSBoundParameters.ContainsKey('DatabaseName')) {
			$Query_LogShipping = [string]::Format($Query_LogShipping, "WHERE pd.primary_database = N'$DatabaseName'")
		} else {
			$Query_LogShipping = [string]::Format($Query_LogShipping, '')
		}
	}

	process {
		try {
			$SqlClientDataSetParameters = @{
				'SqlCommandText' = $Query_LogShipping
				'OutputAs' = 'DataTable'
			}

			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SqlClientDataSetParameters.Add('ServerInstance', $ServerInstance)
				$SqlClientDataSetParameters.Add('DatabaseName', 'msdb')
			} else {
				$SqlConnection.ChangeDatabase('msdb')

				$SqlClientDataSetParameters.Add('SqlConnection', $SqlConnection)
			}

			$DataTable = Get-SqlClientDataSet @SqlClientDataSetParameters

			foreach ($Row in $DataTable) {
				$Output = [SqlServerMaintenance.SqlLogShippingPrimary]::New()

				$Output.PrimaryID = $Row.PrimaryID
				$Output.PrimaryDatabase = $Row.PrimaryDatabase
				$Output.BackupDirectory = $Row.BackupDirectory
				$Output.BackupShare = $Row.BackupShare
				$Output.BackupRetentionPeriod_Minutes = $Row.BackupRetentionPeriod_Minutes
				$Output.MonitorServer = $Row.MonitorServer
				$Output.ServerSecurityMode = $Row.ServerSecurityMode
				$Output.BackupCompression = $Row.BackupCompression
				$Output.PrimaryServer = $Row.PrimaryServer
				$Output.BackupThreshold_Minutes = $Row.BackupThreshold_Minutes
				$Output.ThresholdAlertEnabled = $Row.ThresholdAlertEnabled

				if ($Row.LastBackupFile -IsNot [DBNull]) {
					$Output.LastBackupFile = $Row.LastBackupFile
				}

				$Output.LastBackupDate = $Row.LastBackupDate
				$Output.HistoryRetentionPeriod_Minutes = $Row.HistoryRetentionPeriod_Minutes
				$Output.SecondaryServer = $Row.SecondaryServer
				$Output.SecondaryDatabase = $Row.SecondaryDatabase

				$Output
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-LSSecondaryDatabase {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.SqlLogShippingSecondary])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName
	)

	begin {
		$Query_LogShipping = "SELECT SecondaryID = s.secondary_id
			,	PrimaryServer = s.primary_server
			,	PrimaryDatabase = s.primary_database
			,	BackupSourceDirectory = s.backup_source_directory
			,	BackupDestinationDirectory = s.backup_destination_directory
			,	FileRetentionPeriod_Minutes = s.file_retention_period
			,	MonitorServer = s.monitor_server
			,	MonitorServerSecurityMode = CASE s.monitor_server_security_mode
					WHEN 0 THEN 'SQL Server Authentication'
					WHEN 1 THEN 'Windows Authentication' END
			,	LastCopiedFile = s.last_copied_file
			,	LastCopiedDate = s.last_copied_date
			,	SecondaryDatabase = sd.secondary_database
			,	RestoreDelay_Minutes = sd.restore_delay
			,	RestoreAll = sd.restore_all
			,	RestoreMode = CASE sd.restore_mode
					WHEN 0 THEN 'NORECOVERY'
					WHEN 1 THEN 'STANDBY' END
			,	DisconnectUsers = sd.disconnect_users
			,	BlockSize = sd.block_size
			,	BufferCount = sd.buffer_count
			,	MaxTransferSize = sd.max_transfer_size
			,	LastRestoredFile = sd.last_restored_file
			,	LastRestoredDate = sd.last_restored_date
			FROM msdb.dbo.log_shipping_secondary s
			INNER JOIN msdb.dbo.log_shipping_secondary_databases sd ON s.secondary_id = sd.secondary_id
			{0}
			ORDER BY PrimaryDatabase;"

		if ($PSBoundParameters.ContainsKey('DatabaseName')) {
			$Query_LogShipping = [string]::Format($Query_LogShipping, "WHERE s.primary_database = N'$DatabaseName'")
		} else {
			$Query_LogShipping = [string]::Format($Query_LogShipping, '')
		}
	}

	process {
		try {
			$SqlClientDataSetParameters = @{
				'SqlCommandText' = $Query_LogShipping
				'OutputAs' = 'DataTable'
			}

			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SqlClientDataSetParameters.Add('ServerInstance', $ServerInstance)
				$SqlClientDataSetParameters.Add('DatabaseName', 'msdb')
			} else {
				$SqlConnection.ChangeDatabase('msdb')

				$SqlClientDataSetParameters.Add('SqlConnection', $SqlConnection)
			}

			$DataTable = Get-SqlClientDataSet @SqlClientDataSetParameters

			foreach ($Row in $DataTable) {
				$Output = [SqlServerMaintenance.SqlLogShippingSecondary]::New()

				$Output.SecondaryID = $Row.SecondaryID
				$Output.PrimaryServer = $Row.PrimaryServer
				$Output.PrimaryDatabase = $Row.PrimaryDatabase
				$Output.BackupSourceDirectory = $Row.BackupSourceDirectory
				$Output.BackupDestinationDirectory = $Row.BackupDestinationDirectory
				$Output.FileRetentionPeriod_Minutes = $Row.FileRetentionPeriod_Minutes
				$Output.MonitorServer = $Row.MonitorServer
				$Output.MonitorServerSecurityMode = $Row.MonitorServerSecurityMode
				$Output.LastCopiedFile = $Row.LastCopiedFile
				$Output.LastCopiedDate = $Row.LastCopiedDate
				$Output.SecondaryDatabase = $Row.SecondaryDatabase
				$Output.RestoreDelay_Minutes = $Row.RestoreDelay_Minutes
				$Output.RestoreAll = $Row.RestoreAll
				$Output.RestoreMode = $Row.RestoreMode
				$Output.DisconnectUsers = $Row.DisconnectUsers
				$Output.BlockSize = $Row.BlockSize
				$Output.BufferCount = $Row.BufferCount
				$Output.MaxTransferSize = $Row.MaxTransferSize

				if ($Row.LastRestoredFile -IsNot [DBNull]) {
					$Output.LastRestoredFile = $Row.LastRestoredFile
				}

				if ($Row.LastRestoredFile -IsNot [DBNull]) {
					$Output.LastRestoredDate = $Row.LastRestoredDate
				}

				$Output
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-SqlBackupFile {
	<#
	.SYNOPSIS
	Gets list of backup files within directory.
	.DESCRIPTION
	Gets list of backup files within directory.
	.PARAMETER Path
	Specifies the backup path.
	.PARAMETER BackupType
	Specifies the type of backup operation to perform.
	.PARAMETER Exclude
	Full or differential Backup files to exclude.
	.EXAMPLE
	Get-SqlBackupFile -Path C:\SqlBackups

	Returns backup files of types full, diff, and transaction log from C:\SqlBackups.
	.EXAMPLE
	Get-SqlBackupFile -Path C:\SqlBackups -BackupType Full

	Returns backup files of types full from C:\SqlBackups.
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Collections.Generic.List[SqlServerMaintenance.BackupFileInfo]])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo]$Path,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[BackupType[]]$BackupType = @('full', 'diff', 'log'),

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.IO.FileInfo[]]$Exclude
	)

	begin {
		try {
			if ($PSBoundParameters.ContainsKey('Exclude')) {
				if ($BackupType -contains 'log') {
					if ($Exclude.Extension -contains '.trn') {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Log backups cannot have excluded files.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidOperation,
							$Exclude
						)
					}
				}
			}

			$IncludeFilesList = [System.Collections.Generic.List[string]]::New()

			switch ($BackupType) {
				'full' {
					$IncludeFilesList.Add('*.bak')
				}
				'diff' {
					$IncludeFilesList.Add('*.dif')
				}
				'log' {
					$IncludeFilesList.Add('*.trn')
				}
			}
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			$Files = [System.Collections.Generic.List[SqlServerMaintenance.BackupFileInfo]]::New()

			foreach ($Extension in $IncludeFilesList) {
				$Files.AddRange([SqlServerMaintenance.BackupFileInfo[]][System.IO.Directory]::GetFiles($Path, $Extension))
			}

			if ($PSBoundParameters.ContainsKey('Exclude')) {
				[void]$Files.RemoveAll({$args.FullName -in $Exclude})
				[void]$Files.RemoveAll({$args.Name -in $Exclude.Name})
			}

			$Files
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-SqlDatabaseSnapshot {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.DatabaseSnapshot])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseSnapshotName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('Database-ServerInstance', 'Snapshot-ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($PSBoundParameters.ContainsKey('DatabaseSnapshotName')) {
					[scriptblock]$FilterBlock = {$_.Name -eq $DatabaseSnapshotName -and $_.DatabaseSnapshotBaseName -eq $DatabaseName -and $_.IsDatabaseSnapshot -eq $true}
				} else {
					[scriptblock]$FilterBlock = {$_.DatabaseSnapshotBaseName -eq $DatabaseName -and $_.IsDatabaseSnapshot -eq $true}
				}
			} elseif ($PSBoundParameters.ContainsKey('DatabaseSnapshotName')) {
				[scriptblock]$FilterBlock = {$_.Name -eq $DatabaseSnapshotName -and $_.IsDatabaseSnapshot -eq $true}
			} else {
				[scriptblock]$FilterBlock = {$_.IsDatabaseSnapshot -eq $true}
			}

			$Databases = $SmoServer.Databases.Where($FilterBlock)

			foreach ($Database in $Databases) {
				[SqlServerMaintenance.DatabaseSnapshot]::New($Database)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Get-SqlInstanceDataFileUsage {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.SqlDataFileUsage])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$FreeSpaceThreshold = 15,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$MinimumSamples = 5,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$StatisticPeriod = 30,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$ProjectionPeriod = 30,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$MinimumFileGrowth = 64,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateInterval(0, 1, $false, $false)]
		[decimal]$ReliabilityThreshold = 0.85
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($Script:OutputMethod -ne 'ConsoleHost') {
				$EmailTemplate = $Script:PSMConfig.Config.EMailTemplates.SelectSingleNode('./EmailTemplate[@Name="Message"]')
				$MailMessageTemplate = Join-Path -Path $Script:TemplatePath -ChildPath $EmailTemplate.TemplateName -Resolve

				if ($PSVersionTable.PSEdition -eq 'Core') {
					if ($PSVersionTable.Platform -eq 'Win32NT') {
						[void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms.DataVisualization')
					} else {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Non-interactive session is not supported on this platform.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidOperation,
							$PSVersionTable.Platform
						)
					}
				} else {
					[void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms.DataVisualization')
				}
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Database.SchemaName
			$StatisticsTableName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Database.TableName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Data File Usage Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$QueryString = "SELECT CollectionDate
		,	[Day] = DATEDIFF(day, LAST_VALUE(CollectionDate) OVER (ORDER BY CollectionDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), CollectionDate)
		,	[FileSizeMB]
		,	[UsedSpaceMB]
		FROM [{0}].[{1}]
		WHERE DatabaseName = N'{2}'
			AND LogicalFileName = N'{3}'
		ORDER BY [Day];"

		$DataFileProperties = @(
			'DatabaseName',
			'DataFileName',
			'DataFileSize',
			'DataFileAvailablePercent',
			'RecommendedDataFileSize',
			'Reliability',
			'RecommendedAutoGrowth'
		)
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.Name -ne 'tempdb'})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to evaluate data file usage on database ""$Item"".  Database does not exist or database not accessible on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				foreach ($FileGroup in $Database.FileGroups.where({$_.FileGroupType -ne 'MemoryOptimizedDataFileGroup'})) {
					foreach ($File in $FileGroup.Files) {
						try {
							$SqlDataFileUsage = [SqlServerMaintenance.SqlDataFileUsage]::New()

							$SqlDataFileUsage.SqlInstance = $SmoServer.Name
							$SqlDataFileUsage.DatabaseName = $Database.Name
							$SqlDataFileUsage.FileGroupName = $FileGroup.Name
							$SqlDataFileUsage.DataFileName = $File.Name
							$SqlDataFileUsage.DataFileSize = $File.Size / 1024
							$SqlDataFileUsage.DataFileUsedSpace = $File.UsedSpace / 1024
							$SqlDataFileUsage.DataFileAvailableSpace = $File.AvailableSpace / 1024

							$FormatStringArray = @(
								$StatisticsSchemaName,
								$StatisticsTableName,
								$SqlDataFileUsage.DatabaseName,
								$SqlDataFileUsage.DataFileName
							)

							$StatsQuery = [string]::Format($QueryString, $FormatStringArray)

							$DataSet = $SmoServer.Databases[$StatisticsDatabaseName].ExecuteWithResults($StatsQuery)

							$SampleCount = $DataSet.Tables[0].Rows.Count

							if ($SampleCount -ge $MinimumSamples) {
								if ($SampleCount -gt $StatisticPeriod) {
									$DayStart = $DataSet.Tables[0].Rows[$SampleCount - $StatisticPeriod].Day
								} else {
									$DayStart = 0 - $SampleCount
								}

								$DataView = [System.Data.DataView]::New($DataSet.Tables[0])
								$DataView.RowFilter = "Day >= $DayStart"

								$LinearRegression = [Regression.Linear]::New($DataView.Day, $DataView.UsedSpaceMB)

								$MeasuredStat = [PsCustomObject][Ordered]@{
									'LastDateTime' = ($DataView.CollectionDate | Measure-Object -Maximum).Maximum
									'LastDay' = ($DataView.Day | Measure-Object -Maximum).Maximum
									'MaxFileSizeMB' = ($DataView.FileSizeMB | Measure-Object -Maximum).Maximum
									'MinUsedSpaceMB' = ($DataView.UsedSpaceMB | Measure-Object -Minimum).Minimum
								}

								if ([System.Double]::IsNaN($LinearRegression.Slope)) {
									$RecommendedAutoGrowth = $MinimumFileGrowth
									[int]$RecommendedDataFileSize = $SqlDataFileUsage.DataFileSize + $MinimumFileGrowth
								} else {
									[int]$RecommendedAutoGrowth = $LinearRegression.Slope * $ProjectionPeriod

									if ($RecommendedAutoGrowth -lt $MinimumFileGrowth) {
										$RecommendedAutoGrowth = $MinimumFileGrowth
									}

									[int]$RecommendedDataFileSize = $LinearRegression.CalculatePrediction($MeasuredStat.LastDay + $ProjectionPeriod) * (100 / (100 - $FreeSpaceThreshold))

									if ($RecommendedDataFileSize - $SqlDataFileUsage.DataFileSize -lt $MinimumFileGrowth) {
										[int]$RecommendedDataFileSize = $SqlDataFileUsage.DataFileSize + $MinimumFileGrowth
									}
								}

								if ($SqlDataFileUsage.DataFileSize -lt $MinimumFileGrowth) {
									if ($SqlDataFileUsage.DataFileUsedSpace -lt $($MinimumFileGrowth * (1 - ($FreeSpaceThreshold / 100)))) {
										$RecommendedDataFileSize = $MinimumFileGrowth
									}
								}

								if ($SqlDataFileUsage.DataFileUsedSpace * (100 / (100 - $FreeSpaceThreshold)) + $MinimumFileGrowth -gt $RecommendedDataFileSize) {
									$RecommendedDataFileSize = $SqlDataFileUsage.DataFileUsedSpace * (100 / (100 - $FreeSpaceThreshold)) + $MinimumFileGrowth
								}

								if ($SqlDataFileUsage.DataFileAvailablePercent -lt $FreeSpaceThreshold) {
									$SqlDataFileUsage.RecommendedDataFileSize = $RecommendedDataFileSize
								} else {
									$SqlDataFileUsage.RecommendedDataFileSize = $SqlDataFileUsage.DataFileSize
								}

								$SqlDataFileUsage.Reliability = [math]::Round($LinearRegression.rSquared, 4, [MidpointRounding]::AwayFromZero)

								if ($SampleCount -ge $StatisticPeriod) {
									$SqlDataFileUsage.RecommendedAutoGrowth = $RecommendedAutoGrowth
								}

								$SqlDataFileUsage.DailyGrowthRate = $LinearRegression.Slope

								$FileGroupObject = $SmoServer.Databases[$SqlDataFileUsage.DatabaseName].FileGroups[$SqlDataFileUsage.FileGroupName]

								if ($SqlDataFileUsage.DataFileAvailablePercent -lt $FreeSpaceThreshold -and $LinearRegression.rSquared -gt $ReliabilityThreshold -and $FileGroupObject.Files.Count -eq 1) {
									$DataFileObject = $FileGroupObject.Files[0]

									$DataFileObject.Size = $SqlDataFileUsage.RecommendedDataFileSize * 1024

									$DataFileObject.Alter()
									$DataFileObject.Refresh()

									$SqlDataFileUsage.DataFileSize = $SqlDataFileUsage.RecommendedDataFileSize
									$SqlDataFileUsage.DataFileAvailableSpace = $DataFileObject.AvailableSpace / 1024
								}
							} else {
								if ($SqlDataFileUsage.DataFileAvailablePercent -lt $FreeSpaceThreshold) {
									$SqlDataFileUsage.RecommendedDataFileSize = $SqlDataFileUsage.DataFileUsedSpace * (100 / (100 - $FreeSpaceThreshold)) + $MinimumFileGrowth
								} else {
									$SqlDataFileUsage.RecommendedDataFileSize = $SqlDataFileUsage.DataFileSize
								}
							}

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									$SqlDataFileUsage
								}
								Default {
									if ($SqlDataFileUsage.DataFileAvailablePercent -lt $FreeSpaceThreshold) {
										if ($SampleCount -lt $MinimumSamples -or $LinearRegression.rSquared -le $ReliabilityThreshold -or $FileGroupObject.Files.Count -gt 1) {
											#Region Create Chart
											if ($SampleCount -ge $MinimumSamples) {
												if ($LinearRegression.Slope -lt 1) {
													$FormatStringArray = @(
														[math]::Round($LinearRegression.Slope * 1024, 2, [MidpointRounding]::AwayFromZero),
														'KB'
													)
												} else {
													$FormatStringArray = @(
														[math]::Round($LinearRegression.Slope, 2, [MidpointRounding]::AwayFromZero),
														'MB'
													)
												}

												$DailyGrowRateText = [string]::Format('Daily Growth Rate: {0} {1}', $FormatStringArray)

												$chart1 = [System.Windows.Forms.DataVisualization.Charting.Chart]::New()
												$chart1.Width = 1000
												$chart1.Height = 400
												$chart1.BackColor = [System.Drawing.Color]::Transparent
												$chart1.ForeColor = [System.Drawing.Color]::Violet

												$ChartTitle = [System.Windows.Forms.DataVisualization.Charting.Title]::New()
												$ChartTitle.Text = 'Logical File Growth'
												$ChartTitle.Alignment = [System.Drawing.ContentAlignment]::TopLeft
												$ChartTitle.Font = [System.Drawing.Font]::New('Arial','14', [System.Drawing.FontStyle]::Bold)
												$ChartTitle.ForeColor = [System.Drawing.Color]::Teal

												[void]$chart1.Titles.Add($ChartTitle)

												$ChartTitle = [System.Windows.Forms.DataVisualization.Charting.Title]::New()
												$ChartTitle.Text = $DailyGrowRateText
												$ChartTitle.Alignment = [System.Drawing.ContentAlignment]::TopLeft
												$ChartTitle.Font = [System.Drawing.Font]::New('Arial','10', [System.Drawing.FontStyle]::Bold)
												$ChartTitle.ForeColor = [System.Drawing.Color]::Teal

												[void]$chart1.Titles.Add($ChartTitle)

												$ChartArea = [System.Windows.Forms.DataVisualization.Charting.ChartArea]::New()
												$ChartArea.Name = 'ChartArea1'
												$ChartArea.BackColor = [System.Drawing.Color]::Transparent

												$ChartArea.AxisX.Title = 'Date'
												$ChartArea.AxisX.TitleFont = [System.Drawing.Font]::New('Arial','10', [System.Drawing.FontStyle]::Regular)
												$ChartArea.AxisX.TitleForeColor = [System.Drawing.Color]::Teal
												$ChartArea.AxisX.Interval = 1
												$ChartArea.AxisX.LabelStyle.Font = [System.Drawing.Font]::New('Arial','10', [System.Drawing.FontStyle]::Regular)
												$ChartArea.AxisX.LabelStyle.ForeColor = [System.Drawing.Color]::Teal
												$ChartArea.AxisX.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisX.MajorGrid.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisX.MajorTickMark.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisX.MinorGrid.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisX.MinorTickMark.LineColor = [System.Drawing.Color]::LightSlateGray

												$ChartArea.AxisY.Title = 'Used Space (MB)'
												$ChartArea.AxisX.TitleFont = [System.Drawing.Font]::New('Arial','10', [System.Drawing.FontStyle]::Regular)
												$ChartArea.AxisY.TitleForeColor = [System.Drawing.Color]::Teal
												$ChartArea.AxisY.Interval = [int](($MeasuredStat.MaxFileSizeMB - $MeasuredStat.MinUsedSpaceMB) / 8)
												$ChartArea.AxisY.LabelStyle.Font = [System.Drawing.Font]::New('Arial','10', [System.Drawing.FontStyle]::Regular)
												$ChartArea.AxisY.LabelStyle.ForeColor = [System.Drawing.Color]::Teal
												$ChartArea.AxisY.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisY.MajorGrid.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisY.MajorTickMark.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisY.MinorGrid.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisY.MinorTickMark.LineColor = [System.Drawing.Color]::LightSlateGray
												$ChartArea.AxisY.Minimum = [math]::Floor($MeasuredStat.MinUsedSpaceMB - (($MeasuredStat.MaxFileSizeMB - $MeasuredStat.MinUsedSpaceMB) / 8))
												$ChartArea.AxisY.Maximum = [math]::Ceiling($MeasuredStat.MaxFileSizeMB + (($MeasuredStat.MaxFileSizeMB - $MeasuredStat.MinUsedSpaceMB) / 8))

												$chart1.ChartAreas.Add($ChartArea)

												$Legend = [System.Windows.Forms.DataVisualization.Charting.Legend]::New()
												$Legend.Name = 'Legend1'
												$Legend.BackColor = [System.Drawing.Color]::Transparent
												$Legend.Font = [System.Drawing.Font]::New('Arial','10', [System.Drawing.FontStyle]::Regular)
												$Legend.ForeColor = [System.Drawing.Color]::Teal

												$chart1.Legends.Add($Legend)

												[void]$chart1.Series.Add('Logical File Size')
												$chart1.Series['Logical File Size'].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
												$chart1.Series['Logical File Size'].IsVisibleInLegend = $true
												$chart1.Series['Logical File Size'].BorderWidth = 3
												$chart1.Series['Logical File Size'].ChartArea = 'ChartArea1'
												$chart1.Series['Logical File Size'].Legend = 'Legend1'
												$chart1.Series['Logical File Size'].Color = [System.Drawing.Color]::Lime

												[void]$chart1.Series.Add('Used Space')
												$chart1.Series['Used Space'].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::FastPoint
												$chart1.Series['Used Space'].BorderWidth = 3
												$chart1.Series['Used Space'].IsVisibleInLegend = $true
												$chart1.Series['Used Space'].ChartArea = 'ChartArea1'
												$chart1.Series['Used Space'].Legend = 'Legend1'
												$chart1.Series['Used Space'].Color = [System.Drawing.Color]::Cyan

												[void]$chart1.Series.Add('Growth Trend')
												$chart1.Series['Growth Trend'].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
												$chart1.Series['Growth Trend'].IsVisibleInLegend = $true
												$chart1.Series['Growth Trend'].BorderWidth = 3
												$chart1.Series['Growth Trend'].ChartArea = 'ChartArea1'
												$chart1.Series['Growth Trend'].Legend = 'Legend1'
												$chart1.Series['Growth Trend'].Color = [System.Drawing.Color]::Violet

												foreach ($Row in $DataView) {
													$Date = $Row.CollectionDate.ToString('yyyy-MM-dd')

													[void]$chart1.Series['Used Space'].points.AddXY($Date, $Row.UsedSpaceMB)
													[void]$chart1.Series['Logical File Size'].points.AddXY($Date, $Row.FileSizeMB)

													if (-not [System.Double]::IsNaN($LinearRegression.Slope)) {
														[void]$chart1.Series['Growth Trend'].points.AddXY($Date, $LinearRegression.CalculatePrediction($Row.Day))
													}
												}

												if ([System.Double]::IsNaN($LinearRegression.Slope) -or [math]::Round($LinearRegression.Slope, 10, [MidpointRounding]::AwayFromZero) -eq 0) {
													$DaysLeft = [math]::Round($($DataView.Count / 2), 0, [MidpointRounding]::AwayFromZero)
												} else {
													$DaysLeft = [int]((($SqlDataFileUsage.DataFileSize - $LinearRegression.YIntercept) / $LinearRegression.Slope) - $MeasuredStat.LastDay)
												}

												if ($DaysLeft -le 0 -or $DaysLeft -gt $($DataView.Count / 2)) {
													$DaysLeft = [math]::Round($($DataView.Count / 2), 0, [MidpointRounding]::AwayFromZero)
												}

												$DataView.Dispose()

												for ($i = 1; $i -lt $DaysLeft; $i++) {
													$Date = $Row.CollectionDate.AddDays($i).ToString('yyyy-MM-dd')

													[void]$chart1.Series['Growth Trend'].points.AddXY($Date, $LinearRegression.CalculatePrediction($MeasuredStat.LastDay + $i))
												}

												$MemoryStream = [System.IO.MemoryStream]::New()

												$chart1.SaveImage($MemoryStream, 'png')

												$ChartTitle.Dispose()
												$ChartArea.Dispose()
												$Legend.Dispose()
												[void]$chart1.Dispose()

												$MemoryStream.Position = 0
											}
											#EndRegion

											if ($SampleCount -ge $MinimumSamples) {
												$MailAttachment = Format-MailAttachment -FileName 'graph.png' -FileStream $MemoryStream -Inline
											}

											[xml]$XmlDocument = [System.Xml.XmlDocument]::New()
											$XmlDeclaration = $XmlDocument.CreateXmlDeclaration('1.0', 'UTF-8', $null)
											[void]$XmlDocument.AppendChild($XmlDeclaration)

											$RootElement = $XmlDocument.CreateNode('element', 'DataFile', $null)

											$Properties = $SqlDataFileUsage | Select-Object $DataFileProperties

											foreach ($Property in $Properties.PsObject.Properties) {
												$Element = $XmlDocument.CreateElement($Property.Name)
												$Element.InnerText = $Property.Value
												[void]$RootElement.AppendChild($Element)
											}

											[void]$XmlDocument.AppendChild($RootElement)

											$XsltArgumentList = [System.Xml.Xsl.XsltArgumentList]::New()
											$XsltArgumentList.Clear()
											$XsltArgumentList.AddParam('SqlInstance', $null, $SmoServer.Name)
											$XsltArgumentList.AddParam('DatabaseName', $null, $SqlDataFileUsage.DatabaseName)
											$XsltArgumentList.AddParam('EventDate', $null, $(Get-Date).DateTime)

											if ($SampleCount -ge $MinimumSamples) {
												$XsltArgumentList.AddParam('HasGraph', $null, $true)
											} else {
												$XsltArgumentList.AddParam('HasGraph', $null, $false)
											}

											$EmailBody = Format-XslTemplate -XslTemplatePath $MailMessageTemplate -XmlContent $XmlDocument -XsltArgumentList $XsltArgumentList

											$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()
											$MailMessageParameters.Add('Subject', 'Low Available Database Space')
											$MailMessageParameters.Add('Body', $EmailBody)

											if ($SampleCount -ge $MinimumSamples) {
												$MailMessageParameters.Add('MailAttachment', $MailAttachment)
											}

											Send-MailToolMessage @MailMessageParameters
										}
									}
								}
							}
						}
						catch {
							$ErrorRecord = $_

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									$PSCmdlet.WriteError($ErrorRecord)
								}
								Default {
									$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SmoServer.Name
										'DatabaseName' = $Database.Name
									}

									$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

									$MailMessageParameters.Add('Subject', 'SQL Data File Usage Failure')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Data File Usage Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if (Test-Path -Path Variable:MemoryStream) {
				$MemoryStream.Close()
				$MemoryStream.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Get-SqlInstanceLogFileGrowthRate {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.SqlLogFileGrowth])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateInterval(0, 1, $false, $false)]
		[decimal]$LogAutoGrowthThreshold = 0.125
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Log File Usage Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$LogFileProperties = @(
			'LogFileName',
			'LogFileSize',
			@{l='AutoGrowth'; e={
				if ($_.GrowthType -eq 'KB') {
					$_.AutoGrowth / 1024
				} else {
					$_.AutoGrowth
				}
			}}
			'MinimumRecommendedAutoGrowth',
			'AutoGrowthPercentageOfFileSize'
		)
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.Name -ne 'tempdb'})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to evaluate log file growth rate on database ""$Item"".  Database does not exist or database not accessible on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				foreach ($LogFile in $Database.LogFiles) {
					try {
						$SqlLogFileGrowth = [SqlServerMaintenance.SqlLogFileGrowth]::New()

						$SqlLogFileGrowth.DatabaseName = $Database.Name
						$SqlLogFileGrowth.LogFileName = $LogFile.Name
						$SqlLogFileGrowth.LogFileSize = $LogFile.Size / 1024
						$SqlLogFileGrowth.AutoGrowth = $LogFile.Growth
						$SqlLogFileGrowth.GrowthType = $LogFile.GrowthType
						$SqlLogFileGrowth.MinimumRecommendedAutoGrowth = [math]::Round($SqlLogFileGrowth.LogFileSize * $LogAutoGrowthThreshold, 0, [MidpointRounding]::AwayFromZero)

						if ($SqlLogFileGrowth.MinimumRecommendedAutoGrowth -lt 64) {
							$SqlLogFileGrowth.MinimumRecommendedAutoGrowth = 64
						}

						switch ($Script:OutputMethod) {
							'ConsoleHost' {
								$SqlLogFileGrowth
							}
							Default {
								if ($SqlLogFileGrowth.GrowthType -ne 'None' -and $SqlLogFileGrowth.AutoGrowthPercentageOfFileSize -lt $LogAutoGrowthThreshold * 100) {
									$XmlDocument = $SqlLogFileGrowth | Select-Object $LogFileProperties | ConvertTo-Xml -NoTypeInformation

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SmoServer.Name
										'DatabaseName' = $SqlLogFileGrowth.DatabaseName
									}

									$EmailBody = Build-MailBody -Xml $XmlDocument -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()
									$MailMessageParameters.Add('Subject', 'Log Auto Growth Set to Low')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}
					catch {
						$ErrorRecord = $_

						switch ($Script:OutputMethod) {
							'ConsoleHost' {
								$PSCmdlet.WriteError($ErrorRecord)
							}
							Default {
								$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

								$SummaryItem = [ordered]@{
									'SqlInstance' = $SmoServer.Name
									'DatabaseName' = $LogFile.DatabaseName
									'LogFileName' = $LogFile.Name
								}

								$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

								$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

								$MailMessageParameters.Add('Subject', 'SQL Log File Usage Failure')
								$MailMessageParameters.Add('Body', $EmailBody)

								Send-MailToolMessage @MailMessageParameters
							}
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Log File Usage Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Get-SqlInstanceLogFileVLFCount {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.SqlLogFileVLFCount])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$VLFCountThreshold = 100
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Transaction Log Non-Optimized Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$Query_VLFCount = "SELECT d.[name] AS DatabaseName
			,	l.total_vlf_count AS TotalVLFCount
			,	l.total_vlf_count - ((ROUND(l.total_log_size_mb, 0) - (CAST(ROUND(l.total_log_size_mb, 0) AS decimal(9, 0)) % 16384)) / 4096) AS AdjustedVLFCount
			,	l.total_log_size_mb AS TotalLogSizeMB
			FROM sys.databases d
			CROSS APPLY sys.dm_db_log_stats(d.database_id) l
			LEFT OUTER JOIN sys.dm_hadr_database_replica_states drs ON d.database_id = drs.database_id
			LEFT OUTER JOIN sys.availability_replicas ar ON drs.replica_id = ar.replica_id
				AND drs.replica_id = ar.replica_id
			LEFT OUTER JOIN sys.dm_hadr_availability_replica_states ars ON drs.replica_id = ars.replica_id
				AND drs.group_id = ars.group_id
			WHERE l.total_vlf_count > {0}
				AND d.state_desc NOT IN ('OFFLINE', 'RESTORING')
				AND d.is_in_standby = 0
				AND d.source_database_id IS NULL
				AND ((drs.is_local = 1 AND ars.[operational_state] = 2 AND ars.[role] = 1)
					OR drs.is_local IS NULL)
			{1};"

		if ($PSBoundParameters.ContainsKey('DatabaseName')) {
			$FormatStringArray = @(
				$VLFCountThreshold,
				[string]::Format("	AND d.[name] = N'{0}'", $DatabaseName)
			)
		} else {
			$FormatStringArray = @(
				$VLFCountThreshold,
				'ORDER BY [name]'
			)
		}

		$Query_VLFCount = [string]::Format($Query_VLFCount, $FormatStringArray)
	}

	process {
		try {
			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SmoServer.ConnectionContext.SqlConnectionObject
				'DatabaseName' = 'master'
				'SqlCommandText' = $Query_VLFCount
				'OutputAs' = 'DataTable'
			}

			$HighVLFDataTable = Get-SqlClientDataSet @SqlClientDataSetParameters

			foreach ($Row in $HighVLFDataTable) {
				try {
					if ($Row.AdjustedVLFCount -gt $VLFCountThreshold) {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
							'DatabaseName' = $Row.DatabaseName
							'TotalVLFCount' = $Row.TotalVLFCount
						}

						switch ($Script:OutputMethod) {
							'ConsoleHost' {
								[SqlServerMaintenance.SqlLogFileVLFCount]$SummaryItem
							}
							Default {
								$VLFDataTable = Get-DatabaseTransactionLogInfoDataSet -ServerInstance $ServerInstance -DatabaseName $Row.DatabaseName

								$RecordXml = ConvertTo-RecordXML -InputObject $VLFDataTable

								$EmailBody = Build-MailBody -Xml $RecordXml -SummaryItem $SummaryItem

								$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()
								$MailMessageParameters.Add('Subject', 'Transaction Log Non-Optimized')
								$MailMessageParameters.Add('Body', $EmailBody)

								Send-MailToolMessage @MailMessageParameters
							}
						}
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Row.DatabaseName
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'Transaction Log Non-Optimized Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Transaction Log Non-Optimized Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Get-SqlInstanceQueryStoreUsage {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.SqlQueryStore])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$FreeSpaceThreshold = 20
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Query Store Usage Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.Name -ne 'tempdb'})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			$Databases = $Databases.where({$_.QueryStoreOptions.DesiredState -ne 'Off'})

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to evaluate query store usage on database ""$Item"".  Database does not exist or query store not enabled on database or database not accessible on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				try {
					$QueryStoreOptions = $Database.QueryStoreOptions

					$SqlQueryStore = [SqlServerMaintenance.SqlQueryStore]::New()

					$SqlQueryStore.DatabaseName = $Database.Name
					$SqlQueryStore.CurrentStorageSizeInMB = $QueryStoreOptions.CurrentStorageSizeInMB
					$SqlQueryStore.MaxStorageSizeInMB = $QueryStoreOptions.MaxStorageSizeInMB
					$SqlQueryStore.DesiredState = $QueryStoreOptions.DesiredState
					$SqlQueryStore.ActualState = $QueryStoreOptions.ActualState
					$SqlQueryStore.ReadOnlyReason = $QueryStoreOptions.ReadOnlyReason

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$SqlQueryStore
						}
						Default {
							if ($SqlQueryStore.StorageAvailablePercent -lt $FreeSpaceThreshold -or $SqlQueryStore.ReadOnlyReason -gt 0 -or $SqlQueryStore.DesiredState -ne $SqlQueryStore.ActualState) {
								$SqlQueryStoreProperties = @(
									'CurrentStorageSizeInMB',
									'MaxStorageSizeInMB',
									'StorageAvailablePercent',
									'DesiredState',
									'ActualState',
									@{N='ReadOnlyReason';E={ $_.ReadOnlyReasonDescription }}
								)

								$XmlDocument = $SqlQueryStore | Select-Object $SqlQueryStoreProperties | ConvertTo-Xml -NoTypeInformation

								$SummaryItem = [ordered]@{
									'SqlInstance' = $SmoServer.Name
									'DatabaseName' = $Database.Name
								}

								$EmailBody = Build-MailBody -Xml $XmlDocument -SummaryItem $SummaryItem

								$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()
								$MailMessageParameters.Add('Subject', 'Storage Threshold for Query Store Exceeded')
								$MailMessageParameters.Add('Body', $EmailBody)

								Send-MailToolMessage @MailMessageParameters
							}
						}
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Query Store Usage Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Query Store Usage Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Get-SqlInstanceTDEStatus {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Data.DataRow])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName
	)

	begin {
		$TDEStatusFormatString = "SELECT DB_NAME(database_id) AS DatabaseName
		,	CASE encryption_state
				WHEN 0 THEN 'No database encryption key present, no encryption'
				WHEN 1 THEN 'Unencrypted'
				WHEN 2 THEN 'Encryption in progress'
				WHEN 3 THEN 'Encrypted'
				WHEN 4 THEN 'Key change in progress'
				WHEN 5 THEN 'Decryption in progress'
				WHEN 6 THEN 'Protection change in progress'
			END AS EncryptionState
		,	percent_complete AS PercentComplete
		FROM sys.dm_database_encryption_keys{0}
		ORDER BY DatabaseName;"

		$WhereClauseFormatString = "`r`n`t`tWHERE database_id = DB_ID(N'{0}')"
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$WhereClause = [string]::Format($WhereClauseFormatString, $DatabaseName)
			} else {
				$WhereClause = ''
			}

			$SqlClientDataSetParameters = @{
				'DatabaseName' = 'master'
				'SqlCommandText' = [string]::Format($TDEStatusFormatString, $WhereClause)
				'OutputAs' = 'DataRow'
			}

			if ($PSBoundParameters.ContainsKey('ServerInstance')) {
				$SqlClientDataSetParameters.Add('ServerInstance', $ServerInstance)
			}

			if ($PSBoundParameters.ContainsKey('SqlConnection')) {
				$SqlClientDataSetParameters.Add('SqlConnection', $SqlConnection)
			}

			$TDEStatusDataTable = Get-SqlClientDataSet @SqlClientDataSetParameters

			$TDEStatusDataTable
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-SqlServerMaintenanceConfiguration {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([PSCustomObject])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SqlServerMaintenanceSetting]$SettingName
	)

	begin {
	}

	process {
		try {
			switch ($SettingName) {
				'SMTPSettings' {
					if ($PSCmdlet.ParameterSetName -eq 'Network') {
						[PSCustomObject][ordered]@{
							'SmtpServer' = $Script:PSMConfig.Config.SMTPSettings.SmtpServer
							'SmtpPort' = $Script:PSMConfig.Config.SMTPSettings.SmtpPort
							'UseTls' = $Script:PSMConfig.Config.SMTPSettings.UseTls
						}
					} else {
						[PSCustomObject][ordered]@{
							'PickupDirectoryPath' = $Script:PSMConfig.Config.SMTPSettings.PickupDirectoryPath
						}
					}
				}
				'EmailNotification' {
					[PSCustomObject][ordered]@{
						'SenderAddress' = $Script:PSMConfig.Config.EmailNotification.SenderAddress
						'RecipientAddress' = $Script:PSMConfig.Config.EmailNotification.Recipients.Recipient
					}
				}
				'AdminDatabase' {
					[PSCustomObject][ordered]@{
						'DatabaseName' = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
					}
				}
				'Statistics' {
					foreach ($Statistic in $Script:PSMConfig.SelectNodes('./Config/AdminDatabase/Statistics/*')) {
						[PSCustomObject][ordered]@{
							'StatisticName' = $Statistic.LocalName
							'SchemaName' = $Statistic.SchemaName
							'TableName' = $Statistic.TableName
							'RetentionInDays' = $Statistic.RetentionDays
						}
					}
				}
				'Tests' {
					foreach ($Test in $Script:PSMConfig.SelectNodes('./Config/AdminDatabase/Tests/*')) {
						[PSCustomObject][ordered]@{
							'TestName' = $Test.LocalName
							'SchemaName' = $Test.SchemaName
							'TableName' = $Test.TableName
							'RetentionInDays' = $Test.RetentionDays
						}
					}
				}
				'SqlAgentAlerts' {
					[PSCustomObject][ordered]@{
						'SchemaName' = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.SchemaName
						'TableName' = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.TableName
						'RetentionInDays' = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.RetentionDays
					}
				}
				Default {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Unknown setting.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidArgument,
						$SettingName
					)
				}
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-SqlServerTimeZone {
	<#
	.SYNOPSIS
	Retrieves time zone for SQL Server instance.
	.DESCRIPTION
	Retrieves time zone for SQL Server instance.
	.PARAMETER ServerInstance
	SQL Server host name and instance name.
	.PARAMETER SmoServer
	SQL Server Management Object.
	.EXAMPLE
	Get-SqlServerTimeZone -ServerInstance MySqlServer
	.EXAMPLE
	Get-SqlServerTimeZone -SmoServer $SmoServer
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'None',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.TimeZoneInfo])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}

		$SqlQuery = "DECLARE @TZName nvarchar(128);
			EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation', 'TimeZoneKeyName', @TZName OUT;
			SELECT TimeZoneName = @TZName;"
	}

	process {
		try {
			$Results = Get-SqlClientDataSet -SqlConnection $SmoServer.ConnectionContext.SqlConnectionObject -SqlCommandText $SqlQuery -OutputAs 'DataRow'

			$TimeZoneName = $Results.TimeZoneName

			[System.TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneName)
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Get-SqlToolsPath {
	<#
	.SYNOPSIS
	Return path to SQL Tools.
	.DESCRIPTION
	Return path to SQL Tools.
	.PARAMETER Session
	Specifies PS Session.
	.EXAMPLE
	Get-SqlToolsPath -Session $Session

	Return path to SQL Tools.
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.String])]

	param (
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Management.Automation.RunSpaces.PSSession]$Session
	)

	begin {
		$HKLMPath = 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\*\Tools\ClientSetup'
	}

	process {
		try {
			$CommandParameters = @{
				'ScriptBlock' = {
						param($Path)
						Get-ItemProperty -Path $Path -Name Path -ErrorAction SilentlyContinue | Sort-Object -Property Path | Select-Object -Last 1
					}
				'ArgumentList' = $HKLMPath
			}

			If ($PSBoundParameters.ContainsKey('Session')) {
				$CommandParameters.Add('Session', $Session)
			}

			$CommandOutput = Invoke-Command @CommandParameters

			if ($null -eq $CommandOutput) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Bin path not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$HKLMPath
				)
			} else {
				[System.IO.DirectoryInfo]$BinPath = $CommandOutput.Path
			}

			$BinPath.ToString()
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-TimeInTimeZone {
	<#
	.SYNOPSIS
	Returns DateTimeOffset from UTC date time.
	.DESCRIPTION
	Returns DateTimeOffset from UTC date time.
	.PARAMETER UTCDateTime
	Universal Coordinated Time (UTC).
	.PARAMETER TimeZone
	TimeZoneInfo Object.
	.PARAMETER TimeZoneId
	Time zone id string.
	.EXAMPLE
	Get-TimeInTimeZone -UTCDateTime '8/26/2021 9:43:23 PM' -TimeZone $TimeZone
	.EXAMPLE
	Get-TimeInTimeZone -UTCDateTime '8/26/2021 9:43:23 PM' -TimeZoneId 'Eastern Standard Time'
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'None',
		DefaultParameterSetName = 'TimeZoneId'
	)]

	[OutputType([System.DateTimeOffset])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.DateTime]$UTCDateTime,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TimeZone'
		)]
		[System.TimeZoneInfo]$TimeZone,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TimeZoneId'
		)]
		[ArgumentCompleter({ [ArgumentCompleterResult]::GetArgumentCompleterResult($Args) })]
		[string]$TimeZoneId
	)

	 begin {
	 }

	 process {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'TimeZoneId') {
				[System.TimeZoneInfo]$TimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneId)
			}

			$LocalTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($UTCDateTime, $TimeZone)

			$DateTimeOffset = [DateTimeOffset]::New($LocalTime, $TimeZone.GetUtcOffset($LocalTime))

			if ($TimeZone.IsAmbiguousTime($DateTimeOffset)) {
				Write-Warning 'Ambiguous time'
			}

			$DateTimeOffset
		}
		catch {
			throw $_
		}
	}

	 end {
	 }
}

function Initialize-SqlServerMaintenanceDatabase {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$AdminDatabase = $Script:PSMConfig.Config.AdminDatabase

			$DatabaseObject = Get-SmoDatabaseObject -SmoServerObject $SmoServer -DatabaseName $AdminDatabase.DatabaseName
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}

		$SchemaDDL_FormatString = "IF NOT EXISTS (
				SELECT name
				FROM sys.schemas
				WHERE name = N'{0}'
			)
				EXEC(N'CREATE SCHEMA [{0}] AUTHORIZATION [dbo]');"

		$DDL_FormatString = "IF NOT EXISTS (
			SELECT TABLE_CATALOG
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_TYPE = N'BASE TABLE'
				AND TABLE_SCHEMA = N'{0}'
				AND TABLE_NAME = N'{1}'
		)
		BEGIN
			CREATE TABLE [{0}].[{1}](
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
				AND TABLE_SCHEMA = N'{2}'
				AND TABLE_NAME = N'{3}'
		)
		BEGIN
			CREATE TABLE [{2}].[{3}](
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
				AND TABLE_SCHEMA = N'{4}'
				AND TABLE_NAME = N'{5}'
		)
		BEGIN
			CREATE TABLE [{4}].[{5}](
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
				AND TABLE_SCHEMA = N'{6}'
				AND TABLE_NAME = N'{7}'
		)
		BEGIN
			CREATE TABLE [{6}].[{7}](
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
				AND TABLE_SCHEMA = N'{8}'
				AND TABLE_NAME = N'{9}'
		)
		BEGIN
			CREATE TABLE [{8}].[{9}](
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
				AND TABLE_SCHEMA = N'{10}'
				AND TABLE_NAME = N'{11}'
		)
		BEGIN
			CREATE TABLE [{10}].[{11}](
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
				AND TABLE_SCHEMA = N'{12}'
				AND TABLE_NAME = N'{13}'
		)
		BEGIN
			CREATE TABLE [{12}].[{13}](
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
				AND TABLE_SCHEMA = N'{14}'
				AND TABLE_NAME = N'{15}'
		)
		BEGIN
			CREATE TABLE [{14}].[{15}](
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
				AND TABLE_SCHEMA = N'{16}'
				AND TABLE_NAME = N'{17}'
		)
		BEGIN
			CREATE TABLE [{16}].[{17}](
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
	}

	process {
		try {
			$NewSchemas = $AdminDatabase.SelectNodes("//*[@SchemaName]").SchemaName.where({$_ -notin $DatabaseObject.Schemas.Name}) | Select-Object -Unique

			foreach ($NewSchema in $NewSchemas) {
				if ($PSCmdlet.ShouldProcess($NewSchema, 'Create database schema')) {
					$DatabaseObject.ExecuteNonQuery([string]::Format($SchemaDDL_FormatString, $NewSchema))
				}
			}

			$FormatStringArray = @(
				$AdminDatabase.SqlAgentAlerts.SchemaName
				$AdminDatabase.SqlAgentAlerts.TableName
				$AdminDatabase.Statistics.Backup.SchemaName
				$AdminDatabase.Statistics.Backup.TableName
				$AdminDatabase.Statistics.ColumnStore.SchemaName
				$AdminDatabase.Statistics.ColumnStore.TableName
				$AdminDatabase.Statistics.Database.SchemaName
				$AdminDatabase.Statistics.Database.TableName
				$AdminDatabase.Statistics.FullTextIndex.SchemaName
				$AdminDatabase.Statistics.FullTextIndex.TableName
				$AdminDatabase.Statistics.Index.SchemaName
				$AdminDatabase.Statistics.Index.TableName
				$AdminDatabase.Statistics.QueryStore.SchemaName
				$AdminDatabase.Statistics.QueryStore.TableName
				$AdminDatabase.Statistics.TableStatistics.SchemaName
				$AdminDatabase.Statistics.TableStatistics.TableName
				$AdminDatabase.Tests.Backup.SchemaName
				$AdminDatabase.Tests.Backup.TableName
			)

			if ($PSCmdlet.ShouldProcess($DatabaseObject.Name, 'Create database tables')) {
				$DatabaseObject.ExecuteNonQuery([string]::Format($DDL_FormatString, $FormatStringArray))
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-CycleFullTextIndexLog {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			if ($SmoServer.IsFullTextInstalled -eq $false) {
				Write-Warning 'Full-Text is not installed.'

				Disconnect-SmoServer -SmoServerObject $SmoServer

				Break
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Cycle Full Text Index Log Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$QueryString = 'SELECT
			SchemaName = s.name
		,	TableName = t.name
		,	CatalogName = c.name
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		INNER JOIN sys.fulltext_indexes fi ON t.[object_id] = fi.[object_id]
		INNER JOIN sys.fulltext_catalogs c ON fi.fulltext_catalog_id = c.fulltext_catalog_id
		ORDER BY SchemaName
		,	TableName
		,	CatalogName;'
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({ $_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.name -NotIn @('master', 'tempdb', 'model')})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to cycle full text index log on database ""$Item"".  Database does not exist or database not accessible on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				Write-Verbose "Performing full text index maintenance on database $Database."

				try {
					$FullTextIndexStats = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $FullTextIndexStats.Tables[0]) {
						try {
							$SqlNonQuery = [string]::Format("EXEC dbo.sp_fulltext_recycle_crawl_log @ftcat = N'{0}'", $Row.CatalogName)

							if ($PSCmdlet.ShouldProcess($Database.Name, 'Cycle full text catalog log')) {
								$Database.ExecuteNonQuery($SqlNonQuery)
							}
						}
						catch {
							$ErrorRecord = $_

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									$PSCmdlet.WriteError($ErrorRecord)
								}
								Default {
									$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SmoServer.Name
										'DatabaseName' = $Database.Name
									}

									$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

									$MailMessageParameters.Add('Subject', 'Cycle Full Text Index Catalog Log Failure')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'Cycle Full Text Index Catalog Log Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Cycle Full Text Index Log Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-LogShipping {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Collections.Generic.List[SqlServerMaintenance.SqlLogShip]])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[LSOperation]$LSOperation,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Management.Automation.RunSpaces.PSSession]$Session
	)

	begin {
		switch ($LSOperation) {
			'Backup' {
				$Query_LogShipping = 'SELECT
						LSID = primary_id
					,	primary_database
					,	ServerName = @@SERVERNAME
					FROM dbo.log_shipping_primary_databases
					ORDER BY primary_database;'
			}
			'Copy' {
				$Query_LogShipping = 'SELECT
						LSID = d.secondary_id
					,	s.primary_database
					,	d.secondary_database
					,	s.backup_destination_directory
					,	ServerName = @@SERVERNAME
					FROM dbo.log_shipping_secondary_databases d
					INNER JOIN dbo.log_shipping_secondary s ON d.secondary_id = s.secondary_id
					ORDER BY d.secondary_database;'
			}
			'Restore' {
				$Query_LogShipping = 'SELECT
						LSID = d.secondary_id
					,	s.primary_database
					,	d.secondary_database
					,	ServerName = @@SERVERNAME
					FROM dbo.log_shipping_secondary_databases d
					INNER JOIN dbo.log_shipping_secondary s ON d.secondary_id = s.secondary_id
					ORDER BY secondary_database;'
			}
		}

		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName 'master'
			}

			if ($PSVersionTable.PSEdition -ne 'Desktop') {
				$SqlClientDataSetParameters = @{
					'SqlConnection' = $SqlConnection
					'DatabaseName' = 'master'
					'SqlCommandText' = 'SELECT host_platform FROM sys.dm_os_host_info;'
					'OutputAs' = 'DataRow'
				}

				$SqlHostPlatform = Get-SqlClientDataSet @SqlClientDataSetParameters

				if ($PSVersionTable.Platform -ne 'Win32NT' -or $SqlHostPlatform.host_platform -ne 'Windows') {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Function is supported on Windows and SQL Server on Windows.'),
						'1',
						[System.Management.Automation.ErrorCategory]::NotImplemented,
						$SqlHostPlatform
					)
				}
			}

			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'DatabaseName' = 'msdb'
				'SqlCommandText' = $Query_LogShipping
				'OutputAs' = 'DataTable'
			}

			$LogShippingDatabases = Get-SqlClientDataSet @SqlClientDataSetParameters

			if ($LogShippingDatabases.Rows.Count -gt 0) {
				$ServerName = $LogShippingDatabases[0].ServerName
			} else {
				$ServerName = [System.Net.Dns]::GetHostName()
			}

			if ($PSBoundParameters.ContainsKey('Session')) {
				$SqlToolsPath = Get-SqlToolsPath -Session $Session
			} else {
				$SqlToolsPath = Get-SqlToolsPath
			}

			if ($null -eq $SqlToolsPath) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('SQL Tools path not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SqlToolsPath
				)
			}

			$CommandParameters = @{
				'ScriptBlock' = {
						param($Path)
						try {
							Join-Path -Path $Path -ChildPath 'SqlLogShip.exe' -Resolve
						}
						catch {
							throw $_
						}
					}
				'ArgumentList' = $SqlToolsPath
			}

			If ($PSBoundParameters.ContainsKey('Session')) {
				$CommandParameters.Add('Session', $Session)
			}

			$SqlLogShipExecutable = Invoke-Command @CommandParameters
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $ServerName
						'DatabaseName' = $PrimaryDatabase
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', "SQL Log Shipping $LSOperation Failure")
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$LogShippingDatabases = $LogShippingDatabases.where({$_.primary_database -in $DatabaseName})

				if ($LogShippingDatabases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $LogShippingDatabases.primary_database})
				}

				foreach ($Item in $Collection) {
					Write-Warning "$Item does not exist or is not configured for log shipping on SQL server instance $ServerInstance."
				}
			}

			foreach ($LogShippingDatabase in $LogShippingDatabases) {
				try {
					$PrimaryDatabase = $LogShippingDatabase.primary_database

					Write-Verbose "Primary Database: $PrimaryDatabase"

					if ($LSOperation -eq 'Copy') {
						$BackupDestination = $LogShippingDatabase.backup_destination_directory

						[void][System.IO.Directory]::CreateDirectory($BackupDestination)
					}

					$FormatStringArray = @(
						$SqlLogShipExecutable,
						$LSOperation,
						$LogShippingDatabase.LSID,
						$LogShippingDatabase.ServerName
					)

					$CommandString = [string]::Format('."{0}" -{1} {2} -Server {3}', $FormatStringArray)

					$ScriptBlock = {
						param($CommandString)

						$Output = Invoke-Command -ScriptBlock ([scriptblock]::Create($CommandString))

						[PsCustomObject][Ordered]@{
							'ExitCode' = $LASTEXITCODE
							'Output' = $Output
						}
					}

					if ($PSCmdlet.ShouldProcess($PrimaryDatabase, 'Logship database')) {
						$CommandParameters = @{
							'ScriptBlock' = $ScriptBlock
							'ArgumentList' = $CommandString
						}

						If ($PSBoundParameters.ContainsKey('Session')) {
							$CommandParameters.Add('Session', $Session)
						}

						$CmdOutput = Invoke-Command @CommandParameters

						$CmdOutputLines = $CmdOutput.Output.Split("`r`n")

						$OutputList = [System.Collections.Generic.List[SqlServerMaintenance.SqlLogShip]]::New()

						for ($i = 1; $i -lt $CmdOutputLines.Count - 2; $i++) {
							$OutputLine = [SqlServerMaintenance.SqlLogShip]::New()

							$OutputLine.DatabaseName = $PrimaryDatabase

							if ($CmdOutputLines[$i].Split("`t").Count -gt 1) {
								$OutputLine.DateTime = [DateTime]$CmdOutputLines[$i].Split("`t")[0]
								$OutputLine.Transcript = $CmdOutputLines[$i].Split("`t")[1]
							} else {
								$OutputLine.Transcript = $CmdOutputLines[$i]
							}

							$OutputList.Add($OutputLine)
						}

						$OutputList

						if ($CmdOutput.ExitCode -ne 0) {
							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									$PSCmdlet.WriteError(
										[System.Management.Automation.ErrorRecord]::New(
											[Exception]::New('An error has occurred.  Check command output for errors.'),
											'1',
											[System.Management.Automation.ErrorCategory]::InvalidResult,
											$null
										)
									)
								}
								Default {
									$XmlDocument = $OutputList | Select-Object DateTime, Transcript | ConvertTo-Xml -NoTypeInformation

									$SummaryItem = [ordered]@{
										'SqlInstance' = $ServerName
										'DatabaseName' = $PrimaryDatabase
									}

									$EmailBody = Build-MailBody -Xml $XmlDocument -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()
									$MailMessageParameters.Add('Subject', "SQL Log Shipping $LSOperation Failure")
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerName
								'DatabaseName' = $PrimaryDatabase
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', "SQL Log Shipping $LSOperation Failure")
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}

					Start-Sleep -Seconds 5
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $ServerName
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', "SQL Log Shipping $LSOperation Failure")
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
	}

	end {
	}
}

function Invoke-ReplaceInvalidCharacter {
	<#
	.SYNOPSIS
	Replace special characters.
	.DESCRIPTION
	Replace special characters with another character.
	.PARAMETER InputString
	String to replace special characters.
	.EXAMPLE
	Invoke-ReplaceInvalidCharacter -InputString 'Some String'
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'None'
	)]

	[OutputType([System.String])]

	param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateNotNullOrEmpty()]
		[string]$InputString
	)

	begin {
		$InvalidCharacters = [string]::Join('', [System.IO.Path]::GetInvalidFileNameChars())

		$RegExString = [string]::Format('[{0}]|^\.$', [Regex]::Escape($InvalidCharacters))
	}

	process {
		$OutputString = $InputString

		$OutputString = $OutputString -replace $RegExString, '_'
		$OutputString = $OutputString -replace '^\.\.', '__'

		$OutputString
	}

	end {
	}
}

function Invoke-RetryScriptBlock {
	<#
	.SYNOPSIS
	Execute a script block.
	.DESCRIPTION
	Attempt to execute a script block up to the maximum retry attempts.
	.PARAMETER ScriptBlock
	Specifies the commands to run.
	.PARAMETER Arguments
	Supplies the values of local variables in the command.  Enter the values in a comma-separated list.
	.PARAMETER MaxRetry
	Specifies the maximum number of attempts to perform.
	.EXAMPLE
	Invoke-RetryScriptBlock -ScriptBlock @{Write-Host 'Hello World'}
	.EXAMPLE
	Invoke-RetryScriptBlock -ScriptBlock @{param($MyVar) Write-Host "Hello $MyVar"} -Arguments 'World'
	.NOTES
	Exponential Back-off Max == (2^n)-1
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	#[OutputType([PSObject])]

	Param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[scriptblock]$ScriptBlock,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[array]$Arguments,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 10)]
		[int]$MaxRetry = 3
	)

	begin {
		$Attempt = 1
	}

	process {
		do {
			try
			{
				$ScriptBlock.Invoke($Arguments)

				break
			}
			catch {
				$RetryDelay = ([math]::Pow(2, $Attempt) - 1) * 100

				Write-Verbose ([string]::Format('Error: {0}', $_.Exception.Message))
				Write-Verbose ([string]::Format('Attempt {0} of {1} failed.  Waiting {2} milliseconds before next attempt.', $Attempt, $MaxRetry, $RetryDelay))

				if ($Attempt -lt $MaxRetry) {
					Start-Sleep -Milliseconds $RetryDelay
				}
				else {
					throw $_
				}
			}

			$Attempt++
		} while ($Attempt -le $MaxRetry)
	}

	end {
	}
}

function Invoke-SqlBackupVerification {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'Default'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByInstancePath-SqlInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SqlInstance'
		)]
		[ValidateLength(1,128)]
		[string]$TestBackupSqlInstance = '.',

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByInstancePath-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SqlInstance'
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo[]]$BackupPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByInstancePath-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByInstancePath-SqlInstance'
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo[]]$SqlInstanceBackupPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByInstancePath-SqlConnection'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByInstancePath-SqlInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlConnection'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ByServerInstance-SqlInstance'
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName
	)

	begin {
		try {
			$TestsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$TestSchemaName = $Script:PSMConfig.Config.AdminDatabase.Tests.Backup.SchemaName
			$TestTableName = $Script:PSMConfig.Config.AdminDatabase.Tests.Backup.TableName

			$ServerInstanceParameterSets = @('ByInstancePath-SqlInstance', 'ByServerInstance-SqlInstance', 'Default-SqlInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $TestBackupSqlInstance -DatabaseName $TestsDatabaseName
			}

			$SmoServerObject = Connect-SmoServer -SqlConnection $SqlConnection
			$SmoServerObject.ConnectionContext.StatementTimeout = 0

			$SqlServerName = $SmoServerObject.NetName

			if ($PSBoundParameters.ContainsKey('SqlInstanceBackupPath')) {
				[System.IO.DirectoryInfo[]]$BackupPath = $SqlInstanceBackupPath
			}

			if ($SmoServerObject.HostPlatform -eq 'Windows') {
				if ([Environment]::MachineName -ne $SmoServerObject.NetName) {
					if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
						if (-not $([System.Uri]$BackupPath.FullName).IsUnc) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Local backup paths are not supported for remote SQL instances.'),
								'1',
								[System.Management.Automation.ErrorCategory]::NotImplemented,
								$BackupPath
							)
						}
					} else {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Restoring backup of SQL Server on Windows from non-Windows host is not supported.'),
							'1',
							[System.Management.Automation.ErrorCategory]::NotImplemented,
							$BackupPath
						)
					}
				}
			} else {
				if ([Environment]::MachineName -ne $SmoServerObject.NetName) {
					if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Restoring backup of SQL Server on Linux from Windows host is not supported.'),
							'1',
							[System.Management.Automation.ErrorCategory]::NotImplemented,
							$BackupPath
						)
					}
				}
			}

			Remove-BackupTestDatabase -SmoServerObject $SmoServerObject -Confirm:$false
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SqlConnection) {
					if ($SqlConnection -is [Microsoft.Data.SqlClient.SqlConnection]) {
						Disconnect-SqlServerInstance -SqlConnection $SqlConnection
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Sql Backup Verification Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$Query_LastTested = "SELECT TOP(1) BackupDateTime AT TIME ZONE 'UTC' AS BackupDateTime
			,	BackupFileName
			,	TestStatus
			FROM [{0}].[{1}] t
			WHERE BackupFolder = N'{2}'
				AND BackupType = 'L'
				AND TestStatus IN ('F', 'S')
			ORDER BY t.BackupDateTime DESC;"

		$Query_FailedTests = "SELECT BackupFileName
			FROM [{0}].[{1}]
			WHERE BackupFolder = N'{2}'
				AND BackupType IN ('D', 'F')
				AND TestStatus = 'F';"

		$Query_TestedBackups = "SELECT BackupFileName
			FROM [{0}].[{1}]
			WHERE TestStatus IS NOT NULL
				AND BackupFolder = N'{2}';"

		$Insert_BackupFile = "INSERT INTO [{0}].[{1}] (CollectionDate, BackupDateTime, ServerName, BackupFolder, BackupFileName, BackupType, BackupPosition, DatabaseGUID, DatabaseName, FirstLSN, LastLSN, CheckpointLSN, DatabaseBackupLSN)
			SELECT CollectionDate
			,	BackupDateTime
			,	ServerName
			,	BackupFolder
			,	BackupFileName
			,	BackupType
			,	BackupPosition
			,	DatabaseGUID
			,	DatabaseName
			,	FirstLSN
			,	LastLSN
			,	CheckpointLSN
			,	DatabaseBackupLSN
			FROM (
				VALUES (
					'{2}', '{3}', N'{4}', N'{5}', N'{6}', UPPER('{7}'), {8}, '{9}', N'{10}', '{11}', '{12}', '{13}', '{14}'
				)
			) v(CollectionDate, BackupDateTime, ServerName, BackupFolder, BackupFileName, BackupType, BackupPosition, DatabaseGUID, DatabaseName, FirstLSN, LastLSN, CheckpointLSN, DatabaseBackupLSN)
			WHERE NOT EXISTS (
				SELECT 1
				FROM [{0}].[{1}]
				WHERE BackupFolder = N'{5}'
					AND BackupFileName = N'{6}'
					AND BackupPosition = {8}
			);"

		$Update_BackupFile = "UPDATE [{0}].[{1}]
			SET TestStatus = '{5}'
			,	TestDateTime = '{6}'
			WHERE BackupFolder = N'{2}'
				AND BackupFileName = N'{3}'
				AND BackupPosition = {4};"

		$DropTestDatabaseDDL = 'DROP DATABASE IF EXISTS [{0}];'

		$ProgressParameters = @{
			'Id' = 0
			'Activity' = 'Backup Folder'
			'Status' = [string]::Format('Folder {0} of {1}', 0, $BackupPath.Count)
			'CurrentOperation' = ''
			'PercentComplete' = 0
		}
	}

	process {
		try {
			foreach ($RootPath in $BackupPath) {
				try {
					$ProgressParameters.Status = [string]::Format('Folder {0} of {1}', $BackupPath.IndexOf($RootPath) + 1, $BackupPath.Count)
					$ProgressParameters.CurrentOperation = [string]::Format('Folder: {0}', $RootPath.FullName)
					$ProgressParameters.PercentComplete = $BackupPath.IndexOf($RootPath) / $BackupPath.Count * 100

					Write-Verbose $ProgressParameters.CurrentOperation
					Write-Progress @ProgressParameters

					if ($PSBoundParameters.ContainsKey('SqlInstanceBackupPath')) {
						[System.IO.DirectoryInfo[]]$InstanceFolders = $SqlInstanceBackupPath
					} elseif ($PSBoundParameters.ContainsKey('ServerInstance')) {
						[System.IO.DirectoryInfo[]]$InstanceFolders = Join-Path2 -Path $RootPath.FullName -ChildPath $ServerInstance -Resolve
					} else {
						[System.IO.DirectoryInfo[]]$InstanceFolders = [System.IO.Directory]::GetDirectories($RootPath, '*', [System.IO.SearchOption]::TopDirectoryOnly)
					}

					$ProgressParameters1 = @{
						'Id' = 1
						'ParentID' = 0
						'Activity' = 'Instance Folder'
						'Status' = [string]::Format('Folder {0} of {1}', 0, $InstanceFolders.Count)
						'CurrentOperation' = ''
						'PercentComplete' = 0
					}

					foreach ($InstanceFolder in $InstanceFolders) {
						try {
							$ProgressParameters1.Status = [string]::Format('Folder {0} of {1}', $InstanceFolders.IndexOf($InstanceFolder) + 1, $InstanceFolders.Count)
							$ProgressParameters1.CurrentOperation = [string]::Format('Instance Folder: {0}', $InstanceFolder.FullName)
							$ProgressParameters1.PercentComplete = $InstanceFolders.IndexOf($InstanceFolder) / $InstanceFolders.Count * 100

							Write-Verbose $ProgressParameters1.CurrentOperation
							Write-Progress @ProgressParameters1

							$DatabaseFolders = [System.Collections.Generic.List[System.IO.DirectoryInfo]]::New()

							if ($PSBoundParameters.ContainsKey('DatabaseName')) {
								foreach ($FolderName in $DatabaseName) {
									$FolderName = Invoke-ReplaceInvalidCharacter -InputString $FolderName

									$Path = Join-Path2 -Path $InstanceFolder -ChildPath $FolderName -Resolve

									$DatabaseFolders.Add([System.IO.DirectoryInfo]$Path)
								}
							} else {
								$DatabaseFolders.AddRange([System.IO.DirectoryInfo[]]$([System.IO.Directory]::GetDirectories($InstanceFolder, '*', [System.IO.SearchOption]::TopDirectoryOnly)))
							}

							$ProgressParameters2 = @{
								'Id' = 2
								'ParentID' = 1
								'Activity' = 'Database Backup Folder'
								'Status' = [string]::Format('Database {0} of {1}', 0, $DatabaseFolders.Count)
								'CurrentOperation' = ''
								'PercentComplete' = 0
							}

							foreach ($DatabaseFolder in $DatabaseFolders) {
								try {
									$ProgressParameters2.Status = [string]::Format('Database {0} of {1}', $DatabaseFolders.IndexOf($DatabaseFolder) + 1, $DatabaseFolders.Count)
									$ProgressParameters2.CurrentOperation = [string]::Format('Database Folder: {0}', $DatabaseFolder.FullName)
									$ProgressParameters2.PercentComplete = $DatabaseFolders.IndexOf($DatabaseFolder) / $DatabaseFolders.Count * 100

									Write-Verbose $ProgressParameters2.CurrentOperation
									Write-Progress @ProgressParameters2

									$TestRecoveryDatabaseName = 'TestRecovery_' + [Guid]::NewGuid().ToString()

									$FormatStringArray = @(
										$TestSchemaName,
										$TestTableName,
										$DatabaseFolder
									)

									$SqlClientDataSetParameters = @{
										'SqlConnection' = $SqlConnection
										'SqlCommandText' = [string]::Format($Query_LastTested, $FormatStringArray)
										'OutputAs' = 'DataRow'
									}

									$LastLogBackupTest = Get-SqlClientDataSet @SqlClientDataSetParameters

									[SqlServerMaintenance.BackupFileInfo[]]$SqlBackupFiles = Get-SqlBackupFile -Path $DatabaseFolder

									#Region Get Backup File List
									$BackupFileInfo = [System.Collections.Generic.List[SqlServerMaintenance.BackupFileInfo]]::New()

									$LastDatabaseBackup = $SqlBackupFiles.where({$_.Extension -in @('.bak', '.dif')}) | Measure-Object -Property BackupDate -Maximum

									if ($null -eq $LastDatabaseBackup) {
										throw [System.Management.Automation.ErrorRecord]::New(
											[Exception]::New('Backup file not found.'),
											'1',
											[System.Management.Automation.ErrorCategory]::ObjectNotFound,
											$DatabaseFolder.FullName
										)
									}

									$LastDatabaseBackupFile = $SqlBackupFiles.where({$_.Extension -in @('.bak', '.dif') -and $_.BackupDate -eq $LastDatabaseBackup.Maximum})

									$LastDatabaseBackupFileInfo = [System.IO.FileInfo]$LastDatabaseBackupFile.FullName

									if ($null -eq $LastLogBackupTest) {
										#Region SimpleRecovery or New Untested Database
										$FullBackups = $SqlBackupFiles.where({$_.Extension -eq '.bak'}) | Sort-Object -Property BackupDate

										foreach ($FullBackup in $FullBackups) {
											$FullBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $FullBackup.FullName -SmoServerObject $SmoServerObject

											if ($FullBackupHeader[0].IsCopyOnly) {
												$FirstFullBackupFile = $null
											} else {
												$FirstFullBackupFile = $FullBackup

												break
											}
										}

										if ($null -eq $FullBackups -or $null -eq $FirstFullBackupFile) {
											throw [System.Management.Automation.ErrorRecord]::New(
												[Exception]::New('Full backup file not found.'),
												'1',
												[System.Management.Automation.ErrorCategory]::ObjectNotFound,
												$DatabaseFolder.FullName
											)
										}

										$TargetTransactionLogs = $SqlBackupFiles.where({$_.Extension -eq '.trn' -and $_.BackupDate -ge $FirstFullBackupFile.BackupDate -and $_.BackupDate -le $LastDatabaseBackupFileInfo.LastWriteTime})

										if ($TargetTransactionLogs.Count -gt 0) {
											$BackupFileInfo.Add($($FirstFullBackupFile))

											$FirstTransactionLogBackup = $TargetTransactionLogs | Measure-Object -Property BackupDate -Minimum

											$FirstTransactionLogBackupFile = $TargetTransactionLogs.where({$_.BackupDate -eq $FirstTransactionLogBackup.Minimum})

											$TargetDiffs = $SqlBackupFiles.where({$_.Extension -eq '.dif' -and $_.BackupDate -gt $FirstFullBackupFile.BackupDate -and $_.BackupDate -le $FirstTransactionLogBackupFile.BackupDate })

											$BackupFileInfo.AddRange([SqlServerMaintenance.BackupFileInfo[]]$TargetDiffs)
											$BackupFileInfo.AddRange([SqlServerMaintenance.BackupFileInfo[]]$TargetTransactionLogs)
										} else {
											$FullBackups = $SqlBackupFiles.where({$_.Extension -eq '.bak'}) | Sort-Object -Property BackupDate -Descending

											foreach ($FullBackup in $FullBackups) {
												$BackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $FullBackup.FullName -SmoServerObject $SmoServerObject

												if ($BackupHeader[0].IsCopyOnly) {
													$LastFullBackupFile = $null
												} else {
													$LastFullBackupFile = $FullBackup

													break
												}
											}

											if ($BackupHeader.RecoveryModel -eq 'SIMPLE') {
												$BackupFileInfo.Add($($LastFullBackupFile))

												$LastDiffBackup = $SqlBackupFiles.where({$_.Extension -eq '.dif' -and $_.BackupDate -gt $LastFullBackupFile.BackupDate}) | Measure-Object -Property BackupDate -Maximum

												if ($null -ne $LastDiffBackup) {
													$LastDiffBackupFile = $SqlBackupFiles.where({$_.Extension -eq '.dif' -and $_.BackupDate -eq $LastDiffBackup.Maximum})

													if ($LastDiffBackupFile.Count -gt 0) {
														$BackupFileInfo.Add($($LastDiffBackupFile))
													}
												}
											} else {
												$BackupFileInfo.Add($($FirstFullBackupFile))
											}
										}
										#EndRegion
									} else {
										$FormatStringArray = @(
											$TestSchemaName,
											$TestTableName,
											$DatabaseFolder
										)

										$SqlClientDataSetParameters = @{
											'SqlConnection' = $SqlConnection
											'SqlCommandText' = [string]::Format($Query_FailedTests, $FormatStringArray)
											'OutputAs' = 'DataRow'
										}

										$FailedTests = Get-SqlClientDataSet @SqlClientDataSetParameters

										if ($null -ne $FailedTests) {
											[SqlServerMaintenance.BackupFileInfo[]]$SqlBackupFiles = $SqlBackupFiles.where({$_.Name -NotIn $FailedTests.BackupFileName})
										}

										switch ($LastLogBackupTest.TestStatus) {
											'F' {
												#Region Failed Backup
												[SqlServerMaintenance.BackupFileInfo[]]$NextBackups = $SqlBackupFiles.where({$_.Extension -In ('.bak', '.dif') -and $_.BackupDate -gt $LastLogBackupTest.BackupDateTime}) | Sort-Object -Property BackupDate

												if ($NextBackups.Count -eq 0) {
													throw [System.Management.Automation.ErrorRecord]::New(
														[Exception]::New("No database backup exists following the failed transaction log restore.  A database backup must exist in folder $($DatabaseFolder.FullName) following the failed transaction log failure at $($LastLogBackupTest.BackupDateTime)."),
														'1',
														[System.Management.Automation.ErrorCategory]::ObjectNotFound,
														$DatabaseFolder.FullName
													)
												}

												foreach ($NextBackup in $NextBackups) {
													if ($NextBackup.Extension -eq '.dif') {
														$NextBackupFile = $NextBackup

														break
													} else {
														$FullBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $NextBackup.FullName -SmoServerObject $SmoServerObject

														if ($FullBackupHeader[0].IsCopyOnly) {
															$NextBackupFile = $null
														} else {
															$NextBackupFile = $NextBackup

															break
														}
													}
												}

												if ($NextBackupFile.Extension -eq '.dif') {
													$PreviousFullBackups = $SqlBackupFiles.where({$_.Extension -eq '.bak' -and $_.BackupDate -lt $NextBackupFile.BackupDate}) | Sort-Object -Property BackupDate -Descending

													foreach ($PreviousFullBackup in $PreviousFullBackups) {
														$FullBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $PreviousFullBackup.FullName -SmoServerObject $SmoServerObject

														if ($FullBackupHeader[0].IsCopyOnly -eq $false) {
															$BackupFileInfo.Add($PreviousFullBackup)

															break
														}
													}
												}

												$BackupFileInfo.Add($($NextBackupFile))
												$BackupFileInfo.AddRange([SqlServerMaintenance.BackupFileInfo[]]($SqlBackupFiles.where({$_.Extension -eq '.trn' -and $_.BackupDate -gt $NextBackupFile.BackupDate -and $_.BackupDate -le $LastDatabaseBackupFileInfo.LastWriteTime})))
												#EndRegion
											}
											'S' {
												$FirstUntestedLogBackup = $SqlBackupFiles.where({$_.Extension -eq '.trn' -and $_.BackupDate -gt $LastLogBackupTest.BackupDateTime}) | Measure-Object -Property BackupDate -Minimum

												if ($null -eq $FirstUntestedLogBackup) {
													#Region No Untested Log Backups
													$NextBackups = $SqlBackupFiles.where({$_.Extension -In ('.bak', '.dif') -and $_.BackupDate -gt $LastLogBackupTest.BackupDateTime}) | Sort-Object -Property BackupDate

													foreach ($NextBackup in $NextBackups) {
														$BackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $NextBackup.FullName -SmoServerObject $SmoServerObject

														if ($NextBackup.Extension -eq '.dif') {
															$NextDatabaseBackupFile = $NextBackup

															break
														} else {
															if ($BackupHeader[0].IsCopyOnly) {
																$NextDatabaseBackupFile = $null
															} else {
																$NextDatabaseBackupFile = $NextBackup

																break
															}
														}
													}

													if ($null -ne $NextBackups -and $BackupHeader.RecoveryModel -eq 'SIMPLE') {
														if ($NextDatabaseBackupFile.Extension -eq '.dif') {
															$PreviousBackups = $SqlBackupFiles.where({$_.Extension -eq '.bak' -and $_.BackupDate -lt $NextDatabaseBackupFile.BackupDate}) | Sort-Object -Property BackupDate -Descending

															foreach ($PreviousBackup in $PreviousBackups) {
																$BackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $PreviousBackup.FullName -SmoServerObject $SmoServerObject

																if ($BackupHeader[0].IsCopyOnly -eq $false) {
																	$BackupFileInfo.Add($PreviousBackup)

																	break
																}
															}
														}
													}
													#EndRegion
												} else {
													#Region Untested Log Backups
													$FirstUntestedLogBackupFile = $SqlBackupFiles.where({$_.Extension -eq '.trn' -and $_.BackupDate -eq $FirstUntestedLogBackup.Minimum})

													$PreviousBackups = $SqlBackupFiles.where({$_.Extension -In ('.bak', '.dif') -and $_.BackupDate -le $FirstUntestedLogBackupFile.BackupDate})

													if ($PreviousBackups.Count -eq 0) {
														if ($null -ne $FirstUntestedLogBackupFile) {
															Write-Warning "Missing database backups prior to $($FirstUntestedLogBackupFile.BackupDateTime) in folder $($DatabaseFolder.FullName)."
														}

														$PreviousBackups = $SqlBackupFiles.where({$_.Extension -eq '.bak'}) | Sort-Object -Property BackupDate

														foreach ($PreviousBackup in $PreviousBackups) {
															$FullBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $PreviousBackup.FullName -SmoServerObject $SmoServerObject

															if ($FullBackupHeader[0].IsCopyOnly) {
																$PreviousBackupFile = $null
															} else {
																$PreviousBackupFile = $PreviousBackup

																break
															}
														}
													} else {
														$PreviousBackups = $PreviousBackups | Sort-Object -Property BackupDate -Descending

														foreach ($PreviousBackup in $PreviousBackups) {
															$FullBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $PreviousBackup.FullName -SmoServerObject $SmoServerObject

															if ($FullBackupHeader[0].IsCopyOnly) {
																$PreviousBackupFile = $null
															} else {
																$PreviousBackupFile = $PreviousBackup

																break
															}
														}
													}

													if ($PreviousBackupFile.Extension -eq '.dif') {
														$PreviousFullBackups = $SqlBackupFiles.where({$_.Extension -eq '.bak' -and $_.BackupDate -lt $PreviousBackupFile.BackupDate}) | Sort-Object -Property BackupDate -Descending

														foreach ($PreviousFullBackup in $PreviousFullBackups) {
															try {
																$FullBackupHeader = Get-SmoBackupHeader -DatabaseBackupPath $PreviousFullBackup.FullName -SmoServerObject $SmoServerObject
															}
															catch {
																continue
															}

															if ($FullBackupHeader[0].IsCopyOnly) {
																$PreviousFullBackupFile = $null
															} else {
																$PreviousFullBackupFile = $PreviousFullBackup

																break
															}
														}

														$BackupFileInfo.Add($PreviousFullBackupFile)
														$BackupFileInfo.Add($PreviousBackupFile)
													} else {
														$BackupFileInfo.Add($PreviousBackupFile)
													}

													$BackupFileInfo.AddRange([SqlServerMaintenance.BackupFileInfo[]]($SqlBackupFiles.where({$_.Extension -eq '.trn' -and $_.BackupDate -ge $PreviousBackupFile.BackupDate -and $_.BackupDate -le $LastDatabaseBackupFileInfo.LastWriteTime})))
													#EndRegion
												}
											}
											Default {
												throw [System.Management.Automation.ErrorRecord]::New(
													[Exception]::New('Unknown test status.'),
													'1',
													[System.Management.Automation.ErrorCategory]::InvalidData,
													$LastLogBackupTest.TestStatus
												)
											}
										}

										if ($BackupFileInfo.Count -eq 0) {
											Write-Verbose 'No untested backups found.'

											Continue
										}
									}
									#EndRegion

									#Region Log Orphaned Backups
									if ($null -ne $LastLogBackupTest) {
										if ($LastLogBackupTest.TestStatus -eq 'F') {
											$OrphanedBackups = $SqlBackupFiles.where({$_.FullName -NotIn $BackupFileInfo.FullName -and $_.BackupDate -gt $LastLogBackupTest.BackupDateTime -and $_.BackupDate -lt $NextBackup.BackupDate})

											foreach ($OrphanedBackup in $OrphanedBackups) {
												$BackupHeaders = Get-SmoBackupHeader -DatabaseBackupPath $OrphanedBackup.FullName -SmoServerObject $SmoServerObject

												foreach ($BackupHeader in $BackupHeaders) {
													$FormatStringArray = @(
														$TestSchemaName,
														$TestTableName,
														[DateTimeOffset]::Now.ToSTring(),
														$OrphanedBackup.BackupDate,
														$InstanceFolder.Name,
														$DatabaseFolder,
														$OrphanedBackup.Name,
														$OrphanedBackup.BackupType.SubString(0, 1).ToUpper(),
														$BackupHeader.Position,
														$BackupHeader.BindingID.Guid,
														$BackupHeader.DatabaseName,
														$BackupHeader.FirstLSN,
														$BackupHeader.LastLSN,
														$BackupHeader.CheckpointLSN,
														$BackupHeader.DatabaseBackupLSN
													)

													$SqlClientNonQueryParameters = @{
														'SqlConnection' = $SqlConnection
														'SqlCommandText' = [string]::Format($Insert_BackupFile, $FormatStringArray)
													}

													[void](Invoke-SqlClientNonQuery @SqlClientNonQueryParameters)

													$FormatStringArray = @(
														$TestSchemaName,
														$TestTableName,
														$DatabaseFolder,
														$OrphanedBackup.Name,
														$BackupHeader.Position,
														'O',
														[DateTimeOffset]::Now.ToSTring()
													)

													$SqlClientNonQueryParameters = @{
														'SqlConnection' = $SqlConnection
														'SqlCommandText' = [string]::Format($Update_BackupFile, $FormatStringArray)
													}

													[void](Invoke-SqlClientNonQuery @SqlClientNonQueryParameters)
												}
											}
										}
									}
									#EndRegion

									#Region Build Restore DDL
									$FormatStringArray = @(
										$TestSchemaName,
										$TestTableName,
										$DatabaseFolder
									)

									$SqlClientDataSetParameters = @{
										'SqlConnection' = $SqlConnection
										'SqlCommandText' = [string]::Format($Query_TestedBackups, $FormatStringArray)
										'OutputAs' = 'DataRow'
									}

									$TestedBackups = Get-SqlClientDataSet @SqlClientDataSetParameters

									if ($null -ne $TestedBackups) {
										if ($BackupFileInfo.where({$_.Name -NotIn $TestedBackups.BackupFileName}).Count -eq 0) {
											Write-Verbose 'No untested backups found.'

											Continue
										}
									}

									$DatabaseRecoveryParameters = @{
										'SmoServerObject' = $SmoServerObject
										'BackupFileInfo' = $BackupFileInfo
										'NewDatabaseName' = $TestRecoveryDatabaseName
									}

									[SqlServerMaintenance.Restore[]]$DatabaseRecovery = Get-DatabaseRecovery @DatabaseRecoveryParameters -SkipLogChainCheck -NoRecovery

									foreach ($RecoveryItem in $DatabaseRecovery) {
										$BackupFile = $BackupFileInfo.where({$_.Name -eq $RecoveryItem.BackupFileName.Name})

										$FormatStringArray = @(
											$TestSchemaName,
											$TestTableName,
											[DateTimeOffset]::Now.ToSTring(),
											$BackupFile.BackupDate.ToString(),
											$InstanceFolder.Name,
											$DatabaseFolder,
											$RecoveryItem.BackupFileName.Name,
											$BackupFile.BackupType.SubString(0, 1).ToUpper(),
											$RecoveryItem.BackupPosition,
											$RecoveryItem.DatabaseGUID,
											$RecoveryItem.BackupDatabaseName,
											$RecoveryItem.FirstLSN,
											$RecoveryItem.LastLSN,
											$RecoveryItem.CheckpointLSN,
											$RecoveryItem.DatabaseBackupLSN
										)

										$SqlClientNonQueryParameters = @{
											'SqlConnection' = $SqlConnection
											'SqlCommandText' = [string]::Format($Insert_BackupFile, $FormatStringArray)
										}

										[void](Invoke-SqlClientNonQuery @SqlClientNonQueryParameters)
									}
									#EndRegion

									#Region Test Backup Files
									$RestoreStatus = $null

									Write-Verbose "Restoring to: $TestRecoveryDatabaseName"

									$ProgressParameters3 = @{
										'Id' = 3
										'ParentID' = 2
										'Activity' = 'Restoring Database'
										'Status' = [string]::Format('Restore {0} of {1}', 0, 1)
										'CurrentOperation' = ''
										'PercentComplete' = 0
									}

									foreach ($RecoveryItem in $DatabaseRecovery) {
										try {
											$ProgressParameters3.Status = [string]::Format('Restore {0} of {1}', $DatabaseRecovery.IndexOf($RecoveryItem) + 1, $DatabaseRecovery.Count)
											$ProgressParameters3.CurrentOperation = [string]::Format('Restoring: {0}', $RecoveryItem.BackupFileName.Name)
											$ProgressParameters3.PercentComplete = $DatabaseRecovery.IndexOf($RecoveryItem) / $DatabaseRecovery.Count * 100

											Write-Verbose $ProgressParameters3.CurrentOperation
											Write-Progress @ProgressParameters3

											$RestoreStatus = 'S'

											[void](Invoke-SqlClientNonQuery -SqlConnection $SqlConnection -SqlCommandText $RecoveryItem.RestoreDML -CommandTimeout 0)
										}
										catch {
											$ErrorRecord = $_

											switch ($ErrorRecord) {
												{$_.Exception.InnerException.Errors.Number -in @(3201, 3257)} {
													$RestoreStatus = 'E'
												}
												Default {
													$RestoreStatus = 'F'
												}
											}

											switch ($Script:OutputMethod) {
												'ConsoleHost' {
													$PSCmdlet.WriteError(
														[System.Management.Automation.ErrorRecord]::New(
															[Exception]::New('Failed to restore backup file.'),
															'1',
															[System.Management.Automation.ErrorCategory]::InvalidResult,
															$RecoveryItem.BackupFileName.Name
														)
													)
												}
												Default {
													$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

													$SummaryItem = [ordered]@{
														'SqlInstance' = $SqlServerName
														'BackupFileName' = $RecoveryItem.BackupFileName.Name
													}

													$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

													$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

													$MailMessageParameters.Add('Subject', 'SQL Backup Verification Failure')
													$MailMessageParameters.Add('Body', $EmailBody)

													Send-MailToolMessage @MailMessageParameters
												}
											}
										}

										if ($RestoreStatus -ne 'E') {
											$FormatStringArray = @(
												$TestSchemaName,
												$TestTableName,
												$DatabaseFolder,
												$RecoveryItem.BackupFileName.Name,
												$RecoveryItem.BackupPosition,
												$RestoreStatus,
												[DateTimeOffset]::Now.ToSTring()
											)

											$SqlClientNonQueryParameters = @{
												'SqlConnection' = $SqlConnection
												'SqlCommandText' = [string]::Format($Update_BackupFile, $FormatStringArray)
											}

											[void](Invoke-SqlClientNonQuery @SqlClientNonQueryParameters)
										}

										if ($RestoreStatus -ne 'S') {
											break
										}
									}
									#EndRegion
								}
								catch {
									$ErrorRecord = $_

									switch ($Script:OutputMethod) {
										'ConsoleHost' {
											$PSCmdlet.WriteError($ErrorRecord)
										}
										Default {
											$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

											$SummaryItem = [ordered]@{
												'SqlInstance' = $SqlServerName
											}

											if (Test-Path -Path Variable:\ErrorBackupFileName) {
												$SummaryItem.Add('BackupFileName', $ErrorBackupFileName)
											} else {
												$SummaryItem.Add('BackupFolderName', $DatabaseFolder.FullName)
											}

											$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

											$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

											$MailMessageParameters.Add('Subject', 'SQL Backup Verification Failure')
											$MailMessageParameters.Add('Body', $EmailBody)

											Send-MailToolMessage @MailMessageParameters
										}
									}
								}
								finally {
									Write-Progress -Id 3 -Activity 'Restoring Database' -Completed

									if (Test-Path -Path Variable:\ErrorBackupFileName) {
										Remove-Variable -Name ErrorBackupFileName
									}

									Write-Verbose "Removing Database $TestRecoveryDatabaseName."

									$SqlClientNonQueryParameters = @{
										'SqlConnection' = $SqlConnection
										'SqlCommandText' = [string]::Format($DropTestDatabaseDDL, $TestRecoveryDatabaseName)
									}

									[void](Invoke-SqlClientNonQuery @SqlClientNonQueryParameters)
								}
							}
						}
						catch {
							$ErrorRecord = $_

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									$PSCmdlet.WriteError($ErrorRecord)
								}
								Default {
									$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SqlServerName
									}

									$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

									$MailMessageParameters.Add('Subject', 'SQL Backup Verification Failure')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
						finally {
							Write-Progress -Id 2 -Activity 'Database Backup Folder' -Completed
						}
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SqlServerName
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Backup Verification Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
				finally {
					Write-Progress -Id 1 -Activity 'Instance Folder' -Completed
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SqlServerName
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Backup Verification Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			Write-Progress -Id 0 -Activity 'Backup Folder' -Completed

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Invoke-SqlInstanceBackup {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'Default-ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.Backup])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'CopyOnly-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TailLog-ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'CopyOnly-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TailLog-SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'CopyOnly-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'CopyOnly-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TailLog-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TailLog-SmoServerObject'
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[BackupType]$BackupType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'CopyOnly-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'CopyOnly-SmoServerObject'
		)]
		[switch]$CopyOnly,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TailLog-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'TailLog-SmoServerObject'
		)]
		[switch]$TailLog,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SmoServerObject'
		)]
		[ValidateRange(1, 100)]
		[int]$DiffBackupThreshold = 60
	)

	begin {
		$CopyOnly = $PSBoundParameters['CopyOnly']

		try {
			$ServerInstanceParameterSets = @('CopyOnly-ServerInstance', 'Default-ServerInstance', 'TailLog-ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()

			[System.IO.DirectoryInfo]$BackupPath = $SmoServer.Settings.BackupDirectory

			if ($SmoServer.HostPlatform -eq 'Windows') {
				if ([Environment]::MachineName -ne $SmoServer.NetName) {
					if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
						if (-not $([System.Uri]$BackupPath.FullName).IsUnc) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Local backup paths are not supported for remote SQL instances.'),
								'1',
								[System.Management.Automation.ErrorCategory]::NotImplemented,
								$BackupPath
							)
						}
					} else {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Backup of SQL Server on Windows from non-Windows host is not supported.'),
							'1',
							[System.Management.Automation.ErrorCategory]::NotImplemented,
							$BackupPath
						)
					}
				}
			} else {
				if ([Environment]::MachineName -ne $SmoServer.NetName) {
					if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Backup of SQL Server on Linux from Windows host is not supported.'),
							'1',
							[System.Management.Automation.ErrorCategory]::NotImplemented,
							$BackupPath
						)
					} else {
						if (-not $(Test-Path -LiteralPath $BackupPath -PathType Container)) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Backup path must be mounted on local file system.'),
								'1',
								[System.Management.Automation.ErrorCategory]::ObjectNotFound,
								$BackupPath
							)
						}
					}
				}
			}

			$RetainDays = $SmoServer.Configuration.MediaRetention.RunValue

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Backup.SchemaName
			$StatisticsTableName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Backup.TableName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Backup Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$Query_PreferredReplica = 'SELECT name FROM sys.databases WHERE sys.fn_hadr_backup_is_preferred_replica([name]) = 1;'
		$Query_Modified = 'SELECT ModifiedPercent = 100.0 * SUM(modified_extent_page_count) / SUM(allocated_extent_page_count) FROM sys.dm_db_file_space_usage;'
		$Query_LogShippingPrimary = 'SELECT Name = primary_database FROM msdb.dbo.log_shipping_monitor_primary;'
		$Query_DatabaseRecoveryStatus = "SELECT s.database_id
			,	s.database_guid
			,	bs.backup_set_id
			,	s.last_log_backup_lsn
			FROM master.sys.database_recovery_status s
			OUTER APPLY (
				SELECT TOP(1) backup_set_id
				FROM msdb.dbo.backupset
				WHERE type = 'D'
					AND is_copy_only = 0
					AND server_name = @@SERVERNAME
					AND database_guid = s.database_guid
				ORDER BY backup_finish_date
			) bs;"
		$Query_BackupStatistics = "INSERT INTO [{0}].[{1}] (CollectionDate, DatabaseName, DatabaseGUID, MediaName, BackupType, Pages, Seconds, MBPerSecond)
			VALUES (SYSDATETIMEOFFSET(), N'{2}', CAST('{3}' AS UNIQUEIDENTIFIER), N'{4}', '{5}', {6}, {7}, {8});"
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.IsDatabaseSnapshot -eq $false -and $_.Name -ne 'tempdb'})

			if ($SmoServer.IsHadrEnabled) {
				$DataTable = ($SmoServer.Databases['master'].ExecuteWithResults($Query_PreferredReplica)).Tables[0]

				[string[]]$PreferredReplicas = $DataTable | Select-Object -ExpandProperty Name

				$Databases = $Databases.where({$_.Name -in $PreferredReplicas})
			}

			if ($BackupType -eq 'log') {
				$Databases = $Databases.where({$_.RecoveryModel -ne 'Simple'})

				if ($PSCmdlet.ParameterSetName -notIn @('TailLog-ServerInstance', 'TailLog-SmoServerObject')) {
					$DataTable = ($SmoServer.Databases['msdb'].ExecuteWithResults($Query_LogShippingPrimary)).Tables[0]

					if ($DataTable.Rows.Count -gt 0) {
						[string[]]$LogShippingPrimary = $DataTable | Select-Object -ExpandProperty Name

						$Databases = $Databases.where({$_.Name -NotIn $LogShippingPrimary})
					}
				}
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to perform $BackupType backup on database ""$Item"".  Database does not exist or database not eligible for $BackupType backup on SQL server instance $ServerInstance."
				}
			}

			[scriptblock]$RecoveryStatusScriptBlock = {
				param(
					$DatabaseObject,
					$Query_DatabaseRecoveryStatus
				)
				($DatabaseObject.ExecuteWithResults($Query_DatabaseRecoveryStatus)).Tables
			}

			$RecoveryStatusDataTable = Invoke-RetryScriptBlock -ScriptBlock $RecoveryStatusScriptBlock -Arguments @($SmoServer.Databases['master'], $Query_DatabaseRecoveryStatus)

			foreach ($Database in $Databases) {
				Write-Verbose "$($Database.Name)"

				try {
					if ($SmoServer.IsHadrEnabled -and [string]::IsNullOrEmpty($Database.AvailabilityGroupName)) {
						$BackupChildPath = Invoke-ReplaceInvalidCharacter -InputString $([string]::Format('{0}.{1}', $Database.Name, $SmoServer.NetName))
					} else {
						$BackupChildPath = Invoke-ReplaceInvalidCharacter -InputString $Database.name
					}

					$DatabaseBackupPath = Join-Path -Path $BackupPath -ChildPath $BackupChildPath

					if ($PSCmdlet.ShouldProcess($DatabaseBackupPath, 'Create folder')) {
						[void][System.IO.Directory]::CreateDirectory($DatabaseBackupPath)
					}

					$BackupTimestamp = $(Get-Date).ToUniversalTime().ToString('yyyyMMddHHmmss')

					$BackupParameters = @{
						'DatabaseObject' = $Database
						'MediaDescription' = "$($Database.Name) Backup"
						'BackupSetName' = [string]::Format('{0} {1}', $Database.Name, $BackupTimestamp)
						'Checksum' = $true
						'CompressionOption' = 'Default'
						'RetainDays' = $RetainDays
						'MaxTransferSize' = 128KB
						'Debug' = $false
						'Verbose' = $true
					}

					if ($Database.Name.Length -gt 113) {
						$BackupParameters.BackupSetName = [string]::Format('{0} {1}', $Database.Name.SubString(0, 113), $BackupTimestamp)
					}

					$DatabaseRecoveryStatus = $RecoveryStatusDataTable.Select("database_id = $($Database.ID) and database_guid = '$($Database.DatabaseGuid)'")

					switch ($BackupType) {
						'Full' {
							[BackupType]$EffectiveBackupType = 'Full'

							if ($CopyOnly) {
								$BackupParameters.Add('CopyOnly', $true)
							}
						}
						'Diff' {
							if ($DatabaseRecoveryStatus.Count -eq 0) {
								[BackupType]$EffectiveBackupType = 'Full'

								Write-Warning 'Full backup required before Diff backup can be performed.  A full backup will be performed.'
							} else {
								$ModifiedPercent = $($Database.ExecuteWithResults($Query_Modified)).Tables[0].ModifiedPercent

								if ($DatabaseRecoveryStatus.backup_set_id -is [DBNull] -or $ModifiedPercent -gt $DiffBackupThreshold -or $Database.LastBackupDate -eq '0001-01-01 00:00:00' -or $Database.Name -eq 'master') {
									[BackupType]$EffectiveBackupType = 'Full'
								} else {
									[BackupType]$EffectiveBackupType = 'Diff'
								}
							}
						}
						'Log' {
							if ($DatabaseRecoveryStatus.Count -eq 0) {
								Write-Warning 'Full backup required before log backup can be performed.  A full backup will be performed.'

								[BackupType]$EffectiveBackupType = 'Full'
							} elseif ($DatabaseRecoveryStatus.last_log_backup_lsn -is [DBNull] -or $DatabaseRecoveryStatus.backup_set_id -is [DBNull]) {
								if ($TailLog) {
									throw [System.Management.Automation.ErrorRecord]::New(
										[Exception]::New('Tail log backup cannot be performed without a full backup of database.'),
										'1',
										[System.Management.Automation.ErrorCategory]::InvalidOperation,
										$Database
									)
								} elseif ($Database.ReadOnly) {
									throw [System.Management.Automation.ErrorRecord]::New(
										[Exception]::New("Readonly Database in $($Database.RecoveryModel) recovery model.  Transaction log cannot be backed up within a readonly database.  Readonly databases should be in simple recovery model"),
										'1',
										[System.Management.Automation.ErrorCategory]::InvalidOperation,
										$Database
									)
								}

								if ($Database.LastBackupDate -ne '0001-01-01 00:00:00') {
									Write-Warning 'Backup chain has been broken.  A full backup will be performed.'
								}

								[BackupType]$EffectiveBackupType = 'Full'
							} else {
								[BackupType]$EffectiveBackupType = 'Log'
							}
						}
					}

					$BackupFileBaseName = Invoke-ReplaceInvalidCharacter -InputString $([string]::Format('{0}_{1}', $Database.Name, $BackupTimestamp))

					if ($(Join-Path -Path $DatabaseBackupPath -ChildPath "$BackupFileBaseName.xxx").Length -gt 259) {
						$AdjustedLength = 259 - ($DatabaseBackupPath.Length + 20)

						if ($AdjustedLength -lt 0) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('The length of the backup device name provided exceeds supported limit of 259 characters.'),
								'1',
								[System.Management.Automation.ErrorCategory]::LimitsExceeded,
								$DatabaseBackupPath
							)
						}

						$BackupFileBaseName = Invoke-ReplaceInvalidCharacter -InputString $([string]::Format('{0}_{1}', $Database.Name.SubString(0, $AdjustedLength), $BackupTimestamp))
					}

					switch ($EffectiveBackupType) {
						'Full' {
							$BackupParameters.Add('BackupAction', 'Database')
							$BackupParameters.Add('MediaName', "$($BackupFileBaseName).bak")
							$BackupParameters.Add('BackupSetDescription', "Full backup of $($Database.Name)")
							$BackupParameters.Add('BackupFile', $(Join-Path -Path $DatabaseBackupPath -ChildPath "$BackupFileBaseName.bak"))
						}
						'Diff' {
							$BackupParameters.Add('BackupAction', 'Database')
							$BackupParameters.Add('Incremental', $true)
							$BackupParameters.Add('MediaName', "$($BackupFileBaseName).dif")
							$BackupParameters.Add('BackupSetDescription', "Differential backup of $($Database.Name)")
							$BackupParameters.Add('BackupFile', $(Join-Path -Path $DatabaseBackupPath -ChildPath "$BackupFileBaseName.dif"))
						}
						'Log' {
							$BackupParameters.Add('BackupAction', 'Log')
							$BackupParameters.Add('MediaName', "$($BackupFileBaseName).trn")
							$BackupParameters.Add('BackupSetDescription', "Log backup of $($Database.Name)")
							$BackupParameters.Add('BackupFile', $(Join-Path -Path $DatabaseBackupPath -ChildPath "$BackupFileBaseName.trn"))
							$BackupParameters.Add('NoRecovery', $TailLog)
						}
					}

					switch ($SmoServer.VersionMajor) {
						{$PSItem -ge 11} {
							#2012
						}
						{$PSItem -ge 12} {
							#2014
						}
						{$PSItem -ge 13} {
							$Database.ExecuteNonQuery('EXEC sp_flush_log;')

							if ($Database.Name -ne 'master') {
								if ($Database.QueryStoreOptions.ActualState -ne 'Off' ) {
									$Database.ExecuteNonQuery('EXEC sp_query_store_flush_db;')
								}
							}
						}
						{$PSItem -ge 14} {
							#2017
						}
						{$PSItem -ge 15} {
							#2019
						}
						{$PSItem -ge 16} {
							#2022
						}
						Default {
							Write-Error 'Unrecognized SQL Server version.'
						}
					}

					if ($PSCmdlet.ShouldProcess($Database.Name, "$($BackupParameters.BackupAction) Backup of database")) {
						if ($TailLog) {
							$SmoServer.KillAllProcesses($Database.Name)
						}

						$VerboseRecord = $(Backup-SqlDatabase @BackupParameters) 4>&1

						$RegExPattern = '(?<Start>\sprocessed\s)(?<Pages>\d{1,})\spages\sin\s(?<Seconds>(\d{1,}(\.\d{1,})?))\sseconds\s\((?<MBPerSecond>(\d{1,}(\.\d{1,})?)).*'

						$RegEx = [regex]::New($RegExPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
						$RegExMatches = $RegEx.Matches($VerboseRecord.Message)

						$Backup = [SqlServerMaintenance.Backup]::New()

						$Backup.DatabaseName = $Database.Name
						$Backup.Pages = $RegExMatches.Groups.Where({$_.Name -eq 'Pages'}).Value
						$Backup.Seconds = $RegExMatches.Groups.Where({$_.Name -eq 'Seconds'}).Value
						$Backup.MBPerSecond = $RegExMatches.Groups.Where({$_.Name -eq 'MBPerSecond'}).Value

						$FormatStringArray = @(
							$StatisticsSchemaName,
							$StatisticsTableName,
							$Backup.DatabaseName.Replace("'", "''"),
							$Database.DatabaseGuid
							$BackupParameters.MediaName.Replace("'", "''"),
							$EffectiveBackupType
							$Backup.Pages,
							$Backup.Seconds,
							$Backup.MBPerSecond
						)

						$NonQueryString = [string]::Format($Query_BackupStatistics, $FormatStringArray)

						$SmoServer.Databases[$StatisticsDatabaseName].ExecuteNonQuery($NonQueryString)

						$Backup
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Backup Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}

					Start-Sleep -Seconds 5
				}
			}

			if (-not $PSBoundParameters.ContainsKey('DatabaseName')) {
				Remove-SqlBackupFile -BackupPath $BackupPath -RetainDays $RetainDays -Force
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Backup Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-SqlInstanceCheckDb {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Data.DataRow])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, 4096)]
		[int]$MaxDOP,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$PhysicalOnlyThreshold = 51200,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$NoIndex,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$EstimateOnly
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Integrity Check Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal'})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to perform database integrity check database ""$Item"".  Database does not exist or database not accessible on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				Write-Verbose "Checking database $($Database.Name)."

				try {
					if ($SmoServer.ConnectionContext.SqlConnectionObject.State -ne 'Open') {
						$SmoServer.ConnectionContext.SqlConnectionObject.Open()
					}

					$RowsFileGroups = $Database.FileGroups.where({$_.FileGroupType -eq 'RowsFileGroup'})

					$DataSpaceUsedMB = $($RowsFileGroups.Files | Measure-Object -Sum UsedSpace).Sum / 1024

					$CheckDBOptionsList = [System.Collections.Generic.List[string]]::New()

					if ($NoIndex) {
						$CheckDBArgument = '0, NOINDEX'
					} else {
						$CheckDBArgument = '0'
					}

					$CheckDBOptionsList.AddRange([string[]]@('TABLERESULTS', 'NO_INFOMSGS', 'ALL_ERRORMSGS'))

					if ($DataSpaceUsedMB -gt $PhysicalOnlyThreshold) {
						$CheckDBOptionsList.Add('PHYSICAL_ONLY')
					} else {
						if (-not $NoIndex) {
							$CheckDBOptionsList.Add('EXTENDED_LOGICAL_CHECKS')
						}

						$CheckDBOptionsList.Add('DATA_PURITY')
					}

					if ($PSBoundParameters.ContainsKey('MaxDOP')) {
						$CheckDBOptionsList.Add([string]::Format('MAXDOP = {0}', $MaxDOP))
					}

					if ($EstimateOnly) {
						$CheckDBOptionsList.Add('ESTIMATEONLY')
					}

					$CheckDBOptions = [String]::Join(', ', $CheckDBOptionsList)

					$QueryString = [string]::Format('DBCC CHECKDB({0}) WITH {1};', $CheckDBArgument, $CheckDBOptions)

					$SQLCommand = [Microsoft.Data.SqlClient.SqlCommand]::New()
					$SQLCommand.Connection = $SmoServer.ConnectionContext.SqlConnectionObject
					$SQLCommand.CommandTimeout = 0
					$SQLCommand.CommandText = $QueryString
					$SQLCommand.Connection.ChangeDatabase($Database.Name)

					if ($PSCmdlet.ShouldProcess($Database.Name, 'Perform CheckDB')) {
						$SqlDataReader = $SQLCommand.ExecuteReader()
					}

					$Dataset = [System.Data.DataSet]::New()

					try {
						$Dataset.Load($SqlDataReader, [System.Data.LoadOption]::PreserveChanges, 'CheckDb')
					}
					catch {
						$PSCmdlet.WriteError($_)
					}

					$SqlDataReader.Dispose()

					$SQLCommand.Dispose()

					if ($DataSet.Tables[0].Rows.Count -gt 0) {
						$PSCmdlet.WriteError(
							[System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Integrity Errors found in database.'),
								'1',
								[System.Management.Automation.ErrorCategory]::InvalidResult,
								$Database.Name
							)
						)

						switch ($Script:OutputMethod) {
							'ConsoleHost' {
								$DataSet.Tables[0].Rows
							}
							Default {
								$RecordXml = ConvertTo-RecordXML -InputObject $Dataset

								$SummaryItem = [ordered]@{
									'SqlInstance' = $SmoServer.Name
									'DatabaseName' = $Database.Name
								}

								$EmailBody = Build-MailBody -Xml $RecordXml -SummaryItem $SummaryItem

								$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

								$MailMessageParameters.Add('Subject', 'SQL Integrity Check Failure')
								$MailMessageParameters.Add('Body', $EmailBody)

								Send-MailToolMessage @MailMessageParameters
							}
						}
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Integrity Check Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
				finally {
					if (Test-Path -Path variable:\DataSet) {
						$DataSet.Dispose()
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Integrity Check Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-SqlInstanceColumnStoreMaintenance {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.Index])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$DeletedRowsPercent = 10,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$RowGroupQuality = 500000,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$PercentageRowGroupQuality = 20
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.ColumnStore.SchemaName
			$StatisticsTableName = $Script:PSMConfig.Config.AdminDatabase.Statistics.ColumnStore.TableName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Column Store Index Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$QueryString = 'WITH cs AS (
			SELECT rg.object_id
			,	rg.index_id
			,	rg.partition_number
			,	CountRGs = COUNT(*)
			,	TotalRows = SUM(rg.total_rows)
			,	TotalRowsSegmented = SUM(rg.total_rows) * 1.0 / 1048576
			,	AvgRowsPerRG = AVG(rg.total_rows)
			,	CountRGLessThanQualityMeasure = SUM(CASE WHEN rg.Total_Rows < ' + $RowGroupQuality + ' THEN 1 ELSE 0 END)
			,	PercentageRGLessThanQualityMeasure = CAST((SUM(CASE WHEN rg.Total_Rows < ' + $RowGroupQuality + " THEN 1.0 ELSE 0 END) / COUNT(*) * 100) AS decimal(5,2))
			,	DeletedRowsPercent = SUM(rg.deleted_rows * 1.0) / SUM(rg.total_rows * 1.0) * 100
			,	NumRowgroupsWithDeletedRows = SUM(CASE WHEN rg.deleted_rows > 0 THEN 1 ELSE 0 END)
			FROM sys.column_store_row_groups rg
			WHERE rg.state = 3
			GROUP BY rg.object_id
			,	rg.partition_number
			,	rg.index_id
		),
		csd AS (
			SELECT MaxDictionarySize = MAX(d.on_disk_size)
			,	MaxDictionaryEntryCount = MAX(d.entry_count)
			,	MaxPartitionNumber = MAX(p.partition_number)
			,	p.object_id
			,	p.partition_number
			FROM sys.column_store_dictionaries d
			INNER JOIN sys.partitions p ON d.hobt_id = p.hobt_id
			GROUP BY p.object_id
			,	p.partition_number
		)
		SELECT CollectionDate = SYSDATETIMEOFFSET()
		,	DatabaseName = DB_NAME()
		,	SchemaName = s.name
		,	ObjectID = cs.object_id
		,	ObjectName = o.name
		,	IndexID = cs.index_id
		,	IndexName = i.name
		,	IndexType = i.type_desc
		,	PartitionNumber = cs.partition_number
		,	cs.CountRGs
		,	cs.TotalRows
		,	cs.AvgRowsPerRG
		,	cs.CountRGLessThanQualityMeasure
		,	cs.PercentageRGLessThanQualityMeasure
		,	cs.DeletedRowsPercent
		,	cs.NumRowgroupsWithDeletedRows
		,	csd.MaxDictionarySize
		,	csd.MaxDictionaryEntryCount
		,	csd.MaxPartitionNumber
		,	MaxDOP = (
				SELECT CASE WHEN cs.TotalRowsSegmented < 1.0 THEN 1
					WHEN cs.TotalRowsSegmented < effective_max_dop THEN FLOOR(cs.TotalRowsSegmented)
					ELSE 0 END
				FROM sys.dm_resource_governor_workload_groups
				WHERE group_id IN (SELECT group_id FROM sys.dm_exec_requests WHERE session_id = @@spid)
			)
		FROM sys.objects o
		INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
		INNER JOIN sys.indexes i ON o.object_id = i.object_id
		INNER JOIN sys.partitions p ON o.object_id = p.object_id
			AND i.index_id = p.index_id
		INNER JOIN cs ON o.object_id = cs.object_id
			AND p.index_id = cs.index_id
			AND p.partition_number = cs.partition_number
		INNER JOIN csd ON cs.object_id = csd.object_id
			AND cs.partition_number = csd.partition_number
		WHERE i.type_desc IN ('CLUSTERED COLUMNSTORE', 'NONCLUSTERED COLUMNSTORE')
		ORDER BY ObjectName
		,	IndexName
		,	PartitionNumber
		OPTION (RECOMPILE);"

		$ResultsColumns = @{
			'CountRGsResult' = 'System.Int32'
			'AvgRowsPerRGResult' = 'System.Decimal'
			'CountRGLessThanQualityMeasureResult' = 'System.Int32'
			'PercentageRGLessThanQualityMeasureResult' = 'System.Decimal'
			'DeletedRowsPercentResult' = 'System.Decimal'
			'NumRowgroupsWithDeletedRowsResult' = 'System.Int32'
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.Name -ne 'tempdb'})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to perform column store maintenance on database ""$Item"".  Database does not exist or database not eligible for column store maintenance on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				Write-Verbose "Performing column store index maintenance on database $Database."

				try {
					$ColumnStoreStats = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $ColumnStoreStats.Tables[0]) {
						try {
							$IndexOutput = [SqlServerMaintenance.Index]::New()

							$IndexOutput.SqlInstanceName = $SmoServer.Name
							$IndexOutput.DatabaseName = $Database.Name
							$IndexOutput.SchemaName = $Row.SchemaName
							$IndexOutput.TableName = $Row.ObjectName
							$IndexOutput.IndexName = $Row.IndexName
							$IndexOutput.PartitionNumber = $Row.PartitionNumber

							if ($Row.DeletedRowsPercent -ge $DeletedRowsPercent -or (
									$Row.AvgRowsPerRG -lt $RowGroupQuality -and
									$Row.TotalRows -gt $RowGroupQuality -and
									$Row.PercentageRGLessThanQualityMeasure -ge $PercentageRowGroupQuality -and
									$Row.MaxDictionarySize -lt 16777216
								)
							) {
								Write-Verbose $([string]::Format('Rebuilding index {0} on {1}.{2}', $Row.IndexName, $Row.SchemaName, $Row.ObjectName))

								$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild

								if ($Row.MaxPartitionNumber -eq 1) {
									$SqlNonQuery = [string]::Format('ALTER INDEX [{0}] ON [{1}].[{2}] REBUILD WITH (MAXDOP = {3});', $Row.IndexName, $Row.SchemaName, $Row.ObjectName, $Row.MaxDOP)
								} else {
									$SqlNonQuery = [string]::Format('ALTER INDEX [{0}] ON [{1}].[{2}] REBUILD PARTITION = {3} WITH (MAXDOP = {4});', $Row.IndexName, $Row.SchemaName, $Row.ObjectName, $Row.PartitionNumber, $Row.MaxDOP)
								}

								if ($PSCmdlet.ShouldProcess($Database.Name, 'Execute column store index rebuild')) {
									$Database.ExecuteNonQuery($SqlNonQuery)
								}
							}

							$IndexOutput
						}
						catch {
							$ErrorRecord = $_

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									throw $ErrorRecord
								}
								Default {
									$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SmoServer.Name
										'DatabaseName' = $Database.Name
										'TableName' = [string]::Format('[{0}].[{1}]', $Row.SchemaName, $Row.ObjectName)
										'IndexName' = $Row.IndexName
									}

									$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

									$MailMessageParameters.Add('Subject', 'SQL Index Maintenance Failure')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}

					foreach ($Key in $ResultsColumns.Keys) {
						$DataColumn = [Data.DataColumn]::New()

						$DataColumn.ColumnName = $Key
						$DataColumn.DataType = [System.Type]::GetType($ResultsColumns[$Key])

						$ColumnStoreStats.Tables[0].Columns.Add($DataColumn)

						$DataColumn.Dispose()
					}

					$ColumnStoreStats.Tables[0].Columns.Remove('MaxDictionarySize')
					$ColumnStoreStats.Tables[0].Columns.Remove('MaxDictionaryEntryCount')
					$ColumnStoreStats.Tables[0].Columns.Remove('MaxPartitionNumber')
					$ColumnStoreStats.Tables[0].Columns.Remove('MaxDOP')

					$ColumnStoreStatsResult = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $ColumnStoreStatsResult.Tables[0]) {
						$ColumnStoreStatsRow = $ColumnStoreStats.Tables[0].where({$_.ObjectID -eq $Row.ObjectID -and $_.IndexID -eq $Row.IndexID -and $_.PartitionNumber -eq $Row.PartitionNumber})

						if ($ColumnStoreStatsRow.Count -gt 0) {
							$ColumnStoreStatsRow[0].CountRGsResult = $Row.CountRGs
							$ColumnStoreStatsRow[0].AvgRowsPerRGResult = $Row.AvgRowsPerRG
							$ColumnStoreStatsRow[0].CountRGLessThanQualityMeasureResult = $Row.CountRGLessThanQualityMeasure
							$ColumnStoreStatsRow[0].PercentageRGLessThanQualityMeasureResult = $Row.PercentageRGLessThanQualityMeasure
							$ColumnStoreStatsRow[0].DeletedRowsPercentResult = $Row.DeletedRowsPercent
							$ColumnStoreStatsRow[0].NumRowgroupsWithDeletedRowsResult = $Row.NumRowgroupsWithDeletedRows
						}
					}

					if ($PSCmdlet.ShouldProcess($Database.Name, 'Bulk Copy index results')) {
						$SmoServer.ConnectionContext.SqlConnectionObject.ChangeDatabase($StatisticsDatabaseName)

						$SqlClientBulkCopyParameters = @{
							'SqlConnection' = $SmoServer.ConnectionContext.SqlConnectionObject
							'TableName' = [string]::Format('[{0}].[{1}]', $StatisticsSchemaName, $StatisticsTableName)
							'DataTable' = $ColumnStoreStats.Tables[0]
						}

						Invoke-SqlClientBulkCopy @SqlClientBulkCopyParameters
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Column Store Index Maintenance Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Column Store Index Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-SqlInstanceCycleErrorLog {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$JobServer = $SmoServer.JobServer
			$DatabaseObject = $SmoServer.Databases['master']
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Column Store Index Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess('ErrorLog', 'Recycle')) {
				[void]$DatabaseObject.ExecuteNonQuery('EXECUTE sp_cycle_errorlog;')
			}

			[int]$i = 0

			while ($JobServer.Jobs.where({$_.CurrentRunStatus -eq 'Executing' -and $_.JobSteps.SubSystem -eq 'CmdExec'}).Count -gt 0) {
				if ($i -gt 600) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Unable to recycle SQL Server Agent log due to CmdExec job running.'),
						'1',
						[System.Management.Automation.ErrorCategory]::OperationTimeout,
						$JobServer
					)
				}

				Start-Sleep -Seconds 5

				$i += 5
			}

			if ($PSCmdlet.ShouldProcess('Agent ErrorLog', 'Recycle')) {
				[void]$DatabaseObject.ExecuteNonQuery('EXECUTE msdb.dbo.sp_cycle_agent_errorlog;')
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Error Log Recycle Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-SqlInstanceFullTextIndexMaintenance {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.FullTextIndex])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$IndexSizeThreshold = 1,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$FragmentationThreshold = 10,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$FragmentSizeThreshold = 50,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$FragmentCountThreshold = 30
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			if ($SmoServer.IsFullTextInstalled -eq $false) {
				Write-Warning 'Full-Text is not installed.'

				Break
			}

			$SmoServer.Databases.Refresh()

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.FullTextIndex.SchemaName
			$StatisticsTable = $Script:PSMConfig.Config.AdminDatabase.Statistics.FullTextIndex.TableName
		}
		catch {
			$ErrorRecord =  $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Full Text Index Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$QueryString = "WITH f AS (
			SELECT
				table_id
			,	COUNT(*) AS FragmentsCount
			,	CAST(SUM(data_size / (1024. * 1024.)) AS decimal(9,2)) AS IndexSizeMb
			,	CAST(MAX(data_size / (1024. * 1024.)) AS decimal(9,2)) AS LargestFragmentMb
			FROM sys.fulltext_index_fragments
			WHERE status = 4
				OR status = 6
			GROUP BY table_id
		)
		SELECT SYSDATETIMEOFFSET() AS CollectionDate
		,	DB_NAME() AS DatabaseName
		,	s.name AS SchemaName
		,	fi.object_id AS ObjectID
		,	t.name AS ObjectName
		,	c.fulltext_catalog_id AS CatalogId
		,	c.[name] AS CatalogName
		,	fi.unique_index_id AS UniqueIndexID
		,	f.IndexSizeMb
		,	f.FragmentsCount
		,	f.LargestFragmentMb
		,	f.IndexSizeMb - f.LargestFragmentMb AS IndexFragmentationSpaceMb
		,	CASE WHEN f.IndexSizeMb = 0 THEN 0.0
				ELSE 100.0 * (f.IndexSizeMb - f.LargestFragmentMb) / f.IndexSizeMb END AS IndexFragmentationPct
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		INNER JOIN sys.fulltext_indexes fi ON t.[object_id] = fi.[object_id]
		INNER JOIN sys.fulltext_catalogs c ON fi.fulltext_catalog_id = c.fulltext_catalog_id
		INNER JOIN f ON fi.object_id = f.table_id
		WHERE f.IndexSizeMb > $IndexSizeThreshold
		ORDER BY SchemaName
		,	ObjectName
		,	CatalogName;"

		$ResultsColumns = @{
			'IndexSizeMbResult' = 'System.Decimal'
			'FragmentsCountResult' = 'System.Int32'
			'LargestFragmentMbResult' = 'System.Decimal'
			'IndexFragmentationSpaceMbResult' = 'System.Decimal'
			'IndexFragmentationPctResult' = 'System.Decimal'
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.FullTextCatalogs.Count -gt 0 -and $_.name -NotIn @('master', 'tempdb', 'model')})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to perform index maintenance on database ""$Item"".  Database does not exist or database not eligible for index maintenance on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				Write-Verbose "Performing full text index maintenance on database $($Database.Name)."

				try {
					$FullTextIndexStats = $Database.ExecuteWithResults($QueryString)

					$RebuiltFullTextCatalogs = [System.Collections.Generic.HashSet[string]]::New()

					foreach ($Row in $FullTextIndexStats.Tables[0]) {
						try {
							$IndexOutput = [SqlServerMaintenance.FullTextIndex]::New()

							$IndexOutput.SqlInstanceName = $SmoServer.Name
							$IndexOutput.DatabaseName = $Database.Name
							$IndexOutput.SchemaName = $Row.SchemaName
							$IndexOutput.TableName = $Row.ObjectName
							$IndexOutput.CatalogName = $Row.CatalogName

							if (-not $RebuiltFullTextCatalogs.Contains($Row.CatalogName)) {
								if ($Row.IndexFragmentationPct -gt $FragmentationThreshold -or $Row.IndexFragmentationSpaceMb -gt $FragmentSizeThreshold -or $Row.FragmentsCount -gt $FragmentCountThreshold) {
									Write-Verbose $([string]::Format('Rebuilding full text catalog {0}.', $Row.CatalogName))

									$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild

									$SqlNonQuery = [string]::Format('ALTER FULLTEXT CATALOG [{0}] REBUILD', $Row.CatalogName)

									if ($PSCmdlet.ShouldProcess($Row.CatalogName, 'Rebuild full text catalog')) {
										$Database.ExecuteNonQuery($SqlNonQuery)
									}

									[void]$RebuiltFullTextCatalogs.Add($Row.CatalogName)
								}
							}

							$IndexOutput
						}
						catch {
							$ErrorRecord = $_

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									throw $ErrorRecord
								}
								Default {
									$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SmoServer.Name
										'DatabaseName' = $Database.Name
										'FullTextCatalog' = $Row.CatalogName
									}

									$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

									$MailMessageParameters.Add('Subject', 'SQL Full Text Index Maintenance Failure')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}

					foreach ($Key in $ResultsColumns.Keys) {
						$DataColumn = [Data.DataColumn]::New()

						$DataColumn.ColumnName = $Key
						$DataColumn.DataType = [System.Type]::GetType($ResultsColumns[$Key])

						$FullTextIndexStats.Tables[0].Columns.Add($DataColumn)

						$DataColumn.Dispose()
					}

					$FullTextIndexStatsResult = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $FullTextIndexStatsResult.Tables[0]) {
						$FullTextIndexStatsRow = $FullTextIndexStats.Tables[0].where({$_.ObjectID -eq $Row.ObjectID -and $_.CatalogName -eq $Row.CatalogName -and $_.UniqueIndexID -eq $Row.UniqueIndexID})

						if ($FullTextIndexStatsRow.Count -gt 0) {
							$FullTextIndexStatsRow[0].IndexSizeMbResult = $Row.IndexSizeMb
							$FullTextIndexStatsRow[0].FragmentsCountResult = $Row.FragmentsCount
							$FullTextIndexStatsRow[0].LargestFragmentMbResult = $Row.LargestFragmentMb
							$FullTextIndexStatsRow[0].IndexFragmentationSpaceMbResult = $Row.IndexFragmentationSpaceMb
							$FullTextIndexStatsRow[0].IndexFragmentationPctResult = $Row.IndexFragmentationPct
						}
					}

					if ($PSCmdlet.ShouldProcess($Database.Name, 'Bulk Copy index results')) {
						$SmoServer.ConnectionContext.SqlConnectionObject.ChangeDatabase($StatisticsDatabaseName)

						$SqlClientBulkCopyParameters = @{
							'SqlConnection' = $SmoServer.ConnectionContext.SqlConnectionObject
							'TableName' = [string]::Format('[{0}].[{1}]', $StatisticsSchemaName, $StatisticsTable)
							'DataTable' = $FullTextIndexStats.Tables[0]
						}

						Invoke-SqlClientBulkCopy @SqlClientBulkCopyParameters
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Full Text Index Maintenance Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Full Text Index Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-SqlInstanceIndexMaintenance {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.Index])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$RowCountThreshold = 8192,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[IndexEvalMethod]$IndexEvalMethod = 'PageSpaceUsed',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$PageSpaceUsedThreshold = 50,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$ReorganizeThreshold = 30,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 100)]
		[int]$RebuildThreshold = 50,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Online
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			if ($Online -and $SmoServer.EngineEdition -ne 'EnterpriseOrDeveloper') {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New("Online is not supported in $($SmoServer.EngineEdition) of SQL Server."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoServer
				)
			}

			$SmoServer.Databases.Refresh()

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Index.SchemaName
			$StatisticsTableName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Index.TableName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Index Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$QueryStringTemplate = "WITH t AS (
				SELECT IndexType
				,	StatsMode
				FROM (
					VALUES (N'CLUSTERED', N'{0}')
					,	(N'HEAP', N'DETAILED')
					,	(N'NONCLUSTERED', N'{0}')
					,	(N'SPATIAL', N'{0}')
					,	(N'XML', N'{0}')	) n(IndexType, StatsMode)
			)
			, c AS (
				SELECT CollectionDate = SYSDATETIMEOFFSET()
				,	DatabaseName = DB_NAME()
				,	DatabaseID = DB_ID()
				,	SchemaName = s.[name]
				,	ObjectID = o.object_id
				,	ObjectName = o.name
				,	IndexID = i.index_id
				,	IndexName = i.[name]
				,	IndexType = i.[type_desc]
				,	PartitionNumber = p.partition_number
				,	AllowPageLocks = i.[allow_page_locks]
				,	[FillFactor] = i.fill_factor
				,	t.StatsMode
				FROM sys.objects o
				INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
				INNER JOIN sys.indexes i ON o.object_id = i.object_id
				INNER JOIN sys.partitions p ON o.object_id = p.object_id
					AND i.index_id = p.index_id
				INNER JOIN sys.dm_db_partition_stats ps ON p.partition_id = ps.partition_id
				INNER JOIN t ON i.[type_desc] = t.IndexType
				WHERE o.is_ms_shipped = 0
					AND i.is_hypothetical = 0
					AND ps.in_row_data_page_count > {1}
			)
			SELECT CollectionDate
			,	DatabaseName
			,	SchemaName
			,	ObjectID
			,	ObjectName
			,	IndexID
			,	IndexName
			,	IndexType
			,	PartitionNumber
			,	AllowPageLocks
			,	[FillFactor]
			,	PageCount = ips.page_count
			,	AvgFragmentation = ips.[avg_fragmentation_in_percent]
			,	ForwardedRecordCount = ips.forwarded_record_count
			,	AvgPageSpaceUsed = ips.avg_page_space_used_in_percent
			FROM c
			CROSS APPLY sys.dm_db_index_physical_stats(c.DatabaseID, c.ObjectID, c.IndexID, c.PartitionNumber, c.StatsMode) ips
			WHERE ips.alloc_unit_type_desc = N'IN_ROW_DATA'
				AND ips.page_count > {1}
				AND ips.index_level = 0
			ORDER BY SchemaName
			,	ObjectName
			,	IndexID
			,	IndexName
			,	PartitionNumber;"

		switch ($IndexEvalMethod) {
			'Fragmentation' {
				$QueryString = [string]::Format($QueryStringTemplate, 'LIMITED', $RowCountThreshold)
			}
			'PageSpaceUsed' {
				$QueryString = [string]::Format($QueryStringTemplate, 'DETAILED', $RowCountThreshold)
			}
			Default {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Invalid index eval method.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$IndexEvalMethod
				)
			}
		}

		$ResultsColumns = @{
			'AvgFragmentationResult' = 'System.Decimal'
			'ForwardedRecordCountResult' = 'System.Int32'
			'FillFactorResult' = 'System.Int16'
			'PageCountResult' = 'System.Int64'
			'AvgPageSpaceUsedResult' = 'System.Decimal'
		}

		$RebuildIndexTemplate = 'ALTER INDEX [{0}] ON [{1}].[{2}] REBUILD WITH (ONLINE = ON);'
		$RebuildIndexPartitionTemplate = 'ALTER INDEX [{0}] ON [{1}].[{2}] REBUILD PARTITION = {3} WITH (ONLINE = ON);'
		$RebuildTableTemplate = 'ALTER TABLE [{0}].[{1}] REBUILD WITH (ONLINE = ON);'
		$RebuildTablePartitionTemplate = 'ALTER TABLE [{0}].[{1}] REBUILD PARTITION = {2} WITH (ONLINE = ON);'
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.Name -ne 'tempdb'})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to perform index maintenance on database ""$Item"".  Database does not exist or database not eligible for index maintenance on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				Write-Verbose "Performing index maintenance on database $($Database.Name)."

				try {
					$IndexPhysicalStats = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $IndexPhysicalStats.Tables[0]) {
						try {
							Write-Verbose $([string]::Format('Optimizing index {0} on {1}.{2}', $Row.IndexName, $Row.SchemaName, $Row.ObjectName))

							$IndexOutput = [SqlServerMaintenance.Index]::New()

							$IndexOutput.SqlInstanceName = $SmoServer.Name
							$IndexOutput.DatabaseName = $Database.Name
							$IndexOutput.SchemaName = $Row.SchemaName
							$IndexOutput.TableName = $Row.ObjectName
							$IndexOutput.IndexName = $Row.IndexName
							$IndexOutput.PartitionNumber = $Row.PartitionNumber

							$Table = $Database.Tables[$Row.ObjectName, $Row.SchemaName]

							switch ($Row.IndexType) {
								'Heap' {
									switch ($IndexEvalMethod) {
										'Fragmentation' {
											if ($Row.ForwardedRecordCount -gt 0 -or $Row.AvgFragmentation -gt $RebuildThreshold) {
												$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild
											}
										}
										'PageSpaceUsed' {
											if ($Row.ForwardedRecordCount -gt 0) {
												$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild
											} else {
												if ($Row.FillFactor -eq 0) {
													if ($Row.AvgPageSpaceUsed -lt $PageSpaceUsedThreshold) {
														$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild
													}
												} else {
													if ($Row.AvgPageSpaceUsed -lt $Row.FillFactor * ($PageSpaceUsedThreshold / 100)) {
														$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild
													}
												}
											}
										}
										Default {
											throw [System.Management.Automation.ErrorRecord]::New(
												[Exception]::New('Invalid index eval method.'),
												'1',
												[System.Management.Automation.ErrorCategory]::InvalidArgument,
												$IndexEvalMethod
											)
										}
									}

									if ($IndexOutput.Mode -eq 'Rebuild') {
										if ($Table.IsPartitioned) {
											if ($Online -and -not $Table.HasXmlIndex) {
												$SqlNonQuery = $([string]::Format($RebuildTablePartitionTemplate, $Row.SchemaName, $Row.ObjectName, $Row.PartitionNumber))

												$Database.ExecuteNonQuery($SqlNonQuery)
											} else {
												$Table.Rebuild($Row.PartitionNumber)
											}
										} else {
											if ($Online -and -not $Table.HasXmlIndex) {
												$SqlNonQuery = $([string]::Format($RebuildTableTemplate, $Row.SchemaName, $Row.ObjectName))

												$Database.ExecuteNonQuery($SqlNonQuery)
											} else {
												$Table.Rebuild()
											}
										}
									} else {
										Write-Verbose 'No index maintenance performed on heap.'
									}
								}
								Default {
									$Index = $Table.Indexes[$Row.IndexName]

									switch ($IndexEvalMethod) {
										'Fragmentation' {
											switch ($Row.AvgFragmentation) {
												{$_ -gt $RebuildThreshold} {
													$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild

													Break
												}
												{$_ -gt $ReorganizeThreshold} {
													if ($Index.DisallowPageLocks) {
														$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::None
													} else {
														if ($Index.IndexType -eq 'ClusteredIndex') {
															$IndexedColumns = $Table.Columns.where({$_.Name -In $Index.IndexedColumns.Name})

															if ($IndexedColumns.DataType.Name -contains 'uniqueidentifier') {
																if ($Table.Columns.DataType.MaximumLength -contains -1) {
																	$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Reorganize
																} else {
																	$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::None
																}
															} else {
																$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Reorganize
															}
														} else {
															$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Reorganize
														}
													}

													Break
												}
												Default {
													$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::None
												}
											}
										}
										'PageSpaceUsed' {
											if ($Row.FillFactor -eq 0) {
												if ($Row.AvgPageSpaceUsed -lt $PageSpaceUsedThreshold) {
													$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild
												}
											} else {
												if ($Row.AvgPageSpaceUsed -lt $Row.FillFactor * ($PageSpaceUsedThreshold / 100)) {
													$IndexOutput.Mode = [SqlServerMaintenance.IndexMode]::Rebuild
												}
											}
										}
										Default {
											throw [System.Management.Automation.ErrorRecord]::New(
												[Exception]::New('Invalid index eval method.'),
												'1',
												[System.Management.Automation.ErrorCategory]::InvalidArgument,
												$IndexEvalMethod
											)
										}
									}

									switch ($IndexOutput.Mode) {
										'Rebuild' {
											if ($PSCmdlet.ShouldProcess($Database.Name, 'Execute index rebuild')) {
												if ($Index.IsPartitioned) {
													if ($Online -and $Index.IsOnlineRebuildSupported) {
														$SqlNonQuery = [string]::Format($RebuildIndexPartitionTemplate, $Row.IndexName, $Row.SchemaName, $Row.ObjectName, $Row.PartitionNumber)

														$Database.ExecuteNonQuery($SqlNonQuery)
													} else {
														if ($SmoServer.Version -lt [version]'15.0.0') {
															# Added due to bug in SMO that causes error "Cannot read property XmlCompression. This property is not available on SQL Server 2017."
															$SqlNonQuery = [string]::Format('ALTER INDEX [{0}] ON [{1}].[{2}] REBUILD PARTITION = {3};', $Row.IndexName, $Row.SchemaName, $Row.ObjectName, $Row.PartitionNumber)

															$Database.ExecuteNonQuery($SqlNonQuery)
														} else {
															$Index.Rebuild($Row.PartitionNumber)
														}
													}
												} else {
													if ($Online -and $Index.IsOnlineRebuildSupported) {
														$SqlNonQuery = [string]::Format($RebuildIndexTemplate, $Row.IndexName, $Row.SchemaName, $Row.ObjectName)

														$Database.ExecuteNonQuery($SqlNonQuery)
													} else {
														$Index.Rebuild()
													}
												}
											}
										}
										'Reorganize' {
											if ($PSCmdlet.ShouldProcess($Database.Name, 'Execute index reorganize')) {
												if ($Index.IsPartitioned) {
													$Index.Reorganize($Row.PartitionNumber)
												} else {
													$Index.Reorganize()
												}
											}
										}
										Default {
											Write-Verbose 'No index maintenance performed.'
										}
									}
								}
							}

							$IndexOutput
						}
						catch {
							$ErrorRecord = $_

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									$PSCmdlet.WriteError($ErrorRecord)
								}
								Default {
									$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SmoServer.Name
										'DatabaseName' = $Database.Name
										'TableName' = [string]::Format('[{0}].[{1}]', $Row.SchemaName, $Row.ObjectName)
										'IndexName' = $Row.IndexName
									}

									$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

									$MailMessageParameters.Add('Subject', 'SQL Index Maintenance Failure')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}

					foreach ($Key in $ResultsColumns.Keys) {
						$DataColumn = [Data.DataColumn]::New()

						$DataColumn.ColumnName = $Key
						$DataColumn.DataType = [System.Type]::GetType($ResultsColumns[$Key])

						$IndexPhysicalStats.Tables[0].Columns.Add($DataColumn)

						$DataColumn.Dispose()
					}

					$IndexPhysicalStatsResult = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $IndexPhysicalStatsResult.Tables[0]) {
						$IndexPhysicalStatsRow = $IndexPhysicalStats.Tables[0].where({$_.ObjectID -eq $Row.ObjectID -and $_.IndexName -eq $Row.IndexName -and $_.PartitionNumber -eq $Row.PartitionNumber})

						if ($IndexPhysicalStatsRow.Count -gt 0) {
							$IndexPhysicalStatsRow[0].AvgFragmentationResult = $Row.AvgFragmentation
							$IndexPhysicalStatsRow[0].ForwardedRecordCountResult = $Row.ForwardedRecordCount
							$IndexPhysicalStatsRow[0].FillFactorResult = $Row.FillFactor
							$IndexPhysicalStatsRow[0].PageCountResult = $Row.PageCount
							$IndexPhysicalStatsRow[0].AvgPageSpaceUsedResult = $Row.AvgPageSpaceUsed
						}
					}

					if ($PSCmdlet.ShouldProcess($Database.Name, 'Bulk Copy index results')) {
						$SmoServer.ConnectionContext.SqlConnectionObject.ChangeDatabase($StatisticsDatabaseName)

						$SqlClientBulkCopyParameters = @{
							'SqlConnection' = $SmoServer.ConnectionContext.SqlConnectionObject
							'TableName' = [string]::Format('[{0}].[{1}]', $StatisticsSchemaName, $StatisticsTableName)
							'DataTable' = $IndexPhysicalStats.Tables[0]
						}

						Invoke-SqlClientBulkCopy @SqlClientBulkCopyParameters
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Index Maintenance Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Index Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Invoke-SqlInstanceStatisticsMaintenance {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'Default-ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'StaticThreshold-ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'StaticThreshold-SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.StatisticsScanType]$StatisticsScanType = 'Default',

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'StaticThreshold-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'StaticThreshold-SmoServerObject'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$RowCountThreshold = 0,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'StaticThreshold-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'StaticThreshold-SmoServerObject'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$ModificationCountThreshold = 0,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, 64)]
		[int]$MaxDop = 0
	)

	DynamicParam {
		$RuntimeDefinedParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::New()

		if ($null -eq $PSBoundParameters['StatisticsScanType']) {
			$StatisticsScanType = 'Default'
		} else {
			$StatisticsScanType = $PSBoundParameters['StatisticsScanType']
		}

		switch ($StatisticsScanType) {
			{$_ -in @('Percent', 'Rows')} {
				$ParameterName = 'StatisticsSample'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()

				#Region ParameterSet StatisticsSample-ServerInstance
				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'Default-ServerInstance'

				$AttributeCollection.Add($ParameterAttribute)
				#EndRegion

				#Region ParameterSet StatisticsSample-SmoServerObject
				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'Default-SmoServerObject'

				$AttributeCollection.Add($ParameterAttribute)
				#EndRegion

				#Region Validate Range
				if ($StatisticsScanType -eq 'Percent') {
					$ValidateRangeAttribute = [System.Management.Automation.ValidateRangeAttribute]::New(1, 100)
				} else {
					$ValidateRangeAttribute = [System.Management.Automation.ValidateRangeAttribute]::New(1, [int64]::MaxValue)
				}

				$AttributeCollection.Add($ValidateRangeAttribute)
				#EndRegion

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [int64], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
			}

			{$_ -in @('FullScan', 'Percent', 'Rows')} {
				$ParameterName = 'Persist'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()

				#Region ParameterSet StatisticsSample-ServerInstance
				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Default-ServerInstance'

				$AttributeCollection.Add($ParameterAttribute)
				#EndRegion

				#Region ParameterSet StatisticsSample-SmoServerObject
				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Default-SmoServerObject'

				$AttributeCollection.Add($ParameterAttribute)
				#EndRegion

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [switch], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
			}

			{$_ -in @('Default', 'Resample')} {
				# No Dynamic Parameters
			}

			Default {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Unknown setting.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$StatisticsScanType
				)
			}
		}

		$RuntimeDefinedParameterDictionary
	}

	begin {
		try {
			$ServerInstanceArray = @('Default-ServerInstance', 'StaticThreshold-ServerInstance', 'StatisticsSample-ServerInstance')
			$DynamicSetArray = @('Default-ServerInstance', 'Default-SmoServerObject', 'StatisticsSample-ServerInstance', 'StatisticsSample-SmoServerObject')
			$StaticSetArray = @('StaticThreshold-ServerInstance', 'StaticThreshold-SmoServerObject', 'SampleStaticThreshold-SmoServerObject')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceArray) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()

			if ($PSBoundParameters.ContainsKey('StatisticsSample')) {
				$StatisticsSample = $PSBoundParameters['StatisticsSample']
			}

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.TableStatistics.SchemaName
			$StatisticsTableName = $Script:PSMConfig.Config.AdminDatabase.Statistics.TableStatistics.TableName

			if ($PSCmdlet.ParameterSetName -in $DynamicSetArray) {
				$RowCountThreshold = 1024
				$ModificationCountThreshold = 0
			}
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceArray) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceArray) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Statistics Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$QueryString = "SELECT
				CollectionDate = SYSDATETIMEOFFSET()
			,	DatabaseName = DB_NAME()
			,	SchemaName = ss.[name]
			,	ObjectName = o.[name]
			,	StatisticsName = st.[name]
			,	[RowCount] = sp.[rows]
			,	RowsSampled = sp.rows_sampled
			,	LastUpdated = sp.last_updated
			,	ModificationCount = sp.modification_counter
			,	DynamicThreshold = ROUND(SQRT(sp.[rows] * $RowCountThreshold), 0)
			,	DynamicThresholdPercent = ROUND(SQRT(sp.[rows] * $RowCountThreshold) / sp.[rows] * 100, 0)
			FROM sys.objects o
			INNER JOIN sys.schemas ss ON o.schema_id = ss.schema_id
			INNER JOIN sys.stats st ON st.object_id = o.object_id
			CROSS APPLY sys.dm_db_stats_properties(st.object_id, st.stats_id) sp
			ORDER BY ss.[name]
			,	o.[name]
			,	st.[name];"

		$ResultsColumns = @{
			'RowCountResult' = 'System.Int64'
			'RowsSampledResult' = 'System.Int64'
			'LastUpdatedResult' = 'System.DateTime'
			'ModificationCountResult' = 'System.Int64'
		}

		$StatisticsOptionsList = [System.Collections.Generic.List[string]]::New()

		switch ($StatisticsScanType) {
			'Default' {
				#Nothing
			}
			'FullScan' {
				$StatisticsOptionsList.Add('FULLSCAN')
			}
			'Percent' {
				$StatisticsOptionsList.Add("SAMPLE $StatisticsSample PERCENT")
			}
			'Rows' {
				$StatisticsOptionsList.Add("SAMPLE $StatisticsSample ROWS")
			}
			'Resample' {
				$StatisticsOptionsList.Add('RESAMPLE')
			}
			Default {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Invalid statistics scan type.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$StatisticsScanType
				)
			}
		}

		if ($PSBoundParameters.ContainsKey('MaxDop')) {
			$StatisticsOptionsList.Add("MAXDOP=$MaxDop")
		}

		if ($PSBoundParameters.ContainsKey('Persist')) {
			if ($Persist) {
				$StatisticsOptionsList.Add('PERSIST_SAMPLE_PERCENT=ON')
			} else {
				$StatisticsOptionsList.Add('PERSIST_SAMPLE_PERCENT=OFF')
			}
		}

		$StatisticsOptions = [String]::Join(', ', $StatisticsOptionsList)
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.Name -ne 'tempdb'})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to perform statistics maintenance on database ""$Item"".  Database does not exist or database not eligible statistics maintenance on SQL server instance $ServerInstance."
				}
			}

			foreach ($Database in $Databases) {
				Write-Verbose "Updating statistics on database $Database."

				try {
					$StatisticsProperties = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $StatisticsProperties.Tables[0]) {
						if ([string]::IsNullOrEmpty($StatisticsOptions)) {
							$SqlNonQuery = [string]::Format('UPDATE STATISTICS [{0}].[{1}] [{2}];', $Row.SchemaName, $Row.ObjectName, $Row.StatisticsName)
						} else {
							$SqlNonQuery = [string]::Format('UPDATE STATISTICS [{0}].[{1}] [{2}] WITH {3};', $Row.SchemaName, $Row.ObjectName, $Row.StatisticsName, $StatisticsOptions)
						}

						try {
							if ($Row.ModificationCount -IsNot [DBNull]) {
								if ($PSCmdlet.ParameterSetName -in $StaticSetArray) {
									if ($Row.RowCount -ge $RowCountThreshold -and $Row.ModificationCount -ge $ModificationCountThreshold) {
										if ($PSCmdlet.ShouldProcess($Row.ObjectName, "Execute update statistic $($Row.StatisticsName)")) {
											$Database.ExecuteNonQuery($SqlNonQuery)
										}
									}
								} else {
									if ($Row.ModificationCount -ge $Row.DynamicThreshold) {
										if ($PSCmdlet.ShouldProcess($Row.ObjectName, "Execute update statistic $($Row.StatisticsName)")) {
											$Database.ExecuteNonQuery($SqlNonQuery)
										}
									}
								}
							}
						}
						catch {
							$ErrorRecord = $_

							switch ($Script:OutputMethod) {
								'ConsoleHost' {
									$PSCmdlet.WriteError($ErrorRecord)
								}
								Default {
									$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

									$SummaryItem = [ordered]@{
										'SqlInstance' = $SmoServer.Name
										'DatabaseName' = $Database.Name
										'TableName' = [string]::Format('[{0}].[{1}]', $Row.SchemaName, $Row.ObjectName)
									}

									$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

									$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

									$MailMessageParameters.Add('Subject', 'SQL Statistics Maintenance Failure')
									$MailMessageParameters.Add('Body', $EmailBody)

									Send-MailToolMessage @MailMessageParameters
								}
							}
						}
					}

					foreach ($Key in $ResultsColumns.Keys) {
						$DataColumn = [Data.DataColumn]::New()

						$DataColumn.ColumnName = $Key
						$DataColumn.DataType = [System.Type]::GetType($ResultsColumns[$Key])

						$StatisticsProperties.Tables[0].Columns.Add($DataColumn)

						$DataColumn.Dispose()
					}

					$StatisticsProperties.Tables[0].Columns.Remove('DynamicThreshold')
					$StatisticsProperties.Tables[0].Columns.Remove('DynamicThresholdPercent')

					$StatisticsPropertiesResult = $Database.ExecuteWithResults($QueryString)

					foreach ($Row in $StatisticsPropertiesResult.Tables[0]) {
						$StatisticsPropertiesRow = $StatisticsProperties.Tables[0].where({$_.SchemaName -eq $Row.SchemaName -and $_.ObjectName -eq $Row.ObjectName -and $_.StatisticsName -eq $Row.StatisticsName})

						if ($StatisticsPropertiesRow.Count -gt 0) {
							$StatisticsPropertiesRow[0].RowCountResult = $Row.RowCount
							$StatisticsPropertiesRow[0].RowsSampledResult = $Row.RowsSampled
							$StatisticsPropertiesRow[0].LastUpdatedResult = $Row.LastUpdated
							$StatisticsPropertiesRow[0].ModificationCountResult = $Row.ModificationCount
						}
					}

					if ($PSCmdlet.ShouldProcess($Database.Name, 'Bulk Copy table statistics results')) {
						$SmoServer.ConnectionContext.SqlConnectionObject.ChangeDatabase($StatisticsDatabaseName)

						$SqlClientBulkCopyParameters = @{
							'SqlConnection' = $SmoServer.ConnectionContext.SqlConnectionObject
							'TableName' = [string]::Format('[{0}].[{1}]', $StatisticsSchemaName, $StatisticsTableName)
							'DataTable' = $StatisticsProperties.Tables[0]
						}

						Invoke-SqlClientBulkCopy @SqlClientBulkCopyParameters
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SmoServer.Name
								'DatabaseName' = $Database.Name
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Statistics Maintenance Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Statistics Maintenance Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceArray) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Join-Path2 {
	<#
	.SYNOPSIS
	Combines a path and a child path into a single path.
	.DESCRIPTION
	Combines a path and a child path into a single path.
	.PARAMETER Path
	Specifies the main path to which the child-path is appended.
	.PARAMETER ChildPath
	Specifies the elements to append to the value of the 'Path' parameter.
	.PARAMETER AdditionalChildPath
	Specifies additional elements to append to the value of the Path parameter.
	.PARAMETER Resolve
	Indicates that this function should attempt to resolve the joined path.
	.EXAMPLE
	Join-Path2 -Path 'C:\path\' -ChildPath '\ChildPath'
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $true,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([string])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$ChildPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$AdditionalChildPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Resolve
	)

	begin {
	}

	process {
		try {
			$PathList = [Collections.Generic.List[string]]$Path

			$PathList.Add($ChildPath)

			if ($PSBoundParameters.ContainsKey('AdditionalChildPath')) {
				foreach ($item in $AdditionalChildPath) {
					$PathList.Add($item)
				}
			}

			[string]$OutputPath = [IO.Path]::Combine($PathList)

			if ($Resolve) {
				if (-not (Test-path -LiteralPath $OutputPath)) {
					throw [System.Management.Automation.ErrorRecord]::new(
						[System.IO.FileNotFoundException]::New('File not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$OutputPath
					)
				}
			}

			$OutputPath
		}
		catch {
			throw $_
		}
	}

	end{
	}
}

function Move-SqlBackupFile {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo]$SourcePath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo]$DestinationPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, 1440)]
		[int]$FileAge = 15
	)

	begin {
		$FileProperties = @(
			'FullName',
			@{N='DestinationPath';E={ Join-Path -Path $DestinationPath.FullName -ChildPath $($_.FullName).Replace($SourcePath.FullName, '') }}
		)
	}

	process {
		try {
			[System.DateTimeOffset]$RetentionDate = $(Get-Date).ToUniversalTime().AddMinutes(-$FileAge)

			[SqlServerMaintenance.BackupFileInfo[]]$SqlBackupFiles = Get-SqlBackupFile -Path $SourcePath

			$Items = $SqlBackupFiles.where({$_.BackupDate -lt $RetentionDate}) | Select-Object $FileProperties

			foreach ($Item in $Items) {
				Write-Verbose $Item.FullName

				if ($PSCmdlet.ShouldProcess($Item.FullName, 'Moving file')) {
					$ParentDirectory = Split-Path -Path $Item.DestinationPath

					[void][System.IO.Directory]::CreateDirectory($ParentDirectory)

					[System.IO.File]::Move($Item.FullName, $Item.DestinationPath, $true)
				}
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Move-SqlDatabaseTable {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_Index'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_Table'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject_Index'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject_Table'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_Index'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject_Index'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_Table'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject_Table'
		)]
		[ValidateLength(1,128)]
		[string]$SchemaName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_Index'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject_Index'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_Table'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject_Table'
		)]
		[ValidateLength(1,128)]
		[string]$TableName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_Index'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject_Index'
		)]
		[ValidateLength(1,128)]
		[string]$IndexName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance', 'ServerInstance_Index')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$DatabaseObject = Get-SmoDatabaseObject -SmoServerObject $SmoServer -DatabaseName $DatabaseName

			if ($DatabaseObject.FileGroups.Name -NotContains $FileGroupName) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File group not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}

		$TempIndexName = 'Temp'
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('SchemaName')) {
				if ($PSBoundParameters.ContainsKey('TableName')) {
					$Tables = $DatabaseObject.Tables.Where({$_.Schema -eq $SchemaName -and $_.Name -in $TableName})
				} else {
					$Tables = $DatabaseObject.Tables.Where({$_.Schema -eq $SchemaName})
				}
			} else {
				[Microsoft.SqlServer.Management.Smo.Table[]]$Tables = $DatabaseObject.Tables
			}

			$ProgressParameters = @{
				'Id' = 0
				'Activity' = 'Moving tables'
				'CurrentOperation' = ''
				'Status' = [string]::Format('Table {0} of {1}', 0, $Tables.Count)
				'PercentComplete' = 0
			}

			foreach ($Table in $Tables) {
				$ProgressParameters.Status = [string]::Format('Table {0} of {1}', $Tables.IndexOf($Table) + 1, $Tables.Count)
				$ProgressParameters.CurrentOperation = [string]::Format('Moving table: {0}', $Table)
				$ProgressParameters.PercentComplete = $Tables.IndexOf($Table) / $Tables.Count * 100

				Write-Verbose $ProgressParameters.CurrentOperation
				Write-Progress @ProgressParameters

				if ($Table.HasClusteredIndex -eq $false -and -not $PSBoundParameters.ContainsKey('IndexName')) {
					if ($Table.FileGroup -ne $FileGroupName) {
						$Columns = $Table.Columns.Where({$_.DataType.MaximumLength -ne -1})

						if ($Columns.Count -eq 0) {
							$PSCmdlet.WriteError(
								[System.Management.Automation.ErrorRecord]::New(
									[Exception]::New('Hashtable does not have indexable column.'),
									'1',
									[System.Management.Automation.ErrorCategory]::InvalidOperation,
									$Table.Name
								)
							)

							Continue
						}

						if ($PSCmdlet.ShouldProcess($Table.Name, 'Move heap table.')) {
							$SmoIndex = [Microsoft.SqlServer.Management.SMO.Index]::New($Table, $TempIndexName)
							$SmoIndex.IsClustered = $true

							$IndexedColumn = [Microsoft.SqlServer.Management.SMO.IndexedColumn]::New($SmoIndex, $Columns[0].Name, $true)

							$SmoIndex.IndexedColumns.Add($IndexedColumn)

							$SmoIndex.Create()
							$SmoIndex.DropAndMove($FileGroupName)
						}
					}
				}

				try {
					if ($PSBoundParameters.ContainsKey('IndexName')) {
						$Indexes = $Table.Indexes.Where({$_.name -in $IndexName -and $_.IndexType -in @('ClusteredIndex', 'NonClusteredIndex')})
					} else {
						$Indexes = $Table.Indexes.Where({$_.IndexType -in @('ClusteredIndex', 'NonClusteredIndex')})
					}

					$ProgressParameters1 = @{
						'Id' = 1
						'ParentID' = 0
						'Activity' = 'Moving Indexes'
						'Status' = [string]::Format('Step {0} of {1}', 0, $Indexes.Count)
						'CurrentOperation' = ''
						'PercentComplete' = 0
					}

					foreach ($Index in $Indexes) {
						try {
							$ProgressParameters1.Status = [string]::Format('Index {0} of {1}', $Indexes.IndexOf($Index) + 1, $Indexes.Count)
							$ProgressParameters1.CurrentOperation = [string]::Format('Moving Index: {0}', $Index.Name)
							$ProgressParameters1.PercentComplete = $Indexes.IndexOf($Index) / $Indexes.Count * 100

							Write-Verbose $ProgressParameters1.CurrentOperation
							Write-Progress @ProgressParameters1

							if ($Index.FileGroup -ne $FileGroupName) {
								if ($PSCmdlet.ShouldProcess($Index.Name, 'Move index.')) {
									$Index.FileGroup = $FileGroupName

									$Index.Recreate()
								}
							}
						}
						catch {
							$PSCmdlet.WriteError($_)
						}
					}
				}
				catch {
					$PSCmdlet.WriteError($_)
				}
				finally {
					Write-Progress -Id 1 -Activity 'Moving indexes' -Completed
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			Write-Progress -Id 0 -Activity 'Moving tables' -Completed

			$DatabaseObject.Refresh()
			$DatabaseObject.Tables.Refresh()

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Read-SqlAgentAlert {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Data.DataTable])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$Filter
	)

	begin {
		try {
			$SqlAgentAlertsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$SqlAgentAlertsSchemaName = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.SchemaName
			$SqlAgentAlertsTableName = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.TableName
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName $SqlAgentAlertsDatabaseName
			} else {
				$SqlConnection.ChangeDatabase($SqlAgentAlertsDatabaseName)
			}

			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'SqlCommand' = 'SELECT @@SERVERNAME AS SqlServerName;'
				'DataSetName' = 'SqlServerName'
				'DataTableName' = 'SqlServerName'
				'OutputAs' = 'DataRow'
			}

			$SqlServerNameDataRow = Get-SqlClientDataSet @SqlClientDataSetParameters

			$SqlServerName = $SqlServerNameDataRow.SqlServerName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SqlConnection) {
					Disconnect-SqlServerInstance -SqlConnection $SqlConnection
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Query Store Usage Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$Query_SqlAgentAlertEvent = 'SELECT SQLAgentAlertEventID
		,	EventDateTime
		,	ComputerName
		,	ServerName
		,	InstanceName
		,	SQLServerInstance
		,	ErrorNumber
		,	Severity
		,	ClientIPAddress
		,	MessageText
		,	SentDateTime
		FROM {0}.{1}
		WHERE SentDateTime IS NULL
		ORDER BY EventDateTime;'

		[string[]]$MessageColumns = @(
			'SqlAgentAlertEventID',
			'EventDateTime',
			'ServerName',
			'InstanceName',
			'SqlServerInstance',
			'ErrorNumber',
			'Severity',
			'ClientIPAddress',
			'MessageText'
		)
	}

	process {
		try {
			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'SqlCommand' = [string]::Format($Query_SqlAgentAlertEvent, $SqlAgentAlertsSchemaName, $SqlAgentAlertsTableName)
				'DataSetName' = 'SqlAgentAlerts'
				'DataTableName' = $SqlAgentAlertsTableName
				'OutputAs' = 'DataSet'
			}

			$SqlAgentAlertsDataSet = Get-SqlClientDataSet @SqlClientDataSetParameters

			[System.Data.DataColumn[]]$KeyColumns = @($SqlAgentAlertsDataSet.Tables[$SqlAgentAlertsTableName].Columns['SqlAgentAlertEventID'])

			$SqlAgentAlertsDataSet.Tables[$SqlAgentAlertsTableName].PrimaryKey = $KeyColumns

			if ($SqlAgentAlertsDataSet.Tables[$SqlAgentAlertsTableName].Rows.Count -gt 0) {
				$UniqueErrorNumbers = $SqlAgentAlertsDataSet.Tables[$SqlAgentAlertsTableName].ErrorNumber | Select-Object -Unique

				$RegexPattern = '\[CLIENT:\s(?<ClientIPAddress>((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})\]'
				$RegEx = [regex]::New($RegExPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)

				foreach ($DataRow in $SqlAgentAlertsDataSet.Tables[$SqlAgentAlertsTableName]) {
					$RegExMatches = $RegEx.Matches($DataRow.MessageText)

					if ($RegExMatches.Count -gt 0) {
						$RegExGroup = $RegExMatches.Groups.where({$_.Success -eq 'True' -and $_.Name -eq '0'})
						$ClientIPAddress = $RegExGroup.Groups.where({$_.Name -eq 'ClientIPAddress'}).Value

						if ($null -ne $ClientIPAddress) {
							$DataRow.ClientIPAddress = $ClientIPAddress
						}
					}
				}

				foreach ($ErrorNumber in $UniqueErrorNumbers) {
					$DataView = [System.Data.DataView]::New($SqlAgentAlertsDataSet.Tables[$SqlAgentAlertsTableName])

					if ($PSBoundParameters.ContainsKey('Filter')) {
						$DataView.RowFilter = [string]::Format('ErrorNumber = {0} AND ({1})', $ErrorNumber, $Filter)
					} else {
						$DataView.RowFilter = [string]::Format('ErrorNumber = {0}', $ErrorNumber)
					}

					$DataSet = [System.Data.DataSet]::New()
					$DataSet.DataSetName = 'SqlAgentAlerts'
					$DataSet.Tables.Add($DataView.ToTable($SqlAgentAlertsTableName, $false, $MessageColumns))

					$DataView.Dispose()

					if ($DataSet.Tables[$SqlAgentAlertsTableName].Rows.Count -eq 0) {
						continue
					}

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$DataSet.Tables
						}
						Default {
							if ($DataSet.Tables[$SqlAgentAlertsTableName].where({$_.ClientIPAddress -ne [DBNull]::Value}).Count -eq 0) {
								$DataSet.Tables[$SqlAgentAlertsTableName].Columns.Remove('ClientIPAddress')
							}

							$RecordXml = ConvertTo-RecordXML -InputObject $DataSet

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SqlServerName
							}

							$EmailBody = Build-MailBody -Xml $RecordXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'SQL Agent Alert Events')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}

					foreach ($DataRow in $DataSet.Tables[$SqlAgentAlertsTableName]) {
						$SqlAgentAlertsDataSet.Tables[$SqlAgentAlertsTableName].Rows.Find($DataRow.SqlAgentAlertEventID).SentDateTime = [System.DateTimeOffset]::Now
					}

					$DataSet.Dispose()
				}

				$SqlDataAdapter = [Microsoft.Data.SqlClient.SqlDataAdapter]::New($SqlAgentAlertsDataSet.ExtendedProperties['SqlCommand'], $SqlAgentAlertsDataSet.ExtendedProperties['SqlConnection'])

				$SqlCommandBuilder = [Microsoft.Data.SqlClient.SqlCommandBuilder]::New($SqlDataAdapter)

				$SqlDataAdapter.UpdateCommand = $SqlCommandBuilder.GetUpdateCommand()

				[void]$SqlDataAdapter.Update($SqlAgentAlertsDataSet, $SqlAgentAlertsTableName)
			} else {
				Write-Information 'No events found.'
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SqlServerName
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Agent Alert Error')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if (Test-Path -Path variable:\DataView) {
				$DataView.Dispose()
			}

			if (Test-Path -Path variable:\DataSet) {
				$DataSet.Dispose()
			}

			if (Test-Path -Path variable:\SqlDataAdapter) {
				$SqlDataAdapter.Dispose()
			}

			if (Test-Path -Path variable:\SqlCommandBuilder) {
				$SqlCommandBuilder.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Remove-BackupTestDatabase {
	<#
	.SYNOPSIS
	Remove backup test database.
	.DESCRIPTION
	Remove backup test database.
	.PARAMETER TestBackupSqlInstance
	Specifies the name of a SQL Server instance to perform backup tests.
	.PARAMETER DatabaseName
	Specifies the name of the database(s) to remove.
	.PARAMETER SmoServerObject
	SQL Server Management Object.
	.EXAMPLE
	Remove-BackupTestDatabase -TestBackupSqlInstance MySQLInstance
	.EXAMPLE
	Remove-BackupTestDatabase -TestBackupSqlInstance MySQLInstance -DatabaseName TestRecovery_6d7a29ab-5bf5-4d14-97bd-30ffaaa77854
	.EXAMPLE
	Remove-BackupTestDatabase -SmoServerObject $SmoServerObject
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$TestBackupSqlInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName
	)

	begin {
		try {
			$RegExString = '^TestRecovery_+([0-9A-Fa-f]{8}[-]?[0-9A-Fa-f]{4}[-]?[0-9A-Fa-f]{4}[-]?[0-9A-Fa-f]{4}[-]?[0-9A-Fa-f]{12})$'
			$ServerInstanceParameterSets = @('ServerInstance')
			$SmoServerParameterSets = @('SmoServer')

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($DatabaseName -notmatch $RegExString) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Database is not a test recovery database.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidArgument,
						$DatabaseName
					)
				}
			}

			if ($PSCmdlet.ParameterSetName -in $SmoServerParameterSets) {
				$CurrentDatabase = $SmoServerObject.ConnectionContext.CurrentDatabase
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $TestBackupSqlInstance
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SmoServerObject.ConnectionContext.SqlConnectionObject
				'SqlCommandText' = 'SELECT sqlserver_start_time AS StartTime FROM sys.dm_os_sys_info;'
				'OutputAs' = 'DataRow'
			}

			$Results = Get-SqlClientDataSet @SqlClientDataSetParameters

			[datetime]$StartTime = $Results.StartTime

			$Databases = $SmoServerObject.Databases.where({$_.Name -match $RegExString -and $_.Status -eq 'Restoring'})

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases -contains $DatabaseName) {
					$Databases = $Databases.where({$_.Name -eq $DatabaseName})
				} else {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Database not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$DatabaseName
					)
				}
			}

			foreach ($Database in $Databases) {
				try {
					Write-Verbose "Checking Database $($Database.Name)"

					if ($Database.CreateDate -lt $StartTime -or $Database.CreateDate -lt $(Get-Date).AddHours(-12)) {
						if ($PSCmdlet.ShouldProcess($Database.Name, 'Drop Database')) {
							$Database.Drop()
						}
					} else {
						Write-Verbose "Database $($Database.Name) will not removed."
					}
				}
				catch {
					throw $_
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $SmoServerParameterSets) {
				$SmoServerObject.ConnectionContext.SqlConnectionObject.ChangeDatabase($CurrentDatabase)
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Remove-DbStatistic {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'Default-ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedStatistic-ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedStatistic-SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedStatistic-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedStatistic-SqlConnection'
		)]
		[DbStatistic]$StatisticsName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedStatistic-ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedStatistic-SqlConnection'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$Retention
	)

	begin {
		try {
			$AdminDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSBoundParameters.ContainsKey('ServerInstance')) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName $AdminDatabaseName
			} else {
				$SqlConnection.ChangeDatabase($AdminDatabaseName)
			}

			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'SqlCommand' = 'SELECT @@SERVERNAME AS SqlServerName;'
				'DataSetName' = 'SqlServerName'
				'DataTableName' = 'SqlServerName'
				'OutputAs' = 'DataRow'
			}

			$SqlServerNameDataRow = Get-SqlClientDataSet @SqlClientDataSetParameters

			$SqlServerName = $SqlServerNameDataRow.SqlServerName
		}
		catch {
			$ErrorRecord = $_

			if ($PSBoundParameters.ContainsKey('ServerInstance')) {
				if (Test-Path -Path Variable:\SqlConnection) {
					Disconnect-SqlServerInstance -SqlConnection $SqlConnection
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove Database Statistics Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$DeleteByRetention = 'DELETE FROM [dbo].[{0}]
			WHERE [CollectionDate] < DATEADD(day, -{1}, SYSDATETIMEOFFSET());'

		$DeleteByNonExistentDatabase = 'DELETE s
			FROM [dbo].[{0}] s
			WHERE NOT EXISTS (
				SELECT 1
				FROM sys.databases
				WHERE name = s.DatabaseName
			);'
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('StatisticsName')) {
				$DbStatistics = $Script:PSMConfig.SelectNodes("//Config/AdminDatabase/Statistics/$StatisticsName")
			} else {
				$DbStatistics = $Script:PSMConfig.SelectNodes('//Config/AdminDatabase/Statistics/*')
			}

			foreach ($DbStatistic in $DbStatistics) {
				try {
					$SqlNonQuery = [string]::Format($DeleteByNonExistentDatabase, $DbStatistic.TableName)

					if ($PSCmdlet.ShouldProcess($DbStatistic.TableName, 'Remove records where database no longer exists')) {
						[void](Invoke-SqlClientNonQuery -SqlConnection $SqlConnection -SqlCommandText $SqlNonQuery -CommandTimeout 300)
					}

					if ($PSBoundParameters.ContainsKey('Retention')) {
						$SqlNonQuery = [string]::Format($DeleteByRetention, $DbStatistic.TableName, $Retention)
					} else {
						$SqlNonQuery = [string]::Format($DeleteByRetention, $DbStatistic.TableName, $DbStatistic.RetentionDays)
					}

					if ($PSCmdlet.ShouldProcess($DbStatistic.TableName, 'Remove records older than retention period')) {
						[void](Invoke-SqlClientNonQuery -SqlConnection $SqlConnection -SqlCommandText $SqlNonQuery -CommandTimeout 300)
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SqlServerName
								'DatabaseName' = $StatisticsDatabaseName
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'Remove Database Statistics Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SqlServerName
						'DatabaseName' = $StatisticsDatabaseName
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove Database Statistics Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Remove-DbTest {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'Default-ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedTest-ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SqlConnection'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedTest-SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedTest-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedTest-SqlConnection'
		)]
		[DbTest]$TestName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedTest-ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'NamedTest-SqlConnection'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$Retention
	)

	begin {
		try {
			$AdminDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSBoundParameters.ContainsKey('ServerInstance')) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName $AdminDatabaseName
			} else {
				$SqlConnection.ChangeDatabase($AdminDatabaseName)
			}

			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'SqlCommand' = 'SELECT @@SERVERNAME AS SqlServerName;'
				'DataSetName' = 'SqlServerName'
				'DataTableName' = 'SqlServerName'
				'OutputAs' = 'DataRow'
			}

			$SqlServerNameDataRow = Get-SqlClientDataSet @SqlClientDataSetParameters

			$SqlServerName = $SqlServerNameDataRow.SqlServerName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SqlConnection) {
					Disconnect-SqlServerInstance -SqlConnection $SqlConnection
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove Database Test Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$DeleteByRetention = 'DELETE FROM [dbo].[{0}]
			WHERE [CollectionDate] < DATEADD(day, -{1}, SYSDATETIMEOFFSET());'
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('TestName')) {
				$DbTests = $Script:PSMConfig.SelectNodes("//Config/AdminDatabase/Tests/$TestName")
			} else {
				$DbTests = $Script:PSMConfig.SelectNodes('//Config/AdminDatabase/Tests/*')
			}

			foreach ($DbTest in $DbTests) {
				try {
					if ($PSBoundParameters.ContainsKey('Retention')) {
						$SqlNonQuery = [string]::Format($DeleteByRetention, $DbTest.TableName, $Retention)
					} else {
						$SqlNonQuery = [string]::Format($DeleteByRetention, $DbTest.TableName, $DbTest.RetentionDays)
					}

					if ($PSCmdlet.ShouldProcess($DbTest.TableName, 'Remove records older than retention period')) {
						[void](Invoke-SqlClientNonQuery -SqlConnection $SqlConnection -SqlCommandText $SqlNonQuery -CommandTimeout 300)
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SqlServerName
								'DatabaseName' = $AdminDatabaseName
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'Remove Database Test Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SqlServerName
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove Database Test Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Remove-LogShippedDatabase {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'Default-ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ConfigurationOnly-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DropSecondaryDatabase-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SetSecondaryWriteable-ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$PrimaryServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ConfigurationOnly-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DropSecondaryDatabase-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SetSecondaryWriteable-ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$SecondaryServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ConfigurationOnly-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DropSecondaryDatabase-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SetSecondaryWriteable-SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$PrimarySmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ConfigurationOnly-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Default-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DropSecondaryDatabase-SmoServerObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SetSecondaryWriteable-SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SecondarySmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$AvailabilityGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ConfigurationOnly-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ConfigurationOnly-SmoServerObject'
		)]
		[Switch]$ConfigurationOnly,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DropSecondaryDatabase-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DropSecondaryDatabase-SmoServerObject'
		)]
		[switch]$DropSecondaryDatabase,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SetSecondaryWriteable-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SetSecondaryWriteable-SmoServerObject'
		)]
		[switch]$SetSecondaryWriteable
	)

	begin {
		$Query_LSStagingFolder = "SELECT StagingFolder = backup_destination_directory
		FROM msdb.dbo.log_shipping_secondary
		WHERE primary_server = N'{1}'
			AND primary_database = N'{0}';"

		$Query_LSSecondary = "EXEC sp_delete_log_shipping_secondary_database
			@secondary_database = N'{0}_LS';

			EXEC sp_delete_log_shipping_secondary_primary
				@primary_server = N'{1}'
			,	@primary_database = N'{0}';

			EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'{0}';"

		$Query_LSPrimary = "EXEC sp_delete_log_shipping_primary_secondary
				@primary_database = N'{0}'
			,	@secondary_server = N'{1}'
			,	@secondary_database = N'{0}_LS';

			EXEC sp_delete_log_shipping_primary_database
				@database = N'{0}';"

		if (-not $PSBoundParameters.ContainsKey('DropSecondaryDatabase')) {
			$DropSecondaryDatabase = $false
		}
	}

	process {
		try {
			$ServerInstanceParameterSets = @('ConfigurationOnly-ServerInstance', 'Default-ServerInstance', 'DropSecondaryDatabase-ServerInstance', 'SetSecondaryWriteable-ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $PrimaryServerInstance
					'DatabaseName' = 'master'
				}

				$PrimarySmoServer = Connect-SmoServer @SmoServerParameters

				$SmoServerParameters = @{
					'ServerInstance' = $SecondaryServerInstance
					'DatabaseName' = 'master'
				}

				$SecondarySmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$PrimarySmoServer = $PrimarySmoServerObject
				$SecondarySmoServer = $SecondarySmoServerObject
			}

			if ($PSBoundParameters.ContainsKey('AvailabilityGroupName')) {
				$FormatStringArray = @(
					$DatabaseName,
					$AvailabilityGroupName
				)
			} else {
				$FormatStringArray = @(
					$DatabaseName,
					$PrimaryServerInstance
				)
			}

			$SqlCommandText = [string]::Format($Query_LSStagingFolder, $FormatStringArray)

			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SecondarySmoServer.ConnectionContext.SqlConnectionObject
				'SqlCommandText' = $SqlCommandText
				'OutputAs' = 'DataTable'
			}

			$StagingFolderResults = Get-SqlClientDataSet @SqlClientDataSetParameters

			$SqlCommandText = [string]::Format($Query_LSSecondary, $FormatStringArray)

			if ($PSCmdlet.ShouldProcess($SecondaryServerInstance, 'Remove Log Shipping Secondary')) {
				$SecondarySmoServer.Databases['master'].ExecuteNonQuery($SqlCommandText)
			}

			if (-not $ConfigurationOnly) {
				if ($StagingFolderResults.Rows.Count -eq 0) {
					Write-Warning 'Unable to retrieve staging folder path.  Staging folder must be removed manually.'
				} else {
					if ($PSCmdlet.ShouldProcess($StagingFolderResults.StagingFolder, 'Remove Staging Folder')) {
						try {
							[System.IO.Directory]::Delete($StagingFolderResults.StagingFolder, $true)
						}
						catch {
							Write-Warning 'Unable to remove staging folder.  Staging folder must be removed manually.'
						}
					}
				}
			}

			if ($DropSecondaryDatabase) {
				if ("$($DatabaseName)_LS" -in $SecondarySmoServer.Databases.Name) {
					$DatabaseObject = Get-SmoDatabaseObject -ServerInstance $SecondaryServerInstance -DatabaseName "$($DatabaseName)_LS"

					if ($PSCmdlet.ShouldProcess("$($DatabaseName)_LS", 'Drop Secondary Database')) {
						$SecondarySmoServer.KillAllProcesses("$($DatabaseName)_LS")

						$DatabaseObject.Drop()
					}
				} else {
					$PSCmdlet.WriteError(
						[System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Database does not exist on secondary instance.'),
							'1',
							[System.Management.Automation.ErrorCategory]::ObjectNotFound,
							"$($DatabaseName)_LS"
						)
					)
				}
			} else {
				if (-not $ConfigurationOnly) {
					if ("$($DatabaseName)_LS" -in $SecondarySmoServer.Databases.Name) {
						$SqlCommandText = [string]::Format('RESTORE DATABASE [{0}_LS] WITH RECOVERY', $DatabaseName)

						if ($PSCmdlet.ShouldProcess("$($DatabaseName)_LS", 'Restore Secondary Database with Recovery')) {
							if ($SecondarySmoServer.Databases["$($DatabaseName)_LS"].Status -eq 'Normal, Standby') {
								if ($PSCmdlet.ShouldProcess("$($DatabaseName)_LS", 'Restore Secondary Database with recovery')) {
									$SecondarySmoServer.Databases['master'].ExecuteNonQuery($SqlCommandText)
								}
							}

							$DatabaseObject = Get-SmoDatabaseObject -ServerInstance $SecondaryServerInstance -DatabaseName "$($DatabaseName)_LS"

							if ($DatabaseObject.ReadOnly -eq $true) {
								$DatabaseObject.ReadOnly = $false
								$DatabaseObject.Alter()
							}

							if (-not $SetSecondaryWriteable) {
								$DatabaseObject.RecoveryModel = [Microsoft.SqlServer.Management.Smo.RecoveryModel]::Simple
								$DatabaseObject.Alter()

								$DatabaseObject.LogFiles.Shrink(16, [Microsoft.SqlServer.Management.Smo.ShrinkMethod]::Default)
								$DatabaseObject.Alter()

								$DatabaseObject.ReadOnly = $true
								$DatabaseObject.Alter()
							}

							$DatabaseObject.Refresh()
						}
					} else {
						$PSCmdlet.WriteError(
							[System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Database does not exist on secondary instance.'),
								'1',
								[System.Management.Automation.ErrorCategory]::ObjectNotFound,
								"$($DatabaseName)_LS"
							)
						)
					}
				}
			}

			$SqlCommandText = [string]::Format($Query_LSPrimary, $DatabaseName, $SecondaryServerInstance)

			if ($PSCmdlet.ShouldProcess($PrimaryServerInstance, 'Remove Log Shipping Primary')) {
				$PrimarySmoServer.Databases['master'].ExecuteNonQuery($SqlCommandText)
			}
		}
		catch {
			throw $_
		}
		finally {
			if (Test-Path -Path Variable:\StagingFolderResults) {
				$StagingFolderResults.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\PrimarySmoServer) {
					if ($PrimarySmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $PrimarySmoServer
					}
				}

				if (Test-Path -Path Variable:\SecondarySmoServer) {
					if ($SecondarySmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SecondarySmoServer
					}
				}
			}
		}
	}

	end {
	}
}

function Remove-SqlAgentAlertHistory {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$Retention
	)

	begin {
		try {
			$AdminDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$SqlAgentAlertsSchemaName = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.SchemaName
			$SqlAgentAlertsTableName = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.TableName

			$ServerInstanceParameterSets = @('ServerInstance')

			if (-not $PSBoundParameters.ContainsKey('Retention')) {
				$Retention = $Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.RetentionDays
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName $AdminDatabaseName
			} else {
				$SqlConnection.ChangeDatabase($AdminDatabaseName)
			}

			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'SqlCommand' = 'SELECT @@SERVERNAME AS SqlServerName;'
				'DataSetName' = 'SqlServerName'
				'DataTableName' = 'SqlServerName'
				'OutputAs' = 'DataRow'
			}

			$SqlServerNameDataRow = Get-SqlClientDataSet @SqlClientDataSetParameters

			$SqlServerName = $SqlServerNameDataRow.SqlServerName
		}
		catch {
			$ErrorRecord = $_

			if (Test-Path -Path Variable:\SqlConnection) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove SQL Agent Alert History Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$DeleteByRetention = 'DELETE
		FROM [{0}].[{1}]
		WHERE EventDateTime < DATEADD(day, -{2}, SYSDATETIMEOFFSET())
			AND SentDateTime < DATEADD(day, -{2}, SYSDATETIMEOFFSET());'
	}

	process {
		try {
			$SqlNonQuery = [string]::Format($DeleteByRetention, $SqlAgentAlertsSchemaName, $SqlAgentAlertsTableName, $Retention)

			if ($PSCmdlet.ShouldProcess($SqlAgentAlertsTableName, 'Remove records older than retention period')) {
				[void](Invoke-SqlClientNonQuery -SqlConnection $SqlConnection -SqlCommandText $SqlNonQuery -CommandTimeout 300)
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SqlServerName
						'DatabaseName' = $SqlAgentAlertsTableName
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove SQL Agent Alert History Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Remove-SqlBackupFile {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo]$BackupPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, 365)]
		[int]$RetainDays = 30,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Switch]$Force
	)

	begin {
		if ($PSBoundParameters.ContainsKey('Confirm')) {
			if ($Force -and -not $Confirm){
				$ConfirmPreference = 'None'
			}
		} elseif ($Force) {
			$ConfirmPreference = 'None'
		}

		[scriptblock]$RemoveFileScriptBlock = {
			param($Path)
			if ([System.IO.File]::Exists($Path)) {
				Write-Verbose "Removing $Path."

				[System.IO.File]::Delete($Path)
			}
		}
	}

	process {
		try {
			if ($RetainDays -gt 0) {
				[System.IO.DirectoryInfo[]]$Folders = [System.IO.Directory]::GetDirectories($BackupPath, '*', [System.IO.SearchOption]::TopDirectoryOnly)
				[System.DateTimeOffset]$RetentionDate = $(Get-Date).ToUniversalTime().AddDays(-$RetainDays)

				foreach ($Folder in $Folders) {
					Write-Verbose "Folder: $($Folder.Name)"

					try {
						$SqlBackupFileList = Get-SqlBackupFile -Path $Folder

						$SqlBackupFiles = [System.Collections.Generic.List[SqlServerMaintenance.BackupFileInfo]]::New()

						if ($null -ne $SqlBackupFileList) {
							$SqlBackupFiles.AddRange([SqlServerMaintenance.BackupFileInfo[]]$SqlBackupFileList)
						}

						if ($SqlBackupFiles.Count -gt 0) {
							$LastBackupDate = ($SqlBackupFiles | Measure-Object -Property BackupDate -Maximum).Maximum

							if ($LastBackupDate -lt $RetentionDate) {
								[SqlServerMaintenance.BackupFileInfo[]]$ExpiredItems = $SqlBackupFiles
							} else {
								$FullSqlBackupFiles = $SqlBackupFiles.where({$_.Extension -eq '.bak' -and $_.BackupDate -lt $RetentionDate})

								if ($FullSqlBackupFiles.Count -eq 0) {
									$ExpiredItems = @()
								} else {
									$FullBackupDate = ($FullSqlBackupFiles | Measure-Object -Property BackupDate -Maximum).Maximum

									$ExpiredItems = $SqlBackupFiles.where({$_.BackupDate -lt $FullBackupDate})
								}
							}

							if ($ExpiredItems.Count -gt 0) {
								foreach ($Item in $ExpiredItems.FullName) {
									if ($PSCmdlet.ShouldProcess($Item, 'Remove expired backup')) {
										Invoke-RetryScriptBlock -ScriptBlock $RemoveFileScriptBlock -Arguments @($Item)
									}
								}
							}
						}
					}
					catch {
						$ErrorRecord = $_

						switch ($Script:OutputMethod) {
							'ConsoleHost' {
								$PSCmdlet.WriteError($ErrorRecord)
							}
							Default {
								$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

								$SummaryItem = [ordered]@{
									'Folder' = $Folder.FullName
								}

								$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

								$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

								$MailMessageParameters.Add('Subject', 'SQL Backup Failure')
								$MailMessageParameters.Add('Body', $EmailBody)

								Send-MailToolMessage @MailMessageParameters
							}
						}

						Start-Sleep -Seconds 5
					}
				}
			}

			if ($PSCmdlet.ShouldProcess($BackupPath, 'Remove empty folders')) {
				foreach ($Directory in [System.IO.Directory]::GetDirectories($BackupPath)) {
					$FileCount = [System.IO.Directory]::GetFiles($Directory, '*', [System.IO.SearchOption]::TopDirectoryOnly).Count

					if ($FileCount -eq 0) {
						if ([System.IO.Directory]::Exists($Directory)) {
							[System.IO.Directory]::Delete($Directory, $true)
						}
					}
				}
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Remove-SqlDatabaseSnapshot {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseSnapshotName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $ErrorRecord
		}
	}

	process {
		try {
			foreach ($DatabaseSnapshot in $DatabaseSnapshotName) {
				$Database = $SmoServer.Databases.Where({$_.Name -eq $DatabaseSnapshot -and $_.IsDatabaseSnapshot -eq $true})

				if ($Database.Count -eq 0) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[System.ArgumentException]::New('Snapshot not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$DatabaseSnapshotName
					)
				}

				if ($PSCmdlet.ShouldProcess($Database.Name, 'Drop Database Snapshot')) {
					$Database.Drop()
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Remove-SqlInstanceFileHistory {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[LogFileHistory[]]$LogFileHistory,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$RetentionInDays = 45
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$ErrorLogPath = $SmoServer.ErrorLogPath

			if (-not $([System.Uri]$ErrorLogPath).IsUnc) {
				if ([Environment]::MachineName -ne $SmoServer.NetName) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Remote SQL instance not supported.'),
						'1',
						[System.Management.Automation.ErrorCategory]::NotImplemented,
						$ErrorLogPath
					)
				}
			}

			if (-not $PSBoundParameters.ContainsKey('LogFileHistory')) {
				[LogFileHistory[]]$LogFileHistory = [LogFileHistory].GetEnumNames()
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Instance File History Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}
		}

		[datetime]$DateTime = (Get-Date).AddDays(-$RetentionInDays)
	}

	process {
		try {
			$FileList = [System.Collections.Generic.List[string]]::New()

			switch ($LogFileHistory) {
				'AgentJobOutput' {
					$FileList.AddRange([System.IO.Directory]::GetFiles($ErrorLogPath, 'Job_*.log', [System.IO.SearchOption]::TopDirectoryOnly))
				}
				'Dump' {
					$FileList.AddRange([System.IO.Directory]::GetFiles($ErrorLogPath, '*.dmp', [System.IO.SearchOption]::TopDirectoryOnly))
				}
				'ExtendedEvent' {
					$FileList.AddRange([System.IO.Directory]::GetFiles($ErrorLogPath, '*.xel', [System.IO.SearchOption]::TopDirectoryOnly))
				}
				'Trace' {
					$FileList.AddRange([System.IO.Directory]::GetFiles($ErrorLogPath, '*.trc', [System.IO.SearchOption]::TopDirectoryOnly))
				}
				Default {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Unknown log history.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidType,
						$LogFileHistory
					)
				}
			}

			foreach ($File in $FileList) {
				if ([System.IO.File]::GetLastWriteTime($File) -lt $DateTime) {
					if ($PSCmdlet.ShouldProcess($File, 'Log File History')) {
						try {
							[System.IO.File]::Delete($File)
						}
						catch [System.IO.IOException] {
							$PSCmdlet.WriteError($_)
						}
						catch {
							throw $_
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Instance File History Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
	}

	end {
	}
}

function Remove-SqlInstanceHistory {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[LogHistory[]]$LogHistory,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$RetentionInDays = 45
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName 'msdb'
			} else {
				$SqlConnection.ChangeDatabase('msdb')
			}

			$DataRow = Get-SqlClientDataSet -SqlConnection $SqlConnection -SqlCommandText 'SELECT @@SERVERNAME AS ServerName' -OutputAs DataRow

			$SqlInstanceName = $DataRow.ServerName

			if (-not $PSBoundParameters.ContainsKey('LogHistory')) {
				[LogHistory[]]$LogHistory = [LogHistory].GetEnumNames()
			}
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove SQL Instance History Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		[datetime]$DateTime = (Get-Date).AddDays(-$RetentionInDays)
	}

	process {
		try {
			foreach ($LogItem in $LogHistory) {
				try {
					Write-Verbose "Removing $LogItem logs."

					switch ($LogItem) {
						'AgentJob' {
							$SqlCommandText = [string]::Format("EXECUTE msdb.dbo.sp_purge_jobhistory @Oldest_date = '{0}';", $DateTime)
						}
						'Backup' {
							$SqlCommandText = [string]::Format("EXECUTE msdb.dbo.sp_delete_backuphistory @oldest_date = '{0}';", $DateTime)
						}
						'DatabaseMail' {
							$FormatString = "EXECUTE msdb.dbo.sysmail_delete_mailitems_sp @sent_before = '{0}';
								EXECUTE msdb.dbo.sysmail_delete_log_sp @logged_before = '{0}';"

							$SqlCommandText = [string]::Format($FormatString, $DateTime)
						}
						'LogShipping' {
							$SqlCommandText = "SELECT DISTINCT
									agent_id AS AgentID
								,	t.agent_type AS AgentType
								,	CAST(t.agent_type_desc AS varchar(10)) AS agent_type_desc
								FROM msdb.dbo.log_shipping_monitor_history_detail h
								INNER JOIN (VALUES(0,'backup'),(1,'copy'),(2,'restore')) AS t(agent_type, agent_type_desc) ON h.agent_type = t.agent_type;"

							$DataRow = Get-SqlClientDataSet -SqlConnection $SqlConnection -SqlCommandText $SqlCommandText -OutputAs DataRow

							$StringBuilder = [System.Text.StringBuilder]::New()

							$FormatString = 'EXECUTE master.dbo.sp_cleanup_log_shipping_history
							@agent_id = ''{0}'',
							@agent_type = {1};{2};'

							foreach ($Row in $DataRow) {
								[void]$StringBuilder.Append([string]::Format($FormatString, $Row.AgentID, $Row.AgentType, "`r`n"))
							}

							$SqlCommandText = $StringBuilder.ToString()
						}
						'MaintenancePlan' {
							$SqlCommandText = [string]::Format("EXECUTE msdb.dbo.sp_maintplan_delete_log @plan_id = null, @subplan_id = null, @oldest_time = '{0}';", $DateTime)
						}
						'MultiServerAdministration' {
							$SqlCommandText = [string]::Format("DELETE FROM msdb.dbo.sysdownloadlist WHERE date_downloaded <= '{0}';", $DateTime)
						}
						'PolicyBasedManagement' {
							$FormatString = "EXECUTE msdb.dbo.sp_syspolicy_purge_history;
								EXECUTE msdb.dbo.sp_syspolicy_delete_policy_execution_history @policy_id = NULL, @oldest_date = '{0}';"

							$SqlCommandText = [string]::Format($FormatString, $DateTime)
						}
						Default {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('Unknown log history.'),
								'1',
								[System.Management.Automation.ErrorCategory]::InvalidType,
								$LogItem
							)
						}
					}

					if ($PSCmdlet.ShouldProcess($LogItem, 'Log History')) {
						if ($SqlCommandText -ne '') {
							$SqlConnection.ChangeDatabase('master')

							[void](Invoke-SqlClientNonQuery -SqlConnection $SqlConnection -SqlCommandText $SqlCommandText -CommandTimeout 300)
						}
					}
				}
				catch {
					$ErrorRecord = $_

					switch ($Script:OutputMethod) {
						'ConsoleHost' {
							$PSCmdlet.WriteError($ErrorRecord)
						}
						Default {
							$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

							$SummaryItem = [ordered]@{
								'SqlInstance' = $SqlInstanceName
								'SqlLogHistory' = $LogItem
							}

							$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

							$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

							$MailMessageParameters.Add('Subject', 'Remove SQL Instance History Failure')
							$MailMessageParameters.Add('Body', $EmailBody)

							Send-MailToolMessage @MailMessageParameters
						}
					}
				}
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SqlInstanceName
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'Remove SQL Instance History Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Resize-DatabaseLogicalFile {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'LogicalFile-ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileGroup-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'LogicalFile-ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileGroup-SmoServer'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'LogicalFile-SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileGroup-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileGroup-SmoServer'
		)]
		[ValidateLength(1,128)]
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'LogicalFile-ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'LogicalFile-SmoServer'
		)]
		[ValidateLength(1,128)]
		[string]$LogicalFileName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$LogicalFileSize,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.ShrinkMethod]$ShrinkMethod = 'Default'
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('FileGroup-ServerInstance', 'LogicalFile-ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
					'StatementTimeout' = 0
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoDatabaseObject = Get-SmoDatabaseObject -SmoServerObject $SmoServer -DatabaseName $DatabaseName

			if ($SmoDatabaseObject.Status -ne 'Normal') {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database is not online.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoDatabaseObject.Name
				)
			}

			if ($SmoDatabaseObject.ReadOnly -eq $true -or $SmoDatabaseObject.IsUpdateable -eq $false) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database is not writable.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoDatabaseObject.Name
				)
			}

			if ($SmoDatabaseObject.IsAccessible -eq $false) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database is not accessible.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoDatabaseObject.Name
				)
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoDatabaseObject) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('FileGroupName')) {
				if ($FileGroupName -NotIn $SmoDatabaseObject.FileGroups.Name) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('File group not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$FileGroupName
					)
				}

				$LogicalFiles = $SmoDatabaseObject.FileGroups[$FileGroupName].Files
			}

			if ($PSBoundParameters.ContainsKey('LogicalFileName')) {
				$LogicalFiles = $SmoDatabaseObject.FileGroups.Files.where({$_.Name -eq $LogicalFileName})

				if ($LogicalFiles.Count -eq 0) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Logical file not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$LogicalFileName
					)
				}
			}

			foreach ($LogicalFile in $LogicalFiles) {
				switch ($LogicalFile.Size / 1024) {
					{$_ -lt $LogicalFileSize} {
						$LogicalFile.Size = $LogicalFileSize * 1024
					}

					{$_ -gt $LogicalFileSize} {
						if ($LogicalFile.UsedSpace -gt $LogicalFileSize * 1024) {
							Write-Warning 'Logical file cannot be shrunk below used space.'
						}

						$LogicalFile.Shrink($LogicalFileSize, $ShrinkMethod)
					}

					Default {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('The new size must greater than or less than the current file size size.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidOperation,
							$LogicalFile.Name
						)
					}
				}
			}

			$LogicalFile.Alter()
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Resize-DatabaseTransactionLog {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$LogFileSize,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.ShrinkMethod]$ShrinkMethod = 'Default',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 1440)]
		[Int16]$TransactionLogBackupInterval = 15
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoDatabaseObject = Get-SmoDatabaseObject -SmoServerObject $SmoServer -DatabaseName $DatabaseName

			if ($SmoDatabaseObject.Status -ne 'Normal') {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database is not online.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoDatabaseObject.Name
				)
			}

			if ($SmoDatabaseObject.ReadOnly -eq $true -or $SmoDatabaseObject.IsUpdateable -eq $false) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database is not writable.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoDatabaseObject.Name
				)
			}

			if ($SmoDatabaseObject.IsAccessible -eq $false) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database is not accessible.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoDatabaseObject.Name
				)
			}

			if ($SmoDatabaseObject.LogFiles.Count -gt 1) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('More than 1 transaction log file exists.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$SmoDatabaseObject.Name
				)
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoDatabaseObject) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}

		$TotalRetries = 5
	}

	process {
		try {
			$LogFileObject = $SmoDatabaseObject.LogFiles[0]

			switch ($LogFileObject.Size / 1024) {
				{$_ -lt $LogFileSize} {
					$LogFileObject.Size = $LogFileSize * 1024

					$LogFileObject.Alter()
				}

				{$_ -gt $LogFileSize} {
					$DatabaseTransactionLogInfo = Get-DatabaseTransactionLogInfo -SqlConnection $SmoServer.ConnectionContext.SqlConnectionObject -DatabaseName $DatabaseName

					$VLFSizes = $DatabaseTransactionLogInfo | Select-Object VlfCreateLsn, @{N='RunningSizeMB';E={[Math]::Ceiling($_.RunningSizeMB)}}

					$VLFBoundary = $VLFSizes.where({$_.RunningSizeMB -ge $LogFileSize})[0]
					[int]$LogFileAdjustedSize = $VLFBoundary.RunningSizeMB

					if ($VLFBoundary.VlfCreateLsn -eq '00000000:00000000:0000') {
						$InitialVLFBoundary = $VLFSizes.where({$_.VlfCreateLsn -eq '00000000:00000000:0000'}) | Select-Object -Last 1
						[int]$InitialLogSize = $InitialVLFBoundary.RunningSizeMB

						if ($LogFileSize -lt $InitialLogSize) {
							Write-Warning "Log file size cannot be lower than initial log file size.  Target size being adjusted to $($InitialLogSize)MB."

							$LogFileAdjustedSize = $InitialLogSize
						}
					}

					if ($VLFBoundary.RunningSizeMB -gt $LogFileSize) {
						Write-Warning "Log file size being adjusted to VLF boundary.  Size will be $($LogFileAdjustedSize)MB."
					}

					if ($LogFileAdjustedSize -eq [Math]::Ceiling($LogFileObject.Size / 1024)) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Adjusted size is equal to current log file size.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidOperation,
							$LogFileObject.Name
						)
					}

					if ($SmoDatabaseObject.RecoveryModel -eq 'Simple') {
						$RetryDelay = 5
						$ProgressStatus = 'Pause'
					} else {
						$RetryDelay = $TransactionLogBackupInterval * 60
						$ProgressStatus = 'Waiting for next transaction log backup'
						$LastLogBackupDate = $SmoDatabaseObject.LastLogBackupDate
					}

					for ($i = 0; $i -lt $TotalRetries; $i++) {
						$SmoDatabaseObject.Checkpoint()

						$LogFileObject.Shrink($LogFileAdjustedSize - 1, $ShrinkMethod)
						$LogFileObject.Refresh()

						if ($LogFileAdjustedSize -eq [Math]::Ceiling($LogFileObject.Size / 1024)) {
							break
						}

						$EndDelay = (Get-Date).AddSeconds($RetryDelay)

						:RetryDelay Do {
							$ProgressParameters = @{
								'Id' = 0
								'Activity' = [string]::Format('Retry {0} of {1}', ($i + 1), $TotalRetries)
								'Status' = $ProgressStatus
								'PercentComplete' = 100 - ((New-TimeSpan -Start (Get-Date) -End $EndDelay).TotalSeconds / $RetryDelay * 100)
								'SecondsRemaining' = (New-TimeSpan -Start (Get-Date) -End $EndDelay).TotalSeconds
							}

							Write-Progress @ProgressParameters

							if ($SmoDatabaseObject.RecoveryModel -ne 'Simple') {
								$SmoDatabaseObject.Refresh()

								if ($SmoDatabaseObject.LastLogBackupDate -gt $LastLogBackupDate) {
									$LastLogBackupDate = $SmoDatabaseObject.LastLogBackupDate

									break RetryDelay
								}
							}
						} Until ((Get-Date) -ge $EndDelay)
					}

					Write-Progress -Id 0 -Completed

					if ($LogFileAdjustedSize -ne [Math]::Ceiling($LogFileObject.Size / 1024)) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Unable to resize transaction log to requested size.'),
							'2',
							[System.Management.Automation.ErrorCategory]::InvalidResult,
							$LogFileObject.Name
						)
					}
				}

				Default {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('The new size must greater than or less than the current log file size.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$LogFileObject.Name
					)
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Restore-SqlDatabaseSnapshot {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseSnapshotName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			throw $_
		}

		$DDLFormatString = "USE master;
		RESTORE DATABASE [{0}]
		FROM DATABASE_SNAPSHOT = '{1}';"
	}

	process {
		try {
			$Database = $SmoServer.Databases.where({$_.Name -eq $DatabaseSnapshotName -and $_.IsDatabaseSnapshot -eq $true})

			if ($Database.Count -eq 0) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New('Snapshot not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseSnapshotName
				)
			}

			if ($SmoServer.Databases.where({$_.DatabaseSnapshotBaseName -eq $Database.DatabaseSnapshotBaseName}).Count -gt 1) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New('Database contains multiple snapshots.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$Database.DatabaseSnapshotBaseName
				)
			}

			$RestoreSnapshotDDL = [string]::Format($DDLFormatString, $Database.DatabaseSnapshotBaseName, $DatabaseSnapshotName)

			if ($PSCmdlet.ShouldProcess($DatabaseSnapshotName, 'Restore Database Snapshot')) {
				[void]$(Invoke-SqlClientNonQuery -SqlConnection $SmoServer.ConnectionContext.SqlConnectionObject -SqlCommandText $RestoreSnapshotDDL -CommandTimeout 0)

				Get-SqlDatabaseSnapshot -SmoServerObject $SmoServer -DatabaseSnapshotName $DatabaseSnapshotName
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Save-SqlInstanceDatabaseStatistic {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Database.SchemaName
			$StatisticsTableName = $Script:PSMConfig.Config.AdminDatabase.Statistics.Database.TableName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Database Statistics Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$FilesProperties = @(
			@{N='CollectionDate';E={[System.DateTimeOffset]::Now}},
			@{N='DatabaseName';E={if ($_.Urn.Type -eq 'LogFile') {$_.Parent.Name} else {$_.Parent.Parent.Name}}},
			@{N='DatabaseGuid';E={if ($_.Urn.Type -eq 'LogFile') {$_.Parent.DatabaseGuid} else {$_.Parent.Parent.DatabaseGuid}}},
			@{N='LogicalFileName';E={$_.Name}},
			@{N='PhysicalFileName';E={$_.FileName}},
			@{N='IsPrimaryFile';E={if ($_.Urn.Type -eq 'LogFile') {$false} else {$_.IsPrimaryFile}}},
			@{N='IsLogFile';E={if ($_.Urn.Type -eq 'LogFile') {$true} else {$false}}},
			'IsOffline',
			@{N='IsReadOnly';E={if ($_.Urn.Type -eq 'LogFile') {$_.Parent.ReadOnly} else {$_.Parent.Parent.ReadOnly}}},
			@{N='RecoveryModel';E={if ($_.Urn.Type -eq 'LogFile') {$_.Parent.RecoveryModel} else {$_.Parent.Parent.RecoveryModel}}},
			@{N='CompatibilityLevel';E={if ($_.Urn.Type -eq 'LogFile') {$_.Parent.CompatibilityLevel} else {$_.Parent.Parent.CompatibilityLevel}}},
			@{N='FileSizeMB';E={$_.Size / 1024}},
			@{N='UsedSpaceMB';E={$_.UsedSpace / 1024}},
			@{N='GrowthMB';E={$_.Growth / 1024}}
		)
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.IsAccessible -and $_.Status -NotIn 'Offline', 'Offline, AutoClosed', 'Restoring'})

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to save database statistics on database ""$Item"".  Database does not exist or database not accessible on SQL server instance $ServerInstance."
				}
			}

			if ($Databases.Count -gt 0) {
				$DataFiles = $Databases.FileGroups.Files | Select-Object $FilesProperties
				$LogFiles = $Databases.LogFiles | Select-Object $FilesProperties

				$DataTable = [System.Data.DataTable]::New()

				foreach ($PropertyName in $DataFiles[0].PSObject.Properties.Name) {
					$DataColumn = [System.Data.DataColumn]::New($PropertyName)

					$DataTable.columns.Add($DataColumn)

					$DataColumn.Dispose()
				}

				foreach ($DataFile in $DataFiles) {
					$NewRow = $DataTable.NewRow()

					foreach ($Property in $DataFile.PSObject.Properties) {
						$NewRow[$Property.Name] = $DataFile."$($Property.Name)"
					}

					$DataTable.Rows.Add($NewRow)
				}

				foreach ($LogFile in $LogFiles) {
					$NewRow = $DataTable.NewRow()

					foreach ($Property in $LogFile.PSObject.Properties) {
						$NewRow[$Property.Name] = $LogFile."$($Property.Name)"
					}

					$DataTable.Rows.Add($NewRow)
				}

				$SmoServer.ConnectionContext.SqlConnectionObject.ChangeDatabase($StatisticsDatabaseName)

				$SqlClientBulkCopyParameters = @{
					'SqlConnection' = $SmoServer.ConnectionContext.SqlConnectionObject
					'TableName' = [string]::Format('[{0}].[{1}]', $StatisticsSchemaName, $StatisticsTableName)
					'DataTable' = $DataTable
				}

				Invoke-SqlClientBulkCopy @SqlClientBulkCopyParameters
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					if ($PSBoundParameters.ContainsKey('DatabaseName')) {
						$SummaryItem.Add('DatabaseName', $DatabaseName)
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Database Statistics Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if (Test-Path -Path variable:\DataTable) {
				$DataTable.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Save-SqlInstanceQueryStoreOption {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$SmoServer.Databases.Refresh()

			$StatisticsDatabaseName = $Script:PSMConfig.Config.AdminDatabase.DatabaseName
			$StatisticsSchemaName = $Script:PSMConfig.Config.AdminDatabase.Statistics.QueryStore.SchemaName
			$StatisticsTableName = $Script:PSMConfig.Config.AdminDatabase.Statistics.QueryStore.TableName
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServer) {
					if ($SmoServer -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServer
					}
				}
			}

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
						if ($ServerInstance -in @('.', '(local)')) {
							$SummaryItem = [ordered]@{
								'SqlInstance' = [System.Net.Dns]::GetHostName()
							}
						} else {
							$SummaryItem = [ordered]@{
								'SqlInstance' = $ServerInstance
							}
						}
					} else {
						$SummaryItem = [ordered]@{
							'SqlInstance' = $SmoServer.Name
						}
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Query Store Statistics Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters

					throw $ErrorRecord
				}
			}
		}

		$QueryStoreProperties = @(
			@{N='CollectionDate';E={[System.DateTimeOffset]::Now}},
			@{N='DatabaseName';E={$_.Parent.Name}},
			'DesiredState',
			'ActualState',
			'ReadOnlyReason',
			'CurrentStorageSizeInMB',
			'MaxStorageSizeInMB'
			<#
			'DataFlushIntervalInSeconds',
			'StatisticsCollectionIntervalInMinutes',
			'StaleQueryThresholdInDays',
			'MaxPlansPerQuery',
			'QueryCaptureMode',
			'SizeBasedCleanupMode',
			'WaitStatsCaptureMode',
			'CapturePolicyExecutionCount',
			'CapturePolicyTotalCompileCpuTimeInMS',
			'CapturePolicyTotalExecutionCpuTimeInMS',
			'CapturePolicyStaleThresholdInHrs'
			#>
		)
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.IsAccessible -and $_.Name -NotIn 'master', 'tempdb'})

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to save query store options on database ""$Item"".  Database does not exist or database not accessible on SQL server instance $ServerInstance."
				}
			}

			$QueryStoreOptions = $Databases.QueryStoreOptions.where({$_.DesiredState -NotIn 'Off', $null}) | Select-Object $QueryStoreProperties

			if ($null -ne $QueryStoreOptions) {
				$DataTable = [System.Data.DataTable]::New()

				foreach ($PropertyName in $QueryStoreOptions[0].PSObject.Properties.Name) {
					$DataColumn = [System.Data.DataColumn]::New($PropertyName)

					$DataTable.columns.Add($DataColumn)

					$DataColumn.Dispose()
				}

				foreach ($QueryStoreOption in $QueryStoreOptions) {
					$NewRow = $DataTable.NewRow()

					foreach ($Property in $QueryStoreOption.PSObject.Properties) {
						$NewRow[$Property.Name] = $QueryStoreOption."$($Property.Name)"
					}

					$DataTable.Rows.Add($NewRow)
				}

				$SmoServer.ConnectionContext.SqlConnectionObject.ChangeDatabase($StatisticsDatabaseName)

				$SqlClientBulkCopyParameters = @{
					'SqlConnection' = $SmoServer.ConnectionContext.SqlConnectionObject
					'TableName' = [string]::Format('[{0}].[{1}]', $StatisticsSchemaName, $StatisticsTableName)
					'DataTable' = $DataTable
				}

				Invoke-SqlClientBulkCopy @SqlClientBulkCopyParameters
			}
		}
		catch {
			$ErrorRecord = $_

			switch ($Script:OutputMethod) {
				'ConsoleHost' {
					throw $ErrorRecord
				}
				Default {
					$ErrorXml = ConvertTo-ErrorXML -ErrorObject $ErrorRecord

					$SummaryItem = [ordered]@{
						'SqlInstance' = $SmoServer.Name
					}

					if ($PSBoundParameters.ContainsKey('DatabaseName')) {
						$SummaryItem.Add('DatabaseName', $DatabaseName)
					}

					$EmailBody = Build-MailBody -Xml $ErrorXml -SummaryItem $SummaryItem

					$MailMessageParameters = $Script:BaseMailMessageParameters.PSObject.Copy()

					$MailMessageParameters.Add('Subject', 'SQL Query Store Statistics Failure')
					$MailMessageParameters.Add('Body', $EmailBody)

					Send-MailToolMessage @MailMessageParameters
				}
			}
		}
		finally {
			if (Test-Path -Path variable:\DataTable) {
				$DataTable.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServer
			}
		}
	}

	end {
	}
}

function Send-DatabaseMail {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerMaintenance.DatabaseMailItem])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseMailProfileName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress]$MailFrom,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress[]]$MailTo,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress]$ReplyTo,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress[]]$CarbonCopy,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress[]]$BlindCarbonCopy,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 78)]
		[string]$Subject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$Body,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$BodyAsHtml,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Net.Mail.MailPriority]$Priority = 'Normal',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[DbMailSensitivity]$Sensitivity
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SqlConnection = Connect-SqlServerInstance -ServerInstance $ServerInstance -DatabaseName 'master'
			}
		}
		catch {
			$ErrorRecord = $_

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SqlConnection) {
					Disconnect-SqlServerInstance -SqlConnection $SqlConnection
				}
			}

			throw $ErrorRecord
		}
	}

	process {
		try {
			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'DatabaseName' = 'master'
				'SqlCommandText' = 'SELECT @@SERVERNAME AS ServerName;'
				'OutputAs' = 'DataRow'
			}

			$DataRow = Get-SqlClientDataSet @SqlClientDataSetParameters

			$SqlParameterList = [System.Collections.Generic.List[Microsoft.Data.SqlClient.SqlParameter]]::New()

			#Region Procedure Parameter Binding
			$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@mailitem_id", [System.Data.SqlDbType]::int)
			$SqlParameter.Direction = [System.Data.ParameterDirection]::Output

			$SqlParameterList.Add($SqlParameter)

			if ($PSBoundParameters.ContainsKey('DatabaseMailProfileName')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@profile_name", [System.Data.SqlDbType]::VarChar, 128)
				$SqlParameter.Value = $DatabaseMailProfileName

				$SqlParameterList.Add($SqlParameter)
			}

			if ($PSBoundParameters.ContainsKey('MailFrom')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@from_address", [System.Data.SqlDbType]::VarChar, -1)
				$SqlParameter.Value = $MailFrom.ToString()

				$SqlParameterList.Add($SqlParameter)
			}

			$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@recipients", [System.Data.SqlDbType]::VarChar, -1)
			$SqlParameter.Value = $($MailTo -join ';')

			$SqlParameterList.Add($SqlParameter)

			if ($PSBoundParameters.ContainsKey('ReplyTo')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@reply_to", [System.Data.SqlDbType]::VarChar, -1)
				$SqlParameter.Value = $ReplyTo.ToString()

				$SqlParameterList.Add($SqlParameter)
			}

			if ($PSBoundParameters.ContainsKey('CarbonCopy')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@copy_recipients", [System.Data.SqlDbType]::VarChar, -1)
				$SqlParameter.Value = $($CarbonCopy -join ';')

				$SqlParameterList.Add($SqlParameter)
			}

			if ($PSBoundParameters.ContainsKey('BlindCarbonCopy')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@blind_copy_recipients", [System.Data.SqlDbType]::VarChar, -1)
				$SqlParameter.Value = $($BlindCarbonCopy -join ';')

				$SqlParameterList.Add($SqlParameter)
			}

			if ($PSBoundParameters.ContainsKey('Subject')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@subject", [System.Data.SqlDbType]::NVarChar, 255)
				$SqlParameter.Value = $Subject

				$SqlParameterList.Add($SqlParameter)
			}

			if ($PSBoundParameters.ContainsKey('Body')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@body", [System.Data.SqlDbType]::NVarChar, -1)
				$SqlParameter.Value = $Body

				$SqlParameterList.Add($SqlParameter)
			}

			if ($BodyAsHtml) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@body_format", [System.Data.SqlDbType]::VarChar, 20)
				$SqlParameter.Value = 'HTML'

				$SqlParameterList.Add($SqlParameter)
			}

			if ($PSBoundParameters.ContainsKey('Priority')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@importance", [System.Data.SqlDbType]::VarChar, 6)
				$SqlParameter.Value = $Priority

				$SqlParameterList.Add($SqlParameter)
			}

			if ($PSBoundParameters.ContainsKey('Sensitivity')) {
				$SqlParameter = [Microsoft.Data.SqlClient.SqlParameter]::New("@sensitivity", [System.Data.SqlDbType]::VarChar, 12)
				$SqlParameter.Value = $Sensitivity

				$SqlParameterList.Add($SqlParameter)
			}
			#EndRegion

			$OutSqlParameterList = [System.Collections.Generic.List[Microsoft.Data.SqlClient.SqlParameter]]::New()

			$SqlClientDataSetParameters = @{
				'SqlConnection' = $SqlConnection
				'DatabaseName' = 'msdb'
				'SqlCommandText' = 'dbo.sp_send_dbmail'
				'CommandType' = [System.Data.CommandType]::StoredProcedure
				'SqlParameter' = $SqlParameterList
				'OutSqlParameter' = $OutSqlParameterList
				'CommandTimeout' = 0
			}

			if ($PSCmdlet.ShouldProcess($DataRow.ServerName, 'Send Database Mail')) {
				[void]$(Get-SqlClientDataSet @SqlClientDataSetParameters)

				$DatabaseMailItem = [SqlServerMaintenance.DatabaseMailItem]::New()

				$DatabaseMailItem.SqlInstance = $DataRow.ServerName
				$DatabaseMailItem.MailItemID = $OutSqlParameterList.Where({$_.ParameterName -eq '@mailitem_id'}).Value
				$DatabaseMailItem.Recipients = $MailTo
				$DatabaseMailItem.Subject = $Subject

				$DatabaseMailItem
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Set-SqlServerMaintenanceConfiguration {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SqlServerMaintenanceSetting]$SettingName
	)

	DynamicParam {
		$RuntimeDefinedParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::New()

		switch ($SettingName) {
			'SmtpSettings' {
				#Region SmtpServer
				$ParameterName = 'SmtpServer'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'Network'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateNotNullOrEmptyAttribute = [System.Management.Automation.ValidateNotNullOrEmptyAttribute]::New()
				$AttributeCollection.Add($ValidateNotNullOrEmptyAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region SmtpPort
				$ParameterName = 'SmtpPort'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'Network'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateRangeAttribute = [System.Management.Automation.ValidateRangeAttribute]::New(1, 65535)
				$AttributeCollection.Add($ValidateRangeAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [int], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region UseTls
				$ParameterName = 'UseTls'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.ParameterSetName = 'Network'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [switch], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region PickupDirectoryPath
				$ParameterName = 'PickupDirectoryPath'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'SpecifiedPickupDirectory'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateScriptAttribute = [System.Management.Automation.ValidateScriptAttribute]::New({Test-Path -LiteralPath $_ -PathType Container})
				$AttributeCollection.Add($ValidateScriptAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion
			}

			'EmailNotification' {
				#Region SenderAddress
				$ParameterName = 'SenderAddress'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.ParameterSetName = 'EmailNotification'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateNotNullOrEmptyAttribute = [System.Management.Automation.ValidateNotNullOrEmptyAttribute]::New()
				$AttributeCollection.Add($ValidateNotNullOrEmptyAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region RecipientAddress
				$ParameterName = 'RecipientAddress'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.ParameterSetName = 'EmailNotification'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateRangeAttribute = [System.Management.Automation.ValidateCountAttribute]::New(1, 10)
				$AttributeCollection.Add($ValidateRangeAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string[]], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion
			}

			'AdminDatabase' {
				#Region DatabaseName
				$ParameterName = 'DatabaseName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'AdminDatabase'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateLengthAttribute = [System.Management.Automation.ValidateLengthAttribute]::New(1, 128)
				$AttributeCollection.Add($ValidateLengthAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion
			}
			'Statistics' {
				#Region StatisticName
				$ParameterName = 'StatisticName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'Statistics'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [DbStatistic], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region SchemaName
				$ParameterName = 'SchemaName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Statistics'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region TableName
				$ParameterName = 'TableName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Statistics'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region RetentionInDays
				$ParameterName = 'RetentionInDays'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Statistics'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateRangeAttribute = [System.Management.Automation.ValidateRangeAttribute]::New([System.Management.Automation.ValidateRangeKind]::Positive)
				$AttributeCollection.Add($ValidateRangeAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [int], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion
			}
			'Tests' {
				#Region TestName
				$ParameterName = 'TestName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'Tests'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [DbTest], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region SchemaName
				$ParameterName = 'SchemaName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Tests'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region TableName
				$ParameterName = 'TableName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Tests'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region RetentionInDays
				$ParameterName = 'RetentionInDays'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $false
				$ParameterAttribute.ParameterSetName = 'Tests'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateRangeAttribute = [System.Management.Automation.ValidateRangeAttribute]::New([System.Management.Automation.ValidateRangeKind]::Positive)
				$AttributeCollection.Add($ValidateRangeAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [int], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion
			}
			'SqlAgentAlerts' {
				#Region SchemaName
				$ParameterName = 'SchemaName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'SqlAgentAlerts'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region TableName
				$ParameterName = 'TableName'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'SqlAgentAlerts'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [string], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion

				#Region RetentionInDays
				$ParameterName = 'RetentionInDays'

				$ParameterAttribute = [System.Management.Automation.ParameterAttribute]::New()
				$ParameterAttribute.Mandatory = $true
				$ParameterAttribute.ParameterSetName = 'SqlAgentAlerts'

				$AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
				$AttributeCollection.Add($ParameterAttribute)

				$ValidateRangeAttribute = [System.Management.Automation.ValidateRangeAttribute]::New([System.Management.Automation.ValidateRangeKind]::Positive)
				$AttributeCollection.Add($ValidateRangeAttribute)

				$RuntimeDefinedParameter = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [int], $AttributeCollection)

				$RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeDefinedParameter)
				#EndRegion
			}
			Default {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Unknown setting.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidType,
					$SettingName
				)
			}
		}

		$RuntimeDefinedParameterDictionary
	}

	begin {
	}

	process {
		try {
			switch ($SettingName) {
				'SMTPSettings' {
					$Script:PSMConfig.Config.SMTPSettings.SmtpDeliveryMethod = $PSCmdlet.ParameterSetName

					if ($PSCmdlet.ParameterSetName -eq 'Network') {
						$Script:PSMConfig.Config.SMTPSettings.SmtpServer = $PSBoundParameters['SmtpServer']
						$Script:PSMConfig.Config.SMTPSettings.SmtpPort = $PSBoundParameters['SmtpPort'].ToString()

						if ($PSBoundParameters['UseTls']) {
							$Script:PSMConfig.Config.SMTPSettings.UseTls = 'True'
						} else {
							$Script:PSMConfig.Config.SMTPSettings.UseTls = 'False'
						}
					} else {
						$Script:PSMConfig.Config.SMTPSettings.PickupDirectoryPath = $PSBoundParameters['PickupDirectoryPath']
					}
				}
				'EmailNotification' {
					if ($PSBoundParameters.ContainsKey('SenderAddress')) {
						$Script:PSMConfig.Config.EmailNotification.SenderAddress = $PSBoundParameters['SenderAddress']
					}

					if ($PSBoundParameters.ContainsKey('RecipientAddress')) {
						$ChildNodes = $Script:PSMConfig.SelectNodes('//Config/EmailNotification/Recipients/Recipient')

						foreach($ChildNode in $ChildNodes){
							[void]$ChildNode.ParentNode.RemoveChild($ChildNode)
						}

						foreach ($Recipient in $PSBoundParameters['RecipientAddress']) {
							$Element = $Script:PSMConfig.CreateElement('Recipient')
							$Element.InnerText = $Recipient

							[void]$Script:PSMConfig.SelectNodes('//Config/EmailNotification/Recipients').AppendChild($Element)
						}
					}
				}
				'AdminDatabase' {
					$Script:PSMConfig.Config.AdminDatabase.DatabaseName = $PSBoundParameters['DatabaseName']
				}
				'Statistics' {
					if ($PSBoundParameters['SchemaName']) {
						$Script:PSMConfig.Config.AdminDatabase.Statistics."$($PSBoundParameters['StatisticName'])".SchemaName = $PSBoundParameters['SchemaName']
					}

					if ($PSBoundParameters['TableName']) {
						$Script:PSMConfig.Config.AdminDatabase.Statistics."$($PSBoundParameters['StatisticName'])".TableName = $PSBoundParameters['TableName']
					}

					if ($PSBoundParameters['RetentionInDays']) {
						$Script:PSMConfig.Config.AdminDatabase.Statistics."$($PSBoundParameters['StatisticName'])".RetentionDays = $PSBoundParameters['RetentionInDays'].ToString()
					}
				}
				'Tests' {
					if ($PSBoundParameters['SchemaName']) {
						$Script:PSMConfig.Config.AdminDatabase.Tests."$($PSBoundParameters['TestName'])".SchemaName = $PSBoundParameters['SchemaName']
					}

					if ($PSBoundParameters['TableName']) {
						$Script:PSMConfig.Config.AdminDatabase.Tests."$($PSBoundParameters['TestName'])".TableName = $PSBoundParameters['TableName']
					}

					if ($PSBoundParameters['RetentionInDays']) {
						$Script:PSMConfig.Config.AdminDatabase.Tests."$($PSBoundParameters['TestName'])".RetentionDays = $PSBoundParameters['RetentionInDays'].ToString()
					}
				}
				'SqlAgentAlerts' {
					if ($PSBoundParameters['SchemaName']) {
						$Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.SchemaName = $PSBoundParameters['SchemaName']
					}

					if ($PSBoundParameters['TableName']) {
						$Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.TableName = $PSBoundParameters['TableNames']
					}

					if ($PSBoundParameters['RetentionInDays']) {
						$Script:PSMConfig.Config.AdminDatabase.SqlAgentAlerts.RetentionDays = $PSBoundParameters['RetentionInDays'].ToString()
					}
				}
				Default {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Unknown setting.'),
						'2',
						[System.Management.Automation.ErrorCategory]::InvalidType,
						$SettingName
					)
				}
			}

			if ($PSCmdlet.ShouldProcess($SettingName, 'Update Configuration')) {
				$Script:PSMConfig.Save($Script:ConfigurationFile)
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Switch-SqlInstanceTDECertificate {
	<#
	.EXTERNALHELP
	SqlServerMaintenance-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServerObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string[]]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$CertificateName
	)

	begin {
		try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServer = Connect-SmoServer @SmoServerParameters
			} else {
				$SmoServer = $SmoServerObject
			}

			$AGReplicaList = [System.Collections.Generic.List[string]]::New()

			if (-not [string]::IsNullOrEmpty($SmoServer.ClusterName)) {
				$AGReplicaList.AddRange([string[]]$($SmoServer.AvailabilityGroups.AvailabilityReplicas.Name | Select-Object -Unique))
			}

			$DatabaseObject = Get-SmoDatabaseObject -SmoServerObject $SmoServer -DatabaseName 'master'

			if ($PSBoundParameters.ContainsKey('CertificateName')) {
				if ($null -eq $(Get-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName $CertificateName)) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[System.ArgumentException]::New('Certificate not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$CertificateName
					)
				}
			}

			$Certificates = $(Get-SmoDatabaseCertificate -DatabaseObject $DatabaseObject).where({$_.Subject -eq 'TDE Certificate' -and $_.ExpirationDate -gt $(Get-Date)})

			if ($Certificates.Count -eq 0) {
				$Timestamp = $(Get-Date).ToUniversalTime().ToString('yyyyMMddHHmmss')

				if ([string]::IsNullOrEmpty($SmoServer.ClusterName)) {
					$CertificateName = [string]::Format('TDE_{0}_{1}', $SmoServer.NetName, $Timestamp)
				} else {
					$CertificateName = [string]::Format('TDE_{0}_{1}', $SmoServer.ClusterName, $Timestamp)
				}

				$Certificate = $null
			} else {
				$Certificate = Sort-Object -InputObject $Certificates -Property 'ExpirationDate' -Descending | Select-Object -First 1

				$CertificateName = $Certificate.Name
			}

			$SmoServer.Databases.Refresh()
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				$Databases = $SmoServer.Databases.where({$_.Name -in $DatabaseName})
			} else {
				$Databases = $SmoServer.Databases
			}

			$Databases = $Databases.where({$_.Status -eq 'Normal' -and $_.ReadOnly -eq $false -and $_.IsUpdateable -eq $true -and $_.Name -ne 'tempdb' -and $null -ne $_.DatabaseEncryptionKey.EncryptorName})

			if ($SmoServer.IsHadrEnabled) {
				$Databases = $Databases.where({$_.IsAccessible -eq $true})
			}

			if ($PSBoundParameters.ContainsKey('DatabaseName')) {
				if ($Databases.Count -eq 0) {
					$Collection = $DatabaseName
				} else{
					$Collection = $DatabaseName.where({$_ -NotIn $Databases.Name})
				}

				foreach ($Item in $Collection) {
					Write-Warning "Unable to switch TDE certificate on database ""$Item"".  Database does not exist or database not accessible on SQL server instance $ServerInstance."
				}
			}

			if ($null -eq $Certificate) {
				Write-Verbose 'Creating certificate.'

				if ($PSCmdlet.ShouldProcess($DatabaseObject.Name, 'Create certificate')) {
					[void]$(New-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName $CertificateName -Subject 'TDE Certificate')
				}
			}

			if ($AGReplicaList.Count -gt 0) {
				Write-Verbose 'Exporting Certificate'

				$BaseFileName  = [string]::Format('{0}_{1}', $CertificateName, $(Get-Date).ToUniversalTime().ToString('yyyyMMddHHmmss'))

				$CertificatePath = $(Join-Path2 -Path $SmoServer.BackupDirectory -ChildPath $([string]::Format('{0}.{1}', $BaseFileName, 'cer')))
				$PrivateKeyPath = $(Join-Path2 -Path $SmoServer.BackupDirectory -ChildPath $([string]::Format('{0}.{1}', $BaseFileName, 'key')))

				$PrivateKeyPassword = [RandomPassword]::Generate(32, 64, $true)

				$SmoDatabaseCertificateParameters = @{
					DatabaseObject = $DatabaseObject
					CertificateName = $CertificateName
					CertificatePath = $CertificatePath
					PrivateKeyPath = $PrivateKeyPath
					PrivateKeyEncryptionPassword = $PrivateKeyPassword
				}

				if ($PSCmdlet.ShouldProcess($DatabaseObject.Name, 'Export database certificate')) {
					Export-SmoDatabaseCertificate @SmoDatabaseCertificateParameters
				}

				foreach ($AGReplica in $AGReplicaList.where({$_ -ne $SmoServer.NetName})) {
					if ($null -ne $(Get-SmoDatabaseCertificate -ServerInstance $AGReplica -DatabaseName 'master' -CertificateName $CertificateName)) {
						continue
					}

					Write-Verbose "$AGReplica - Creating certificate on replica."

					$SmoDatabaseCertificateParameters = @{
						ServerInstance = $AGReplica
						DatabaseName = 'master'
						CertificateName = $CertificateName
						CertificatePath = $CertificatePath
						PrivateKeyPath = $PrivateKeyPath
						PrivateKeyDecryptionPassword = $PrivateKeyPassword
					}

					if ($PSCmdlet.ShouldProcess($AGReplica, 'Importing database certificate')) {
						[void]$(New-SmoDatabaseCertificate @SmoDatabaseCertificateParameters)
					}
				}
			}

			foreach ($Database in $Databases) {
				try {
					Write-Verbose "$($Database.Name) - Changing database encryption key."

					if ($PSCmdlet.ShouldProcess($Database.Name, 'Change database encryption key')) {
						Set-SmoDatabaseEncryptionKey -DatabaseObject $Database -EncryptionType ServerCertificate -EncryptorName $CertificateName
					}
				}
				catch {
					$PSCmdlet.WriteError($_)
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}


New-Alias -Name New-SqlDatabaseSnapshot -Value Checkpoint-SqlDatabaseSnapshot

#Region Export Module Members
Export-ModuleMember	-Alias New-SqlDatabaseSnapshot
#EndRegion
