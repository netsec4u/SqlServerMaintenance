---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-SqlInstanceIndexMaintenance
---

# Invoke-SqlInstanceIndexMaintenance

## SYNOPSIS

Perform index maintenance on all databases or a specified database.

## SYNTAX

### ServerInstance (Default)

```
Invoke-SqlInstanceIndexMaintenance
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [-RowCountThreshold <int>]
  [-IndexEvalMethod <IndexEvalMethod>]
  [-PageSpaceUsedThreshold <int>]
  [-ReorganizeThreshold <int>]
  [-RebuildThreshold <int>]
  [-Online]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServerObject

```
Invoke-SqlInstanceIndexMaintenance
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [-RowCountThreshold <int>]
  [-IndexEvalMethod <IndexEvalMethod>]
  [-PageSpaceUsedThreshold <int>]
  [-ReorganizeThreshold <int>]
  [-RebuildThreshold <int>]
  [-Online]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Perform index maintenance on all databases or a specified database.

## EXAMPLES

### Example 1

```powershell
Invoke-SqlInstanceIndexMaintenance -ServerInstance .
```

Performs index maintenance against all database on local server.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Invoke-SqlInstanceIndexMaintenance -SmoServerObject $SmoServer
```

Performs index maintenance against all database using the specified Smo session.

### Example 3

```powershell
Invoke-SqlInstanceIndexMaintenance -ServerInstance . -Database AdventureWorks
```

Performs index maintenance against database AdventureWorks on local server.

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

Specifies the name of the database to perform index maintenance.

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

### -IndexEvalMethod

Specifies the index evaluation method for index maintenance.

```yaml
Type: IndexEvalMethod
DefaultValue: PageSpaceUsed
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

### -Online

Specifies that an index or an index partition of an underlying table can be rebuilt online.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PageSpaceUsedThreshold

Specifies the page space used threshold to perform rebuild.

```yaml
Type: System.Int32
DefaultValue: 50
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

### -RebuildThreshold

Specifies the average fragmentation level to perform a rebuild.

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

### -ReorganizeThreshold

Specifies the average fragmentation level to perform a reorganize.

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

### -RowCountThreshold

Specifies the number of row in a table to evaluate index fragmentation.

```yaml
Type: System.Int32
DefaultValue: 1024
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

### SqlServerMaintenance.Index



## NOTES

Reorganize will not occur when:
  - Primary key column contains unique identifier column and does not contain a LOB datatype.
	- Page lock is off.

Clustered Indexes
  - For GUIDs, fill factor should be:
    - 90% for table larger than 10GB
    - Use 70 or 80 for smaller tables
  - For integer based key
    - Use 100% fill factor

To return page density to fill factor, a rebuild must be performed.
Reorg must be performed to compress LOBs ??? Verify


## RELATED LINKS

None.

