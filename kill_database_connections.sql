USE master;
GO

-- Variables / initialisation
DECLARE @compatabilityLevel	int;
DECLARE @severity			int;
DECLARE @state				int;

SELECT @compatabilityLevel = d.[compatibility_level]
FROM sys.databases d
WHERE d.database_id = DB_ID();

SET @severity = 15;
SET @state = 1;

-- Safety checks
IF (@compatabilityLevel NOT IN (90, 100, 110))
	GOTO SPError_DatabaseCompatabilityLevel;

-- ====================================================================================================
DECLARE @database nvarchar(max);
DECLARE @sql nvarchar(max);

SET @database = N'<TODO: Add database name here>';

-- Set database to single user mode (killing any connections in the process)
SET @sql =  N'ALTER DATABASE ' + @database + N' SET SINGLE_USER WITH ROLLBACK IMMEDIATE';
EXEC sp_executesql @stmt = @sql;

-- Set database to multi-user mode
SET @sql = N'ALTER DATABASE ' + @database + N' SET MULTI_USER';
EXEC sp_executesql @stmt = @sql;
-- ====================================================================================================

GOTO SPEnd;

SPError_DatabaseCompatabilityLevel:
	RAISERROR('The database compatalibity level (version) is not compatible with this script!', @severity , @state);
	GOTO SPEnd;

SPEnd:
    PRINT 'Script has completed!';
	RETURN;