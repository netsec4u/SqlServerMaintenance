---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-AvailabilityGroupSeedingStatus
---

# Get-AvailabilityGroupSeedingStatus

## SYNOPSIS

Get availability group seeding status information.

## SYNTAX

### ServerInstance (Default)

```
Get-AvailabilityGroupSeedingStatus
  -ServerInstance <string>
  [-DatabaseName <string>]
  [<CommonParameters>]
```

### SqlConnection

```
Get-AvailabilityGroupSeedingStatus
  -SqlConnection <SqlConnection>
  [-DatabaseName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Get availability group seeding status information.

## EXAMPLES

### EXAMPLE 1

Get-AvailabilityGroupSeedingStatus -ServerInstance .

Get availability group seeding status for all databases.

### EXAMPLE 2

Get-AvailabilityGroupSeedingStatus -ServerInstance . -DatabaseName AdventureWorks

Get availability group seeding status for AdventureWorks database.

### EXAMPLE 3

$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-AvailabilityGroupSeedingStatus -SqlConnection $SqlConnection -DatabaseName AdventureWorks

Get availability group seeding status for AdventureWorks database.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to gather status information.

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

### -SqlConnection

Specifies SQL connection object.

```yaml
Type: Microsoft.Data.SqlClient.SqlConnection
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnection
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

### System.Data.DataRow



## NOTES




## RELATED LINKS

None.

