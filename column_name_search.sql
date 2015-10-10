-- Specify column search pattern
DECLARE @pattern nvarchar(max) = '<TODO: Add search string here>';

-- Search for columns matching pattern
SELECT
	s.[name] AS [schema]
	, t.[name] AS [table]
	, c.[name] AS [column]
FROM sys.schemas s
JOIN sys.tables t ON (s.[schema_id] = t.[schema_id])
JOIN sys.columns c ON (t.[object_id] = c.[object_id])
WHERE c.[name] LIKE @pattern
ORDER BY
    s.[name]
    , t.[name]
    , c.[name];
GO