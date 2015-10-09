DECLARE @errorMessage nvarchar(max);

-- Check we are not in a 'system' database
IF DB_NAME() IN ('master', 'model', 'msdb', 'tempdb')
BEGIN
	SET @errorMessage = 'This script should not be run on a system database';
	GOTO SPEnd;
END

-- Check database version is a compatible level
DECLARE @compatabilityLevel int;

SELECT @compatabilityLevel = d.[compatibility_level]
FROM sys.databases d
WHERE d.database_id = DB_ID();

IF @compatabilityLevel NOT IN (110)
BEGIN
	SET @errorMessage = 'The compatability level of this database (' + @compatabilityLevel + ') is not compatible with this script';
	GOTO SPEnd;
END

-- Start of script

-- SCRIPT GOES HERE!!!

-- End of script

SPEnd:

IF ISNULL(@errorMessage, '') <> ''
	RAISERROR(@errorMessage, 15, 1);

RETURN;

