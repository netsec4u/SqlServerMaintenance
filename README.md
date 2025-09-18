# SqlServerMaintenance

## Description

This module contains functions for SQL Server maintenance.  These include backups and restore of databases, index and statistics maintenance, and database integrity checks and more.

The features include:
- Server Hygiene
	- Cycle SQL Server Error Logs
	- Cycle Full Text Index Logs
	- Purge History
- Database Backup
	- Full Backup
	- Adaptive differential Backup
	- Transaction Log Backup
	- Backup retention
- Database Statistics
	- Database Statistics
	- Query Store Statistics
- Database Integrity
- Database Monitoring
	- Data Growth
- Database Optimization
	- Index Maintenance
	- Column Store Index Maintenance
	- Table Statistics Maintenance
	- Full Text Index Maintenance
- Miscellaneous
	- Database Snapshot
	- Log Shipping

## Support

This module has extensively been used within PowerShell on Windows connected to SQL Server 2012 to 2022 on Windows.  Limited testing has been performed within a PowerShell running on non-Windows operating systems or SQL Server on Linux.  Most functions should work as expected; however, I expect some issues to exist for functions that interact with the file system, such as Add-SmoDatabaseDataFile.
