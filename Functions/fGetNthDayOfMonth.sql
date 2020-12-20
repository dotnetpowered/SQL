CREATE FUNCTION [dbo].[fGetNthDayOfMonth](@dt Date, @nth tinyint, @dow tinyint)  
RETURNS Date   
AS   
-- Returns the @nth @dow (day of week) for a given month containing @dt  
BEGIN 
	declare @first Datetime -- First of the month of interest 
	declare @weekDt Datetime
	declare @result Date
	set @first = DATEFROMPARTS(YEAR(@dt), MONTH(@dt), 1)
			-- SQL2008 CAST(CONVERT(VARCHAR, YEAR(@dt))+'-'+CONVERT(VARCHAR,MONTH(@dt)) + '-1' AS DATETIME)
			-- SQL2016 DATEFROMPARTS(YEAR(@dt), MONTH(@dt), 1)
	set @weekDt = @first + 7*(@nth-1)
	select  @result = @weekDt + (7 + @dow - datepart(weekday,@weekDt))%7
	RETURN @result
END
