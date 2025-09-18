---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Set-SqlServerMaintenanceConfiguration
---

# Set-SqlServerMaintenanceConfiguration

## SYNOPSIS

Set module configuration.

## SYNTAX

### Base (Default)

```
Set-SqlServerMaintenanceConfiguration
  -SettingName <SqlServerMaintenanceSetting>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### Network
```
Set-SqlServerMaintenanceConfiguration
	-SettingName SmtpSettings
	-SmtpServer <String>
	-SmtpPort <Int32>
	[-UseTLS]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SpecifiedPickupDirectory
```
Set-SqlServerMaintenanceConfiguration
	-SettingName SmtpSettings
	-PickupDirectoryPath <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### EmailNotification
```
Set-SqlServerMaintenanceConfiguration
	-SettingName EmailNotification
	[-SenderAddress <String>]
	[-RecipientAddress <String[]>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### AdminDatabase
```
Set-SqlServerMaintenanceConfiguration
	-SettingName AdminDatabase
	-DatabaseName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### Statistics
```
Set-SqlServerMaintenanceConfiguration
	-SettingName Statistics
	-StatisticName <DbStatistic>
	-RetentionInDays <Int32>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### Tests
```
Set-SqlServerMaintenanceConfiguration
	-SettingName Tests
	-TestName <DbTest>
	-RetentionInDays <Int32>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlAgentAlerts
```
Set-SqlServerMaintenanceConfiguration
	-SettingName SqlAgentAlerts
	-RetentionInDays <Int32>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Set module configuration.

## EXAMPLES

### EXAMPLE 1

Set-SqlServerMaintenanceConfiguration -SettingName SmtpSettings -SmtpServer mail.domain.com -SmtpPort 587 -UseTls:$false

Sets SMTP settings for module configuration.

### EXAMPLE 2

Set-SqlServerMaintenanceConfiguration -SettingName SmtpSettings -PickupDirectoryPath C:\ProgramData\PowerShell\SqlServerMaintenance\Email\

Sets SMTP settings for module configuration.

### EXAMPLE 3

Set-SqlServerMaintenanceConfiguration -SettingName EmailNotification -SenderAddress server@domain.com -RecipientAddress @('DBA Team<dbateam@domain.com>')

Sets sender and recipient settings for module configuration.

### EXAMPLE 4

Set-SqlServerMaintenanceConfiguration -SettingName AdminDatabase -DatabaseName Admin

Sets admin database name for module configuration.

### EXAMPLE 5

Set-SqlServerMaintenanceConfiguration -SettingName Statistics -StatisticName Backup -RetentionInDays 45

Sets backup statistics retention period for module configuration.

### EXAMPLE 6

Set-SqlServerMaintenanceConfiguration -SettingName Tests -TestName Backup -RetentionInDays 45

Sets backup test retention period for module configuration.

### EXAMPLE 7

Set-SqlServerMaintenanceConfiguration -SettingName SqlAgentAlerts -RetentionInDays 45

Sets SQL Agent Alert retention period for module configuration.

## PARAMETERS

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

### -DatabaseName

Specifies the name of the admin database to store information from module such as statistics.
Dynamic parameter available when SettingName is AdminDatabase.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AdminDatabase
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PickupDirectoryPath

Specifies path to pickup directory.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SpecifiedPickupDirectory
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RecipientAddress

Specifies a list of recipients to send email notifications to.
Dynamic parameter available when SettingName is EmailNotification.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: EmailNotification
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RetentionInDays

Specifies the number of days to retain statistics, test results, and SQL Agent alerts.
Dynamic parameter available when SettingName is Statistics, Tests, or SQLAgentAlerts.

```yaml
Type: System.Int32
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Statistics
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Tests
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlAgentAlerts
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SenderAddress

Specifies sender address.
Dynamic parameter available when SettingName is EmailNotification.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: EmailNotification
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SettingName

Specifies setting to set configuration.

```yaml
Type: SqlServerMaintenanceSetting
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

### -SmtpPort

Specifies smtp port number.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: System.Int32
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Network
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SmtpServer

Specifies the hostname of the smtp server.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Network
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StatisticName

Specifies the name of the statistic to configure.
Dynamic parameter available when SettingName is Statistics.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Statistics
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TestName

Specifies the name of test to configure.
Dynamic parameter available when SettingName is Tests.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Tests
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UseTLS

Specifies smtp to be sent over TLS.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Network
  Position: Named
  IsRequired: false
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

### System.Void



## NOTES




## RELATED LINKS

None.

