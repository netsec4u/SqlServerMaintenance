---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-AvailabilityGroupDatabaseReplicaStatus
---

# Get-AvailabilityGroupDatabaseReplicaStatus

## SYNOPSIS

Get availability group database replica status information.

## SYNTAX

### ServerInstance (Default)

```
Get-AvailabilityGroupDatabaseReplicaStatus
  -ServerInstance <string>
  [-AvailabilityGroupName <string>]
  [-DatabaseName <string>]
  [<CommonParameters>]
```

### SmoServerObject

```
Get-AvailabilityGroupDatabaseReplicaStatus
  -SmoServerObject <Server>
  [-AvailabilityGroupName <string>]
  [-DatabaseName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Get availability group database replica status information.

## EXAMPLES

### Example 1

```powershell
Get-AvailabilityGroupDatabaseReplicaStatus -ServerInstance .
```

Get availability group database replica status for all databases.

### Example 2

```powershell
Get-AvailabilityGroupDatabaseReplicaStatus -ServerInstance . -DatabaseName AdventureWorks
```

Get availability group database replica status for AdventureWorks database.

### Example 3

```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master
Get-AvailabilityGroupDatabaseReplicaStatus -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

Get availability group database replica status for AdventureWorks database.

## PARAMETERS

### -AvailabilityGroupName

Specifies availability group name.

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

### Microsoft.SqlServer.Management.Smo.DatabaseReplicaState



## NOTES




## RELATED LINKS

None.

