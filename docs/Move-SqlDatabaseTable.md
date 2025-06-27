---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Move-SqlDatabaseTable

## SYNOPSIS
Move database objects to a specified filegroup.

## SYNTAX

### ServerInstance (Default)
```
Move-SqlDatabaseTable
	-ServerInstance <String>
	-DatabaseName <String>
	-FileGroupName <String>
	[-SchemaName <String>]
	[-TableName <String>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### ServerInstance_Table
```
Move-SqlDatabaseTable
	-ServerInstance <String>
	-DatabaseName <String>
	-FileGroupName <String>
	-SchemaName <String>
	-TableName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### ServerInstance_Index
```
Move-SqlDatabaseTable
	-ServerInstance <String>
	-DatabaseName <String>
	-FileGroupName <String>
	-SchemaName <String>
	-TableName <String>
	-IndexName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject_Table
```
Move-SqlDatabaseTable
	-SmoServerObject <Server>
	-DatabaseName <String>
	-FileGroupName <String>
	-SchemaName <String>
	-TableName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject_Index
```
Move-SqlDatabaseTable
	-SmoServerObject <Server>
	-DatabaseName <String>
	-FileGroupName <String>
	-SchemaName <String>
	-TableName <String>
	-IndexName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Move-SqlDatabaseTable
	-SmoServerObject <Server>
	-DatabaseName <String>
	-FileGroupName <String>
	[-SchemaName <String>]
	[-TableName <String>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Move database tables and indexes to a specified filegroup.

## EXAMPLES

### Example 1
```powershell
Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup
```

Moves all tables and indexes to the NewFilegroup filegroup.

### Example 2
```powershell
Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo
```

Moves all tables and indexes within the dbo schema to the NewFilegroup filegroup.

### Example 3
```powershell
Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users
```

Moves the table dbo.Users and all indexes on this table to the NewFilegroup filegroup.

### Example 4
```powershell
Move-SqlDatabaseTable -ServerInstance MySQLInstance -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users -IndexName IX_Username
```

Moves the index IX_Username index on the dbo.Users table to the NewFilegroup filegroup.

### Example 5
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup
```

Moves all tables and indexes to the NewFilegroup filegroup using SmoServer object.

### Example 6
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo
```

Moves all tables and indexes within the dbo schema to the NewFilegroup filegroup using SmoServer object.

### Example 7
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users
```

Moves the table dbo.Users and all indexes on this table to the NewFilegroup filegroup using SmoServer object.

### Example 8
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Move-SqlDatabaseTable -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName NewFilegroup -SchemaName dbo -TableName Users -IndexName IX_Username
```

Moves the index IX_Username index on the dbo.Users table to the NewFilegroup filegroup using SmoServer object.

## PARAMETERS

### -DatabaseName
Specifies the name of the database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileGroupName
Name of file group to move database objects to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IndexName
Specifies the name of the index to move.

```yaml
Type: String
Parameter Sets: ServerInstance_Index, SmoServerObject_Index
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaName
Specifies Schema to move to another filegroup.

```yaml
Type: String
Parameter Sets: ServerInstance, SmoServerObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ServerInstance_Table, ServerInstance_Index, SmoServerObject_Table, SmoServerObject_Index
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.

```yaml
Type: String
Parameter Sets: ServerInstance, ServerInstance_Table, ServerInstance_Index
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmoServerObject
Specifies SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: SmoServerObject_Table, SmoServerObject_Index, SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableName
Specifies table to move to another filegroup.

```yaml
Type: String
Parameter Sets: ServerInstance, SmoServerObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ServerInstance_Table, ServerInstance_Index, SmoServerObject_Table, SmoServerObject_Index
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Void

## NOTES
To move heap table, specify table name only.

## RELATED LINKS
