---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Send-DatabaseMail
---

# Send-DatabaseMail

## SYNOPSIS

Send Email using SQL Server Database Mail.

## SYNTAX

### ServerInstance (Default)

```
Send-DatabaseMail
  -ServerInstance <string>
  -MailTo <mailaddress[]>
  -Subject <string> -Body <string>
  [-DatabaseMailProfileName <string>]
  [-MailFrom <mailaddress>]
  [-ReplyTo <mailaddress>]
  [-CarbonCopy <mailaddress[]>]
  [-BlindCarbonCopy <mailaddress[]>]
  [-BodyAsHtml]
  [-Priority <MailPriority>]
  [-Sensitivity <DbMailSensitivity>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnection

```
Send-DatabaseMail
  -SqlConnection <SqlConnection>
  -MailTo <mailaddress[]>
  -Subject <string>
  -Body <string>
  [-DatabaseMailProfileName <string>]
  [-MailFrom <mailaddress>]
  [-ReplyTo <mailaddress>]
  [-CarbonCopy <mailaddress[]>]
  [-BlindCarbonCopy <mailaddress[]>]
  [-BodyAsHtml]
  [-Priority <MailPriority>]
  [-Sensitivity <DbMailSensitivity>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Send Email using SQL Server Database Mail.

## EXAMPLES

### Example 1

Send-DatabaseMail -ServerInstance MyServer -MailTo 'john@contoso.com' -Subject 'Test message' -Body 'This is a test message.'

Sends email to john@contoso.com from MyServer.

### Example 2

$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Send-DatabaseMail -SqlConnection $SqlConnection -MailTo 'john@contoso.com' -Subject 'Test message' -Body 'This is a test message.'

Sends email to john@contoso.com from MyServer using the specified SQL Server connection.

## PARAMETERS

### -BlindCarbonCopy

Specifies the addresses to which the mail blind copy is sent.
Enter names (optional) and the email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress[]
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

### -Body

Specifies the body of the email message.

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

### -BodyAsHtml

Indicates that the value of the Body parameter contains HTML.

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

### -CarbonCopy

Specifies the addresses to which the mail copy is sent.
Enter names (optional) and the email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress[]
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

### -DatabaseMailProfileName

Specifies the name of the database mail profile.

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

### -MailFrom

Specifies the address from which the mail is sent.
Enter a name (optional) and email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress
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

### -MailTo

Specifies the addresses to which the mail is sent.
Enter names (optional) and the email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress[]
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

### -Priority

Specifies the priority of the email message.

```yaml
Type: System.Net.Mail.MailPriority
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

### -ReplyTo

Specifies the reply to address where replies will be sent.
Enter a name (optional) and email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress
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

### -Sensitivity

Specifies the sensitivity of the email message.

```yaml
Type: DbMailSensitivity
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

### -Subject

Specifies the subject of the email message.

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

### SqlServerMaintenance.DatabaseMailItem



## NOTES

The following parameters have not been implemented:

* @query

* @execute_query_database

* @attach_query_result_as_file

* @query_attachment_filename

* @query_result_header

* @query_result_width

* @query_result_separator

* @exclude_query_output

* @append_query_error

* @query_no_truncate

* @query_result_no_padding


## RELATED LINKS

None.

