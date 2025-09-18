---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-DatabasePrimaryFile
---

# Get-DatabasePrimaryFile

## SYNOPSIS

Retrieves database information from SQL database MDF data file.

## SYNTAX

### ServerInstance (Default)

```
Get-DatabasePrimaryFile
  -ServerInstance <string>
  -MDFPath <FileInfo>
  [<CommonParameters>]
```

### SqlConnection

```
Get-DatabasePrimaryFile
  -SqlConnection <SqlConnection>
  -MDFPath <FileInfo>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieves database information from SQL database MDF data file, including original database name, database version, and logical file information.

## EXAMPLES

### Example 1

Get-DatabasePrimaryFile -ServerInstance . -MDFPath C:\MyData\database.mdf

Returns database information for the C:\MyData\database.mdf data file on local server.

### Example 2

$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-DatabasePrimaryFile -SqlConnection $SqlConnection -MDFPath C:\MyData\database.mdf

Returns database information for the C:\MyData\database.mdf data file using the specified sql connection.

## PARAMETERS

### -MDFPath

Path for SQL database MDF file.

```yaml
Type: System.IO.FileInfo
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

SQL Server host name and instance name.

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

### SqlServerMaintenance.DatabasePrimaryFile



## NOTES




## RELATED LINKS

None.

