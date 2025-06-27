---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Send-DatabaseMail

## SYNOPSIS
Send Email using SQL Server Database Mail.

## SYNTAX

### ServerInstance (Default)
```
Send-DatabaseMail
	-ServerInstance <String>
	[-DatabaseMailProfileName <String>]
	[-MailFrom <MailAddress>]
	-MailTo <MailAddress[]>
	[-ReplyTo <MailAddress>]
	[-CarbonCopy <MailAddress[]>]
	[-BlindCarbonCopy <MailAddress[]>]
	-Subject <String>
	-Body <String>
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
	[-DatabaseMailProfileName <String>]
	[-MailFrom <MailAddress>]
	-MailTo <MailAddress[]>
	[-ReplyTo <MailAddress>]
	[-CarbonCopy <MailAddress[]>]
	[-BlindCarbonCopy <MailAddress[]>]
	-Subject <String>
	-Body <String>
	[-BodyAsHtml]
	[-Priority <MailPriority>]
	[-Sensitivity <DbMailSensitivity>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Send Email using SQL Server Database Mail.

## EXAMPLES

### Example 1
```powershell
Send-DatabaseMail -ServerInstance MyServer -MailTo 'john@contoso.com' -Subject 'Test message' -Body 'This is a test message.'
```

Sends email to john@contoso.com from MyServer.

### Example 2
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Send-DatabaseMail -SqlConnection $SqlConnection -MailTo 'john@contoso.com' -Subject 'Test message' -Body 'This is a test message.'
```

Sends email to john@contoso.com from MyServer using the specified SQL Server connection.

## PARAMETERS

### -BlindCarbonCopy
Specifies the addresses to which the mail blind copy is sent.
Enter names (optional) and the email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Specifies the body of the email message.

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

### -BodyAsHtml
Indicates that the value of the Body parameter contains HTML.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CarbonCopy
Specifies the addresses to which the mail copy is sent.
Enter names (optional) and the email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseMailProfileName
Specifies the name of the database mail profile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailFrom
Specifies the address from which the mail is sent.
Enter a name (optional) and email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailTo
Specifies the addresses to which the mail is sent.
Enter names (optional) and the email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
Specifies the priority of the email message.

```yaml
Type: MailPriority
Parameter Sets: (All)
Aliases:
Accepted values: Normal, Low, High

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReplyTo
Specifies the reply to address where replies will be sent.
Enter a name (optional) and email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sensitivity
Specifies the sensitivity of the email message.

```yaml
Type: DbMailSensitivity
Parameter Sets: (All)
Aliases:
Accepted values: Normal, Personal, Private, Confidential

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.

```yaml
Type: String
Parameter Sets: ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlConnection
Specifies SQL connection object.

```yaml
Type: SqlConnection
Parameter Sets: SqlConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Specifies the subject of the email message.

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
