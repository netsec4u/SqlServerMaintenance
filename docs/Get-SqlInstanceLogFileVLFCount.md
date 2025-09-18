---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlInstanceLogFileVLFCount
---

# Get-SqlInstanceLogFileVLFCount

## SYNOPSIS

Evaluates virtual log file (VLF) count.

## SYNTAX

### ServerInstance (Default)

```
Get-SqlInstanceLogFileVLFCount
  -ServerInstance <string>
  [-DatabaseName <string>]
  [-VLFCountThreshold <int>]
  [<CommonParameters>]
```

### SmoServerObject

```
Get-SqlInstanceLogFileVLFCount
  -SmoServerObject <Server>
  [-DatabaseName <string>]
  [-VLFCountThreshold <int>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Evaluates virtual log file (VLF) count.

## EXAMPLES

### EXAMPLE 1

Get-SqlInstanceLogFileVLFCount -ServerInstance .

Get virtual log file (VLF) count for all databases on SQL instance.

### EXAMPLE 2

Get-SqlInstanceLogFileVLFCount -ServerInstance . -DatabaseName AdventureWorks

Get virtual log file (VLF) count for database AdventureWorks

### EXAMPLE 3

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Get-SqlInstanceLogFileVLFCount -SmoServerObject $SmoServer -DatabaseName AdventureWorks

Get virtual log file (VLF) count for database AdventureWorks using the specified Smo session.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to evaluate log file growth rate.

```yaml
Type: System.String
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

### -ServerInstance

Specifies the name of a SQL Server instance.

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

Specifies SQL Server Management Object.

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

### -VLFCountThreshold

VLF count threshold.

```yaml
Type: System.Int32
DefaultValue: 100
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

### SqlServerMaintenance.SqlLogFileVLFCount



## NOTES

1 VLF	When growth rate is less than 1/8 total log size 4 VLF	When growth rate is greater than 1/8 total log size and growth less than 64MB 8 VLF	When growth rate is greater than 1/8 total log size and growth less than 1GB 16 VLF	When growth rate is greater than 1/8 total log size and growth greater than 1GB

Growth rate should not be greater than 64GB


## RELATED LINKS

None.

