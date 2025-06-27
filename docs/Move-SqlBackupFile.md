---
external help file: SqlServerMaintenance-help.xml
Module Name: SqlServerMaintenance
online version:
schema: 2.0.0
---

# Move-SqlBackupFile

## SYNOPSIS
Move SQL backup files to new location.

## SYNTAX

```
Move-SqlBackupFile
	-SourcePath <DirectoryInfo>
	-DestinationPath <DirectoryInfo>
	[-FileAge <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Move SQL backup files to new location.

## EXAMPLES

### EXAMPLE 1
```powershell
Move-SqlBackupFile -SourcePath C:\SqlBackups -DestinationPath D:\SqlBackups
```

Moves SQL backup files from C:\SqlBackups to D:\SqlBackups.

## PARAMETERS

### -DestinationPath
Specifies the destination path.

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

### -FileAge
Age of file in minutes to move.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourcePath
Specifies the source path.

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

### System.Void

## NOTES

## RELATED LINKS
