---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Resize-DatabaseLogicalFile
---

# Resize-DatabaseLogicalFile

## SYNOPSIS

Resize database data file to specified size.

## SYNTAX

### LogicalFile-ServerInstance (Default)

```
Resize-DatabaseLogicalFile
  -ServerInstance <string>
  -DatabaseName <string>
  -LogicalFileName <string>
  -LogicalFileSize <int>
  [-ShrinkMethod <ShrinkMethod>]
  [<CommonParameters>]
```

### FileGroup-ServerInstance

```
Resize-DatabaseLogicalFile
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  -LogicalFileSize <int>
  [-ShrinkMethod <ShrinkMethod>]
  [<CommonParameters>]
```

### LogicalFile-SmoServer

```
Resize-DatabaseLogicalFile
  -SmoServerObject <Server>
  -DatabaseName <string>
  -LogicalFileName <string>
  -LogicalFileSize <int>
  [-ShrinkMethod <ShrinkMethod>]
  [<CommonParameters>]
```

### FileGroup-SmoServer

```
Resize-DatabaseLogicalFile
  -SmoServerObject <Server>
  -DatabaseName <string>
  -FileGroupName <string>
  -LogicalFileSize <int>
  [-ShrinkMethod <ShrinkMethod>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Resize database data file to specified size.

## EXAMPLES

### Example 1

```powershell
Resize-DatabaseLogicalFile -ServerInstance . -DatabaseName AdventureWorks -FileGroupName PRIMARY -LogicalFileSize 1024
```

Resize files within file group PRIMARY to 1024MB.

### Example 2

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Resize-DatabaseLogicalFile -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName PRIMARY -LogicalFileSize 1024
```

Resize files within file group PRIMARY to 1024MB using the specified Smo session.

### Example 3

```powershell
Resize-DatabaseLogicalFile -ServerInstance . -DatabaseName AdventureWorks -LogicalFileName PRIMARY -LogicalFileSize 1024
```

Resize logical file PRIMARY to 1024MB.

### Example 4

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Resize-DatabaseLogicalFile -SmoServerObject $SmoServer -DatabaseName AdventureWorks -LogicalFileName PRIMARY -LogicalFileSize 1024
```

Resize logical file PRIMARY to 1024MB using the specified Smo session.

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
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FileGroupName

Name of file group to resize logical files.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FileGroup-SmoServer
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FileGroup-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -LogicalFileName

Name of logical file to resize.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: LogicalFile-SmoServer
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: LogicalFile-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -LogicalFileSize

Size in megabytes to resize logical file to.

```yaml
Type: System.Int32
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

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: LogicalFile-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FileGroup-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ShrinkMethod

Shrink method to use.

```yaml
Type: Microsoft.SqlServer.Management.Smo.ShrinkMethod
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

### -SmoServerObject

An existing SMO Server object representing the SQL Server instance.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: LogicalFile-SmoServer
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FileGroup-SmoServer
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

### System.Void



## NOTES




## RELATED LINKS

None.

