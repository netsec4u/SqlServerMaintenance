# SqlServerMaintenance

## Description

This module contains functions for SQL Server maintenance.  These include backups and restore of databases, index and statistics maintenance, and database integrety checks and more.

## Support

This module has extensively been used within PowerShell on Windows connected to SQL Server 2012 to 2022 on Windows.  Limited testing has been performed within a PowerShell running on non-Windows operating systems or SQL Server on Linux.  Most functions should work as expected; however, I expect some issues to exist for functions that interact with the file system, such as Add-SmoDatabaseDataFile.
