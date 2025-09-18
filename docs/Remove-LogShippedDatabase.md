---
document type: cmdlet
external help file: SqlServerMaintenance-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Remove-LogShippedDatabase
---

# Remove-LogShippedDatabase

## SYNOPSIS

Remove database from log shipping.

## SYNTAX

### Default-ServerInstance (Default)

```
Remove-LogShippedDatabase
  -PrimaryServerInstance <string>
  -SecondaryServerInstance <string>
  -DatabaseName <string>
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SetSecondaryWriteable-ServerInstance

```
Remove-LogShippedDatabase
  -PrimaryServerInstance <string>
  -SecondaryServerInstance <string>
  -DatabaseName <string>
  -SetSecondaryWriteable
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DropSecondaryDatabase-ServerInstance

```
Remove-LogShippedDatabase
  -PrimaryServerInstance <string>
  -SecondaryServerInstance <string>
  -DatabaseName <string>
  -DropSecondaryDatabase
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### ConfigurationOnly-ServerInstance

```
Remove-LogShippedDatabase
  -PrimaryServerInstance <string>
  -SecondaryServerInstance <string>
  -DatabaseName <string>
  -ConfigurationOnly
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SetSecondaryWriteable-SmoServerObject

```
Remove-LogShippedDatabase
  -PrimarySmoServerObject <Server>
  -SecondarySmoServerObject <Server>
  -DatabaseName <string>
  -SetSecondaryWriteable
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DropSecondaryDatabase-SmoServerObject

```
Remove-LogShippedDatabase
  -PrimarySmoServerObject <Server>
  -SecondarySmoServerObject <Server>
  -DatabaseName <string>
  -DropSecondaryDatabase
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### Default-SmoServerObject

```
Remove-LogShippedDatabase
  -PrimarySmoServerObject <Server>
  -SecondarySmoServerObject <Server>
  -DatabaseName <string>
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### ConfigurationOnly-SmoServerObject

```
Remove-LogShippedDatabase
  -PrimarySmoServerObject <Server>
  -SecondarySmoServerObject <Server>
  -DatabaseName <string>
  -ConfigurationOnly
  [-AvailabilityGroupName <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Remove database from log shipping.

## EXAMPLES

### EXAMPLE 1

Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks

Removes database AdventureWorks from log shipping on SQL server instance MySQLInstance.

### EXAMPLE 2

$PrimarySmoServer = Connect-SmoServer -ServerInstance MyServer
$SecondarySmoServer = Connect-SmoServer -ServerInstance MySecondaryServer

Remove-LogShippedDatabase -PrimarySmoServerObject $PrimarySmoServer -SecondarySmoServerObject $SecondarySmoServer -DatabaseName AdventureWorks

Removes database AdventureWorks from log shipping using the specified Smo session.

### EXAMPLE 3

Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks -SetSecondaryWriteable

Removes database AdventureWorks from log shipping on SQL server instance MySQLInstance and sets the secondary database on MyBackupInstance writable.

### EXAMPLE 4

Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks -DropSecondaryDatabase

Removes database AdventureWorks from log shipping on SQL server instance MySQLInstance and drops the secondary database on MyBackupInstance.

### EXAMPLE 5

Remove-LogShippedDatabase -PrimaryServerInstance MySQLInstance -SecondaryServerInstance MyBackupInstance -DatabaseName AdventureWorks -ConfigurationOnly

Removes configuration only for database AdventureWorks from log shipping on SQL server instance MySQLInstance.

## PARAMETERS

### -AvailabilityGroupName

Availability Group name to remove log shipping database for secondary instance.

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

### -ConfigurationOnly

Remove log shipping configuration without establishing database on secondary instance.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ConfigurationOnly-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ConfigurationOnly-ServerInstance
  Position: Named
  IsRequired: true
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

### -DatabaseName

Name of database to primary database for log shipping.

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

### -DropSecondaryDatabase

Drop secondary database.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DropSecondaryDatabase-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DropSecondaryDatabase-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PrimaryServerInstance

Primary SQL server instance to remove log shipping.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SetSecondaryWriteable-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DropSecondaryDatabase-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ConfigurationOnly-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PrimarySmoServerObject

Primary SQL server SMO  Server Object to remove log shipping.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SetSecondaryWriteable-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DropSecondaryDatabase-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ConfigurationOnly-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SecondaryServerInstance

Secondary SQL server instance to remove log shipping.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SetSecondaryWriteable-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DropSecondaryDatabase-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ConfigurationOnly-ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SecondarySmoServerObject

Secondary SQL server SMO  Server Object to remove log shipping.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SetSecondaryWriteable-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DropSecondaryDatabase-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ConfigurationOnly-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SetSecondaryWriteable

Set secondary database to a writable state.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SetSecondaryWriteable-SmoServerObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SetSecondaryWriteable-ServerInstance
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

### System.Void



## NOTES




## RELATED LINKS

None.

