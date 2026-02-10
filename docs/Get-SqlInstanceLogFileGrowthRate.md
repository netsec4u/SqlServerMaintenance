---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlInstanceLogFileGrowthRate
---

# Get-SqlInstanceLogFileGrowthRate

## SYNOPSIS

Evaluates log file auto growth rate to alert when rate is less than 12.5% of log file size.

## SYNTAX

### ServerInstance (Default)

```
Get-SqlInstanceLogFileGrowthRate
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [-LogAutoGrowthThreshold <decimal>]
  [<CommonParameters>]
```

### SmoServerObject

```
Get-SqlInstanceLogFileGrowthRate
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [-LogAutoGrowthThreshold <decimal>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Evaluates log file auto growth rate to alert when rate is less than 12.5% of log file size.

## EXAMPLES

### Example 1

```powershell
Get-SqlInstanceLogFileGrowthRate -ServerInstance .
```

Get log file growth rate for all databases on SQL instance.

### Example 2

```powershell
Get-SqlInstanceLogFileGrowthRate -ServerInstance . -DatabaseName AdventureWorks
```

Get log file growth rate for AdventureWorks database.

### Example 3

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Get-SqlInstanceLogFileGrowthRate -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Get log file growth rate for AdventureWorks database using the specified Smo session.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to evaluate log file growth rate.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

### -LogAutoGrowthThreshold

Specifies the minimum threshold percentage for auto growth.

```yaml
Type: System.Decimal
DefaultValue: 0.125
SupportsWildcards: false
Aliases: []
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

### -ServerInstance

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ServerInstance
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
- Name: SmoServerObject
  Position: Named
  IsRequired: true
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

### SqlServerMaintenance.SqlLogFileGrowth



## NOTES




## RELATED LINKS

None.

