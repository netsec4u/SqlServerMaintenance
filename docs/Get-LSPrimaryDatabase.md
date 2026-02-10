---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-LSPrimaryDatabase
---

# Get-LSPrimaryDatabase

## SYNOPSIS

Retrieve log shipping databases for primary role.

## SYNTAX

### ServerInstance (Default)

```
Get-LSPrimaryDatabase
  -ServerInstance <string>
  [-DatabaseName <string>]
  [<CommonParameters>]
```

### SqlConnection

```
Get-LSPrimaryDatabase
  -SqlConnection <SqlConnection>
  [-DatabaseName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieve log shipping databases for primary role.

## EXAMPLES

### Example 1

```powershell
Get-LSPrimaryDatabase -ServerInstance .
```

List all log shipping primary databases on local server.

### Example 2

```powershell
Get-LSPrimaryDatabase -ServerInstance . -DatabaseName AdventureWorks
```

List log shipping primary database AdventureWorks on local server.

### Example 3

```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master
Get-LSPrimaryDatabase -SqlConnection $SqlConnection -DatabaseName AdventureWorks
```

List log shipping primary database AdventureWorks using the specified sql connection.

## PARAMETERS

### -DatabaseName

Specifies the name of the database to return.

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

### SqlServerMaintenance.SqlLogShippingPrimary



## NOTES




## RELATED LINKS

None.

