-- Variables / initialisation
DECLARE @compatabilityLevel	int
DECLARE @database			nvarchar(max);
DECLARE @severity			int;
DECLARE @state				int;

SELECT @compatabilityLevel = d.[compatibility_level]
FROM sys.databases d
WHERE d.database_id = DB_ID();

SET @database = DB_NAME();
SET @severity = 15;
SET @state = 1;

-- Safety checks
IF (@database IN ('master', 'tempdb', 'model', 'msdb'))
    GOTO SPError_SystemDatabase;

IF (@database LIKE ('ReportServer$%'))
    GOTO SPError_ReportingDatabase;

IF (@compatabilityLevel NOT IN (90, 100, 110))
	GOTO SPError_DatabaseCompatabilityLevel;

-- ====================================================================================================
-- SCRIPT START
-- ====================================================================================================
DECLARE @databaseID int;

SET @databaseID = DB_ID();

-- A) CLEAR DATA CACHE

-- This forces all dirty pages for the current database to be written to disk and cleans the buffers.
CHECKPOINT;

-- This removes all clean buffers from the buffer pool.
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS;

-- B) CLEAR THE PLAN CACHE

-- This flushes the plan cache for the database whose id is stored in @databaseID.
DBCC FLUSHPROCINDB (@databaseID) WITH NO_INFOMSGS;
-- ====================================================================================================
-- SCRIPT END
-- ====================================================================================================

GOTO SPEnd;

SPError_SystemDatabase:
    RAISERROR('Script should not be run on a system database!', @severity , @state);
    GOTO SPEnd;

SPError_ReportingDatabase:
    RAISERROR('Script should not be run on a report server database!', @severity , @state);
    GOTO SPEnd;

SPError_DatabaseCompatabilityLevel:
	RAISERROR('The database compatalibity level (version) is not compatible with this script!', @severity , @state);
	GOTO SPEnd;

SPEnd:
    PRINT 'Script has completed!';
	RETURN;
