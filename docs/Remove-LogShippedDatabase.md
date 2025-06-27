---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Remove-LogShippedDatabase

## SYNOPSIS
Remove database from log shipping.

## SYNTAX

### Default-ServerInstance (Default)
```
Remove-LogShippedDatabase
	-PrimaryServerInstance <String>
	-SecondaryServerInstance <String>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SetSecondaryWriteable-ServerInstance
```
Remove-LogShippedDatabase
	-PrimaryServerInstance <String>
	-SecondaryServerInstance <String>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-SetSecondaryWriteable]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DropSecondaryDatabase-ServerInstance
```
Remove-LogShippedDatabase
	-PrimaryServerInstance <String>
	-SecondaryServerInstance <String>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-DropSecondaryDatabase]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### ConfigurationOnly-ServerInstance
```
Remove-LogShippedDatabase
	-PrimaryServerInstance <String>
	-SecondaryServerInstance <String>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-ConfigurationOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SetSecondaryWriteable-SmoServerObject
```
Remove-LogShippedDatabase
	-PrimarySmoServerObject <Server>
	-SecondarySmoServerObject <Server>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-SetSecondaryWriteable]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DropSecondaryDatabase-SmoServerObject
```
Remove-LogShippedDatabase
	-PrimarySmoServerObject <Server>
	-SecondarySmoServerObject <Server>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-DropSecondaryDatabase]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### Default-SmoServerObject
```
Remove-LogShippedDatabase
	-PrimarySmoServerObject <Server>
	-SecondarySmoServerObject <Server>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### ConfigurationOnly-SmoServerObject
```
Remove-LogShippedDatabase
	-PrimarySmoServerObject <Server>
	-SecondarySmoServerObject <Server>
	-DatabaseName <String>
	[-AvailabilityGroupName <String>]
	[-ConfigurationOnly]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove database from log shipping.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks
```

Removes database AdventureWorks from log shipping on SQL server instance MySQLInstance.

### EXAMPLE 2
```powershell
$PrimarySmoServer = Connect-SmoServer -ServerInstance MyServer
$SecondarySmoServer = Connect-SmoServer -ServerInstance MySecondaryServer

Remove-LogShippedDatabase -PrimarySmoServerObject $PrimarySmoServer -SecondarySmoServerObject $SecondarySmoServer -DatabaseName AdventureWorks
```

Removes database AdventureWorks from log shipping using the specified Smo session.

### EXAMPLE 3
```powershell
Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks -SetSecondaryWriteable
```

Removes database AdventureWorks from log shipping on SQL server instance MySQLInstance and sets the secondary database on MyBackupInstance writable.

### EXAMPLE 4
```powershell
Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks -DropSecondaryDatabase
```

Removes database AdventureWorks from log shipping on SQL server instance MySQLInstance and drops the secondary database on MyBackupInstance.

### EXAMPLE 5
```powershell
Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks -ConfigurationOnly
```

Removes configuration only for database AdventureWorks from log shipping on SQL server instance MySQLInstance.

## PARAMETERS

### -AvailabilityGroupName
Availability Group name to remove log shipping database for secondary instance.

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
Remove log shipping configuration without establishing database on secondary instance.

```yaml
Type: SwitchParameter
Parameter Sets: ConfigurationOnly-ServerInstance, ConfigurationOnly-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Name of database to primary database for log shipping.

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

### -DropSecondaryDatabase
Drop secondary database.

```yaml
Type: SwitchParameter
Parameter Sets: DropSecondaryDatabase-ServerInstance, DropSecondaryDatabase-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryServerInstance
Primary SQL server instance to remove log shipping.

```yaml
Type: String
Parameter Sets: Default-ServerInstance, SetSecondaryWriteable-ServerInstance, DropSecondaryDatabase-ServerInstance, ConfigurationOnly-ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimarySmoServerObject
Primary SQL server SMO  Server Object to remove log shipping.

```yaml
Type: Server
Parameter Sets: SetSecondaryWriteable-SmoServerObject, DropSecondaryDatabase-SmoServerObject, Default-SmoServerObject, ConfigurationOnly-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondaryServerInstance
Secondary SQL server instance to remove log shipping.

```yaml
Type: String
Parameter Sets: Default-ServerInstance, SetSecondaryWriteable-ServerInstance, DropSecondaryDatabase-ServerInstance, ConfigurationOnly-ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondarySmoServerObject
Secondary SQL server SMO  Server Object to remove log shipping.

```yaml
Type: Server
Parameter Sets: SetSecondaryWriteable-SmoServerObject, DropSecondaryDatabase-SmoServerObject, Default-SmoServerObject, ConfigurationOnly-SmoServerObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetSecondaryWriteable
Set secondary database to a writable state.

```yaml
Type: SwitchParameter
Parameter Sets: SetSecondaryWriteable-ServerInstance, SetSecondaryWriteable-SmoServerObject
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

### System.Void

## NOTES

## RELATED LINKS
