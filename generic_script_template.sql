-- Constants
DECLARE @database nvarchar(max) = DB_NAME();
DECLARE @severity int = 15;
DECLARE @state int = 1;

-- Safety checks
IF (@database  IN ('master', 'tempdb', 'model', 'msdb'))
    GOTO SPError_SystemDatabase;

IF (@database  LIKE ('ReportServer$%'))
    GOTO SPError_ReportingDatabase;

-- Script Body
-- <SCRIPT GOES HERE!!!>

-- End of script
GOTO SPEnd;

SPError_SystemDatabase:
    RAISERROR('Script should not be run on a system database!', @severity , @state);
    GOTO SPEnd;

SPError_ReportingDatabase:
    RAISERROR('Script should not be run on a report server database!', @severity , @state);
    GOTO SPEnd;

SPEnd:
    PRINT 'Script has completed!';
	RETURN;