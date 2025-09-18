---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Move-SqlDatabaseTable
---

# Move-SqlDatabaseTable

## SYNOPSIS

Move database objects to a specified filegroup.

## SYNTAX

### ServerInstance (Default)

```
Move-SqlDatabaseTable
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  [-SchemaName <string>]
  [-TableName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### ServerInstance_Table

```
Move-SqlDatabaseTable
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  -SchemaName <string>
  -TableName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### ServerInstance_Index

```
Move-SqlDatabaseTable
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  -SchemaName <string>
  -TableName <string>
  -IndexName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServerObject_Table

```
Move-SqlDatabaseTable
  -SmoServerObject <Server>
  -DatabaseName <string>
  -FileGroupName <string>
  -SchemaName <string>
  -TableName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServerObject_Index

```
Move-SqlDatabaseTable
  -SmoServerObject <Server>
  -DatabaseName <string>
  -FileGroupName <string>
  -SchemaName <string>
  -TableName <string>
  -IndexName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServerObject

```
Move-SqlDatabaseTable
  -SmoServerObject <Server>
  -DatabaseName <string>
  -FileGroupName <string>
  [-SchemaName <string>]
  [-TableName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Move database tables and indexes to a specified filegroup.

## EXAMPLES

### Example 1

Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup

Moves all tables and indexes to the NewFilegroup filegroup.

### Example 2

Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo

Moves all tables and indexes within the dbo schema to the NewFilegroup filegroup.

### Example 3

Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users

Moves the table dbo.Users and all indexes on this table to the NewFilegroup filegroup.

### Example 4

Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users -IndexName IX_Username

Moves the index IX_Username index on the dbo.Users table to the NewFilegroup filegroup.

### Example 5

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup

Moves all tables and indexes to the NewFilegroup filegroup using SmoServer object.

### Example 6

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo

Moves all tables and indexes within the dbo schema to the NewFilegroup filegroup using SmoServer object.

### Example 7

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users

Moves the table dbo.Users and all indexes on this table to the NewFilegroup filegroup using SmoServer object.

### Example 8

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users -IndexName IX_Username

Moves the index IX_Username index on the dbo.Users table to the NewFilegroup filegroup using SmoServer object.

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

Specifies the name of the database

```yaml
Type: System.String
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

### -FileGroupName

Name of file group to move database objects to.

```yaml
Type: System.String
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

### -IndexName

Specifies the name of the index to move.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerObject_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SchemaName

Specifies Schema to move to another filegroup.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerObject_Table
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_Table
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerObject_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerObject
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance
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
- Name: ServerInstance_Table
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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
- Name: SmoServerObject_Table
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerObject_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### -TableName

Specifies table to move to another filegroup.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerObject_Table
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_Table
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerObject_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_Index
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SmoServerObject
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance
  Position: Named
  IsRequired: false
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

To move heap table, specify table name only.


## RELATED LINKS

None.

