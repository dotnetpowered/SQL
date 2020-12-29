-- Based on https://www.sqlshack.com/how-to-resolve-deadlocks-in-sql-server/

DECLARE @xelfilepath NVARCHAR(260)
SELECT @xelfilepath = dosdlc.path + N'system_health_*.xel'
FROM sys.dm_os_server_diagnostics_log_configurations AS dosdlc;

SELECT 
	EventData.value('(event/@timestamp)[1]', 'datetime2(7)') AS UtcTime, 
    CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET, 
  EventData.value('(event/@timestamp)[1]', 'VARCHAR(50)')), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS LocalTime, 
  EventData.query('event/data/value/deadlock') AS XmlDeadlockReport
FROM 
	(SELECT CONVERT(XML, event_data) AS EventData
	 FROM sys.fn_xe_file_target_read_file(@xelfilepath, NULL, NULL, NULL)
	 WHERE object_name = 'xml_deadlock_report') e
ORDER BY UtcTime DESC;
