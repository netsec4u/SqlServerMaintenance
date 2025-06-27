---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Resize-DatabaseLogicalFile

## SYNOPSIS
Resize database data file.

## SYNTAX

### LogicalFile-ServerInstance (Default)
```
Resize-DatabaseLogicalFile
	-ServerInstance <String>
	-DatabaseName <String>
	-LogicalFileName <String>
	-LogicalFileSize <Int32>
	[-ShrinkMethod <ShrinkMethod>]
	[<CommonParameters>]
```

### FileGroup-ServerInstance
```
Resize-DatabaseLogicalFile
	-ServerInstance <String>
	-DatabaseName <String>
	-FileGroupName <String>
	-LogicalFileSize <Int32>
	[-ShrinkMethod <ShrinkMethod>]
	[<CommonParameters>]
```

### LogicalFile-SmoServer
```
Resize-DatabaseLogicalFile
	-SmoServerObject <Server>
	-DatabaseName <String>
	-LogicalFileName <String>
	-LogicalFileSize <Int32>
	[-ShrinkMethod <ShrinkMethod>]
	[<CommonParameters>]
```

### FileGroup-SmoServer
```
Resize-DatabaseLogicalFile
	-SmoServerObject <Server>
	-DatabaseName <String>
	-FileGroupName <String>
	-LogicalFileSize <Int32>
	[-ShrinkMethod <ShrinkMethod>]
	[<CommonParameters>]
```

## DESCRIPTION
Resize database data file to specified size.

## EXAMPLES

### EXAMPLE 1
```powershell
Resize-DatabaseLogicalFile -ServerInstance . -DatabaseName AdventureWorks -FileGroupName PRIMARY -LogicalFileSize 1024
```

Resize files within file group PRIMARY to 1024MB.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Resize-DatabaseLogicalFile -SmoServerObject $SmoServer -DatabaseName AdventureWorks -FileGroupName PRIMARY -LogicalFileSize 1024
```

Resize files within file group PRIMARY to 1024MB using the specified Smo session.

### EXAMPLE 3
```powershell
Resize-DatabaseLogicalFile -ServerInstance . -DatabaseName AdventureWorks -LogicalFileName PRIMARY -LogicalFileSize 1024
```

Resize logical file PRIMARY to 1024MB.

### EXAMPLE 4
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Resize-DatabaseLogicalFile -SmoServerObject $SmoServer -DatabaseName AdventureWorks -LogicalFileName PRIMARY -LogicalFileSize 1024
```

Resize logical file PRIMARY to 1024MB using the specified Smo session.

## PARAMETERS

### -DatabaseName
Specifies the name of the database to evaluate log file growth rate.

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

### -FileGroupName
Name of file group to resize logical files.

```yaml
Type: String
Parameter Sets: FileGroup-ServerInstance, FileGroup-SmoServer
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicalFileName
Name of logical file to resize.

```yaml
Type: String
Parameter Sets: LogicalFile-ServerInstance, LogicalFile-SmoServer
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicalFileSize
Size in megabytes to resize logical file to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.

```yaml
Type: String
Parameter Sets: LogicalFile-ServerInstance, FileGroup-ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShrinkMethod
Shrink method to use.

```yaml
Type: ShrinkMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, NoTruncate, TruncateOnly, EmptyFile

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmoServerObject
Specifies SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: LogicalFile-SmoServer, FileGroup-SmoServer
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

### System.Void

## NOTES

## RELATED LINKS
