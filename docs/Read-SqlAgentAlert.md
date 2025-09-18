---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Read-SqlAgentAlert
---

# Read-SqlAgentAlert

## SYNOPSIS

Retrieves SQL Agent alerts and sends email alerts.

## SYNTAX

### ServerInstance (Default)

```
Read-SqlAgentAlert
  -ServerInstance <string>
  [-Filter <string>]
  [<CommonParameters>]
```

### SqlConnection

```
Read-SqlAgentAlert
  -SqlConnection <SqlConnection>
  [-Filter <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieves SQL Agent alerts and sends email alerts.

## EXAMPLES

### EXAMPLE 1

Read-SqlAgentAlert -ServerInstance .

Gathers Sql Agent alerts on local server.

### EXAMPLE 2

$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Read-SqlAgentAlert -SqlConnection $SqlConnection

Gathers Sql Agent alerts using the specified sql connection.

## PARAMETERS

### -Filter

Specifies a filter to apply.
The filterable columns are: SQLAgentAlertEventID, EventDateTime, ComputerName, ServerName, InstanceName, SQLServerInstance, ErrorNumber, Severity, ClientIPAddress, and MessageText.

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

Specifies the name of a SQL Server instance.
This server instance becomes the target for the SQL agent alerts.

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

### System.Data.DataTable



## NOTES




## RELATED LINKS

None.

