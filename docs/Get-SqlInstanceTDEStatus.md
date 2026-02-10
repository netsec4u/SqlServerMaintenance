---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlInstanceTDEStatus
---

# Get-SqlInstanceTDEStatus

## SYNOPSIS

Get database Transparent Database Encryption (TDE) status information.

## SYNTAX

### ServerInstance (Default)

```
Get-SqlInstanceTDEStatus
  -ServerInstance <string>
  [-DatabaseName <string>]
  [<CommonParameters>]
```

### SqlConnection

```
Get-SqlInstanceTDEStatus
  -SqlConnection <SqlConnection>
  [-DatabaseName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Get database Transparent Database Encryption (TDE) status information.

## EXAMPLES

### Example 1

```powershell
Get-SqlInstanceTDEStatus -ServerInstance .
```

Get transparent database encryption (TDE) status for all databases.

### Example 2

```powershell
Get-SqlInstanceTDEStatus -ServerInstance . -DatabaseName AdventureWorks
```

Get transparent database encryption (TDE) status for AdventureWorks database.

### Example 3

```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master
Get-SqlInstanceTDEStatus -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

Get transparent database encryption (TDE) status for AdventureWorks database using the specified sql connection.

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

### -SqlConnection

An open SQL Client Connection object.

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

