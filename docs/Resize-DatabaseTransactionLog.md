---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Resize-DatabaseTransactionLog
---

# Resize-DatabaseTransactionLog

## SYNOPSIS

Resizes transaction log to specified size.

## SYNTAX

### ServerInstance (Default)

```
Resize-DatabaseTransactionLog
  -ServerInstance <string>
  -DatabaseName <string>
  -LogFileSize <int>
  [-ShrinkMethod <ShrinkMethod>]
  [-TransactionLogBackupInterval <short>]
  [<CommonParameters>]
```

### SmoServer

```
Resize-DatabaseTransactionLog
  -SmoServerObject <Server>
  -DatabaseName <string>
  -LogFileSize <int>
  [-ShrinkMethod <ShrinkMethod>]
  [-TransactionLogBackupInterval <short>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Resizes transaction log to specified size.
Transaction log may not be sized to exact size specified due to VLF boundaries.

## EXAMPLES

### EXAMPLE 1

Resize-DatabaseTransactionLog -ServerInstance . -DatabaseName AdventureWorks -LogFileSize 1024

Resize transaction log file to 1024MB.

### EXAMPLE 2

$SmoServer = Connect-SmoServer -ServerInstance MyServer

Resize-DatabaseTransactionLog -SmoServerObject $SmoServer -DatabaseName AdventureWorks -LogFileSize 1024

Resize transaction log file to 1024MB using the specified Smo session.

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

### -LogFileSize

Size in megabytes to resize transaction log to.

```yaml
Type: System.Int32
DefaultValue: 0
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

Specifies SQL Server Management Object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServer
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TransactionLogBackupInterval

Interval in minutes between transaction log backups.

```yaml
Type: System.Int16
DefaultValue: 15
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

