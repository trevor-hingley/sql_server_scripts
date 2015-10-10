-- Run script from master
USE master;
GO

DECLARE @database nvarchar(max) = N'<TODO: Add database name here>';
DECLARE @sql nvarchar(max);

-- Set database to single user mode (killing any connections in the process)
SET @sql =  N'ALTER DATABASE ' + @database + N'SET SINGLE_USER WITH ROLLBACK IMMEDIATE';
EXEC sp_executesql @stmt = @sql;

-- Set database to multi-user mode
SET @sql = N'ALTER DATABASE ' + @database + N'SET MULTI_USER';
EXEC sp_executesql @stmt = @sql;
GO