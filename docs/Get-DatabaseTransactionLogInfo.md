---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-DatabaseTransactionLogInfo
---

# Get-DatabaseTransactionLogInfo

## SYNOPSIS

Get database transaction log information.

## SYNTAX

### ServerInstance (Default)

```
Get-DatabaseTransactionLogInfo
  -ServerInstance <string>
  -DatabaseName <string[]>
  [<CommonParameters>]
```

### SqlConnection

```
Get-DatabaseTransactionLogInfo
  -SqlConnection <SqlConnection>
  -DatabaseName <string[]>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Get database transaction log information.

## EXAMPLES

### EXAMPLE 1

Get-DatabaseTransactionLogInfo -ServerInstance . -DatabaseName AdventureWorks

Get transaction log information from database AdventureWorks.

### EXAMPLE 2

$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-DatabaseTransactionLogInfo -SqlConnection $SqlConnection -DatabaseName AdventureWorks

Get transaction log information from database AdventureWorks.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to gather log file information.

```yaml
Type: System.String[]
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

### SqlServerMaintenance.DatabaseTransactionLogInfo



## NOTES




## RELATED LINKS

None.

