---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Read-SqlAgentAlert

## SYNOPSIS
Retrieves SQL Agent alerts.

## SYNTAX

### ServerInstance (Default)
```
Read-SqlAgentAlert
	-ServerInstance <String>
	[-Filter <String>]
	[<CommonParameters>]
```

### SqlConnection
```
Read-SqlAgentAlert
	-SqlConnection <SqlConnection>
	[-Filter <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Retrieves SQL Agent alerts and sends email alerts.

## EXAMPLES

### EXAMPLE 1
```powershell
Read-SqlAgentAlert -ServerInstance .
```

Gathers Sql Agent alerts on local server.

### EXAMPLE 2
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Read-SqlAgentAlert -SqlConnection $SqlConnection
```

Gathers Sql Agent alerts using the specified sql connection.

## PARAMETERS

### -Filter
Specifies a filter to apply.
The filterable columns are: SQLAgentAlertEventID, EventDateTime, ComputerName, ServerName, InstanceName, SQLServerInstance, ErrorNumber, Severity, ClientIPAddress, and MessageText.

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

### -ServerInstance
Specifies the name of a SQL Server instance.
This server instance becomes the target for the SQL agent alerts.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Data.DataTable

## NOTES

## RELATED LINKS
