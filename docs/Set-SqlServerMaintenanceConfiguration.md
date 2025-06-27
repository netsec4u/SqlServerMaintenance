---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
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

## DESCRIPTION
Set module configuration.

## EXAMPLES

### EXAMPLE 1
```powershell
Set-SqlServerMaintenanceConfiguration -SettingName SmtpSettings -SmtpServer mail.domain.com -SmtpPort 587 -UseTls:$false
```

Sets SMTP settings for module configuration.

### EXAMPLE 2
```powershell
Set-SqlServerMaintenanceConfiguration -SettingName SmtpSettings -PickupDirectoryPath C:\ProgramData\PowerShell\SqlServerMaintenance\Email\
```

Sets SMTP settings for module configuration.

### EXAMPLE 3
```powershell
Set-SqlServerMaintenanceConfiguration -SettingName EmailNotification -SenderAddress server@domain.com -RecipientAddress @('DBA Team<dbateam@domain.com>')
```

Sets sender and recipient settings for module configuration.

### EXAMPLE 4
```powershell
Set-SqlServerMaintenanceConfiguration -SettingName AdminDatabase -DatabaseName Admin
```

Sets admin database name for module configuration.

### EXAMPLE 5
```powershell
Set-SqlServerMaintenanceConfiguration -SettingName Statistics -StatisticName Backup -RetentionInDays 45
```

Sets backup statistics retention period for module configuration.

### EXAMPLE 6
```powershell
Set-SqlServerMaintenanceConfiguration -SettingName Tests -TestName Backup -RetentionInDays 45
```

Sets backup test retention period for module configuration.

### EXAMPLE 7
```powershell
Set-SqlServerMaintenanceConfiguration -SettingName SqlAgentAlerts -RetentionInDays 45
```

Sets SQL Agent Alert retention period for module configuration.

## PARAMETERS

### -DatabaseName
Specifies the name of the admin database to store information from module such as statistics.
Dynamic parameter available when SettingName is AdminDatabase.

```yaml
Type: String
Parameter Sets: AdminDatabase
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PickupDirectoryPath
Specifies path to pickup directory.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: String
Parameter Sets: SpecifiedPickupDirectory
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecipientAddress
Specifies a list of recipients to send email notifications to.
Dynamic parameter available when SettingName is EmailNotification.

```yaml
Type: String[]
Parameter Sets: EmailNotification
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetentionInDays
Specifies the number of days to retain statistics, test results, and SQL Agent alerts.
Dynamic parameter available when SettingName is Statistics, Tests, or SQLAgentAlerts.

```yaml
Type: Int32
Parameter Sets: Statistics, Tests, SqlAgentAlerts
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SenderAddress
Specifies sender address.
Dynamic parameter available when SettingName is EmailNotification.

```yaml
Type: String
Parameter Sets: EmailNotification
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingName
Specifies setting to set configuration.

```yaml
Type: SqlServerMaintenanceSetting
Parameter Sets: (All)
Aliases:
Accepted values: SmtpSettings, EmailNotification, AdminDatabase, Statistics, Tests, SqlAgentAlerts

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpPort
Specifies smtp port number.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: Int32
Parameter Sets: Network
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpServer
Specifies the hostname of the smtp server.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: String
Parameter Sets: Network
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatisticName
Specifies the name of the statistic to configure.
Dynamic parameter available when SettingName is Statistics.

```yaml
Type: DbStatistic
Parameter Sets: Statistics
Aliases:
Accepted values: Backup, ColumnStore, Database, FullTextIndex, Index, QueryStore, TableStatistics

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestName
Specifies the name of test to configure.
Dynamic parameter available when SettingName is Tests.

```yaml
Type: DbTest
Parameter Sets: Tests
Aliases:
Accepted values: Backup

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseTLS
Specifies smtp to be sent over TLS.
Dynamic parameter available when SettingName is SMTPSettings.

```yaml
Type: SwitchParameter
Parameter Sets: Network
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
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

## RELATED LINKS
