---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Get-DatabasePrimaryFile

## SYNOPSIS
Retrieves database information from SQL database MDF data file.

## SYNTAX

### ServerInstance (Default)
```
Get-DatabasePrimaryFile
	-ServerInstance <String>
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

## DESCRIPTION
Retrieves database information from SQL database MDF data file, including original database name, database version, and logical file information.

## EXAMPLES

### Example 1
```powershell
Get-DatabasePrimaryFile -ServerInstance . -MDFPath C:\MyData\database.mdf
```

Returns database information for the C:\MyData\database.mdf data file on local server.

### Example 2
```powershell
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName master

Get-DatabasePrimaryFile -SqlConnection $SqlConnection -MDFPath C:\MyData\database.mdf
```

Returns database information for the C:\MyData\database.mdf data file using the specified sql connection.

## PARAMETERS

### -MDFPath
Path for SQL database MDF file.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
SQL Server host name and instance name.

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

### SqlServerMaintenance.DatabasePrimaryFile

## NOTES

## RELATED LINKS
