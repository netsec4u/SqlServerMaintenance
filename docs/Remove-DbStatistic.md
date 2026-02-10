---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Remove-DbStatistic
---

# Remove-DbStatistic

## SYNOPSIS

Remove database statistic from statistics table.

## SYNTAX

### Default-ServerInstance (Default)

```
Remove-DbStatistic
  -ServerInstance <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### NamedStatistic-ServerInstance

```
Remove-DbStatistic
  -ServerInstance <string>
  -StatisticsName <DbStatistic>
  [-Retention <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### NamedStatistic-SqlConnection

```
Remove-DbStatistic
  -SqlConnection <SqlConnection>
  -StatisticsName <DbStatistic>
  [-Retention <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### Default-SqlConnection

```
Remove-DbStatistic
  -SqlConnection <SqlConnection>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Remove database statistic from statistics table.

## EXAMPLES

### Example 1

```powershell
Remove-DbStatistic -ServerInstance .
```

Remove statistics older than retention period.

### Example 2

```powershell
Remove-DbStatistic -ServerInstance . -StatisticsName Database
```

Remove Database database statistics older than retention period.

### Example 3

```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master
Remove-DbStatistic -SqlConnection $SqlConnection -StatisticsName Database
```

Remove Database database statistics older than retention period using specified Sql connection.

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

### -Retention

Specifies the number of days to retain.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamedStatistic-SqlConnection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: NamedStatistic-ServerInstance
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
- Name: NamedStatistic-ServerInstance
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
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SqlConnection

An open SQL Client Connection object.

```yaml
Type: Microsoft.Data.SqlClient.SqlConnection
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamedStatistic-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StatisticsName

Specifies the name of the statistics to remove.

```yaml
Type: DbStatistic
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamedStatistic-SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: NamedStatistic-ServerInstance
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

### System.Void



## NOTES




## RELATED LINKS

None.

