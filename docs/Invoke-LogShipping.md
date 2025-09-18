---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-LogShipping
---

# Invoke-LogShipping

## SYNOPSIS

Perform Log Shipping backup, copy, or restore operation.

## SYNTAX

### ServerInstance (Default)

```
Invoke-LogShipping
  -ServerInstance <string>
  -LSOperation <LSOperation>
  [-DatabaseName <string[]>]
  [-Session <PSSession>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnection

```
Invoke-LogShipping
  -SqlConnection <SqlConnection>
  -LSOperation <LSOperation>
  [-DatabaseName <string[]>]
  [-Session <PSSession>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Perform Log Shipping backup, copy, or restore operation.

## EXAMPLES

### EXAMPLE 1

Invoke-LogShipping -ServerInstance . -LSOperation Backup

Performs log ship backup for all database on local server.

### EXAMPLE 2

Invoke-LogShipping -ServerInstance . -DatabaseName AdventureWorks -LSOperation Backup

Performs log ship backup for database AdventureWorks on local server.

### EXAMPLE 3

Invoke-LogShipping -SqlConnection $SqlConnection -DatabaseName AdventureWorks

Performs log ship backup for database AdventureWorks using the specified Sql connection.

### EXAMPLE 4

$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Invoke-LogShipping -SqlConnection $SqlConnection -DatabaseName AdventureWorks -Session $PSSession

Performs log ship backup for database AdventureWorks using the specified Sql connection and execute within specified PSSession.

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

### -DatabaseName

Specifies the name of the database to back up.

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

### -LSOperation

Specifies the log shipping operation to invoke.

```yaml
Type: LSOperation
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
This server instance becomes the target of the backup operation.

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

### -Session

Specifies PS Session.

```yaml
Type: System.Management.Automation.Runspaces.PSSession
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

### System.Collections.Generic.List`1[[SqlServerMaintenance.SqlLogShip



### System.Collections.Generic.List`1[[SqlServerMaintenance.SqlLogShip, hsetbj5y.tnl, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null]]



## NOTES




## RELATED LINKS

None.

