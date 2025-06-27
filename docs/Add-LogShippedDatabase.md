---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Add-LogShippedDatabase

## SYNOPSIS
Add database to log shipping.

## SYNTAX

### ServerInstance (Default)
```
Add-LogShippedDatabase
	-PrimaryServerInstance <String>
	-SecondaryServerInstance <String>
	-DatabaseName <String[]>
	-StagingPath <DirectoryInfo>
	[-AvailabilityGroupName <String>]
	[-ConfigurationOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServerObject
```
Add-LogShippedDatabase
	-PrimarySmoServerObject <Server>
	-SecondarySmoServerObject <Server>
	-DatabaseName <String[]>
	-StagingPath <DirectoryInfo>
	[-AvailabilityGroupName <String>]
	[-ConfigurationOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Add database to log shipping.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks -StagingPath \\MyFileServer\Staging
```

Adds database AdventureWorks to log shipping on SQL server instance MySQLInstance to log ship to MyBackupInstance.

### EXAMPLE 2
```powershell
$PrimarySmoServer = Connect-SmoServer -ServerInstance MyServer
$SecondarySmoServer = Connect-SmoServer -ServerInstance MySecondaryServer

Add-LogShippedDatabase -PrimarySmoServerObject $PrimarySmoServer -SecondarySmoServerObject $SecondarySmoServer -DatabaseName AdventureWorks -StagingPath \\MyFileServer\Staging
```

Adds database AdventureWorks to log shipping by Smo Server connections.

## PARAMETERS

### -AvailabilityGroupName
Availability Secondary Group name to add log shipping database.

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

### -ConfigurationOnly
Add log shipping configuration without establishing database on secondary instance.

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

### -DatabaseName
Name of database to add to log shipping.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryServerInstance
Primary SQL server instance to setup log shipping.

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

### -PrimarySmoServerObject
Specifies SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondaryServerInstance
Secondary SQL server instance to setup log shipping.

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

### -SecondarySmoServerObject
Specifies SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StagingPath
Path to staging folder.

```yaml
Type: DirectoryInfo
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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
