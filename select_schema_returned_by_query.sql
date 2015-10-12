-- Variables / initialisation
DECLARE @database				nvarchar(max) = DB_NAME();
DECLARE @compatabilityLevel		int
DECLARE @severity				int = 15;
DECLARE @state					int = 1;

SELECT @compatabilityLevel = d.[compatibility_level]
FROM sys.databases d
WHERE d.database_id = DB_ID();

-- Safety checks
IF (@database  IN ('master', 'tempdb', 'model', 'msdb'))
    GOTO SPError_SystemDatabase;

IF (@database  LIKE ('ReportServer$%'))
    GOTO SPError_ReportingDatabase;

IF (@compatabilityLevel NOT IN (110))
	GOTO SPError_DatabaseCompatabilityLevel;

-- ====================================================================================================

DECLARE @tsql nvarchar(max) = '<TODO: Specify SQL whose schema you wish to check here!>';
DECLARE @params nvarchar(max) = NULL;
DECLARE @browse_information_mode tinyint = 0;

SELECT * FROM sys.dm_exec_describe_first_result_set(@tsql, @params, @browse_information_mode);

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