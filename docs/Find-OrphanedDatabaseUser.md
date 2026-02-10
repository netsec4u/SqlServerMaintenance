---
document type: cmdlet
external help file: SqlServerMaintenance-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerMaintenance
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Find-OrphanedDatabaseUser
---

# Find-OrphanedDatabaseUser

## SYNOPSIS

Find orphaned database users.

## SYNTAX

### ServerInstance (Default)

```
Find-OrphanedDatabaseUser
  -ServerInstance <string>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

### SmoServerObject

```
Find-OrphanedDatabaseUser
  -SmoServerObject <Server>
  [-DatabaseName <string[]>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Find orphaned database users.

## EXAMPLES

### Example 1

```powershell
Find-OrphanedDatabaseUser -ServerInstance MyServer
```

Finds orphaned database users for databases on MyServer.

### Example 2

```powershell
Find-OrphanedDatabaseUser -ServerInstance MyServer -DatabaseName AdventureWorks
```

Finds orphaned database users on database AdventureWorks.

### Example 3

```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer
Find-OrphanedDatabaseUser -SmoServerObject $SmoServer -DatabaseName AdventureWorks
```

Finds orphaned database users on database AdventureWorks.

## PARAMETERS

### -DatabaseName

Specifies the name of the database.

```yaml
Type: System.String[]
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

The name of the SQL Server instance to connect to.

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

### -SmoServerObject

An existing SMO Server object representing the SQL Server instance.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServerObject
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

### SqlServerMaintenance.OrphanedDatabaseUser



## NOTES




## RELATED LINKS

None.

