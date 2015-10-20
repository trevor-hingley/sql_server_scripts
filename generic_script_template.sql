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
-- <SCRIPT GOES HERE!!!>
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
