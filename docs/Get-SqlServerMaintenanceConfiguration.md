---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-SqlServerMaintenanceConfiguration

## SYNOPSIS
Get module configuration.

## SYNTAX

```
Get-SqlServerMaintenanceConfiguration
	-SettingName <SqlServerMaintenanceSetting>
	[<CommonParameters>]
```

## DESCRIPTION
Get module configuration.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SqlServerMaintenanceConfiguration -SettingName SmtpSettings
```

Get module configuration for SmtpSettings.

## PARAMETERS

### -SettingName
Specifies setting to retrieve settings.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
