---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Resize-DatabaseTransactionLog

## SYNOPSIS
Resize transaction log.

## SYNTAX

### ServerInstance (Default)
```
Resize-DatabaseTransactionLog
	-ServerInstance <String>
	-DatabaseName <String>
	-LogFileSize <Int32>
	[-ShrinkMethod <ShrinkMethod>]
	[-TransactionLogBackupInterval <Int16>]
	[<CommonParameters>]
```

### SmoServer
```
Resize-DatabaseTransactionLog
	-SmoServerObject <Server>
	-DatabaseName <String>
	-LogFileSize <Int32>
	[-ShrinkMethod <ShrinkMethod>]
	[-TransactionLogBackupInterval <Int16>]
	[<CommonParameters>]
```

## DESCRIPTION
Resizes transaction log to specified size.
Transaction log may not be sized to exact size specified due to VLF boundaries.

## EXAMPLES

### EXAMPLE 1
```powershell
Resize-DatabaseTransactionLog -ServerInstance . -DatabaseName AdventureWorks -LogFileSize 1024
```

Resize transaction log file to 1024MB.

### EXAMPLE 2
```powershell
$SmoServer = Connect-SmoServer -ServerInstance MyServer

Resize-DatabaseTransactionLog -SmoServerObject $SmoServer -DatabaseName AdventureWorks -LogFileSize 1024
```

Resize transaction log file to 1024MB using the specified Smo session.

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

### -LogFileSize
Size in megabytes to resize transaction log to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
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
Parameter Sets: SmoServer
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TransactionLogBackupInterval
Interval in minutes between transaction log backups.

```yaml
Type: Int16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 15
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
