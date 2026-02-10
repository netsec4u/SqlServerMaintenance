---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlInstanceDataFileUsage
---

# Get-SqlInstanceDataFileUsage

## SYNOPSIS

Gets data file usage on all databases or a specified database.

## SYNTAX

### ServerInstance (Default)

```
Get-SqlInstanceDataFileUsage
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [-FreeSpaceThreshold <int>]
  [-MinimumSamples <int>]
  [-StatisticPeriod <int>]
  [-ProjectionPeriod <int>]
  [-MinimumFileGrowth <int>]
  [-ReliabilityThreshold <decimal>]
  [<CommonParameters>]
```

### SmoServerObject

```
Get-SqlInstanceDataFileUsage
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [-FreeSpaceThreshold <int>]
  [-MinimumSamples <int>]
  [-StatisticPeriod <int>]
  [-ProjectionPeriod <int>]
  [-MinimumFileGrowth <int>]
  [-ReliabilityThreshold <decimal>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Gets data file usage on all databases or a specified database.

## EXAMPLES

### Example 1

```powershell
Get-SqlInstanceDataFileUsage -ServerInstance .
```

Get data file usage for all databases.

### Example 2

```powershell
Get-SqlInstanceDataFileUsage -ServerInstance . -DatabaseName AdventureWorks
```

Get data file usage for AdventureWorks database.

### Example 3

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Get-SqlInstanceDataFileUsage -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Get data file usage for AdventureWorks database using the specified Smo session.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to gather data file usage.

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

### -FreeSpaceThreshold

Specifies the free space threshold.

```yaml
Type: System.Int32
DefaultValue: 15
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

### -MinimumFileGrowth

Specifies the minimum file growth in MB.

```yaml
Type: System.Int32
DefaultValue: 64
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

### -MinimumSamples

Specifies the minimum number of samples to project growth.

```yaml
Type: System.Int32
DefaultValue: 5
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

### -ProjectionPeriod

Specifies the number of days to project growth.

```yaml
Type: System.Int32
DefaultValue: 30
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

### -ReliabilityThreshold

Specifies the threshold for automatically growing logical file.

```yaml
Type: System.Decimal
DefaultValue: 0.85
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

### -StatisticPeriod

Specified number of days of statistics used to calculate growth rate.

```yaml
Type: System.Int32
DefaultValue: 30
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SqlServerMaintenance.SqlDataFileUsage



## NOTES




## RELATED LINKS

None.

