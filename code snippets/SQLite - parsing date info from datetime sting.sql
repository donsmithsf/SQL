#SQLite

#Background
##SQlite is pretty different than other RDBMS : It doesn't have a date/time type. You can only store dates as numbers or text.
##The function strftime() is able to extract date/time info from a date stored in a text column, but it only works if you respect the ISO8601 notation: YYYY-MM-DD HH:MM:SS.SSS , which is not the case with your date.
##Source: https://stackoverflow.com/questions/63691498/how-to-use-strftime-function-in-sqlite-for-extracting-year-where-datetime-is-i


#Pulling from a data/time string,cConverting numerical representations of months to their English equivilents 

SELECT 
  CASE CAST (strftime('%m', COLUMN_NAME) AS integer)
  #Covert numerical representation of months to text
  WHEN 1 then 'January'
  WHEN 2 then 'February'
  WHEN 3 then 'March'
  WHEN 4 then 'April'
  WHEN 5 then 'May'
  WHEN 6 then 'June'
  WHEN 7 then 'July'
  WHEN 8 then 'August'
  WHEN 9 then 'September'
  WHEN 10 then 'October'
  WHEN 11 then 'November'
  ELSE 'December'END AS "Month"
FROM TABLE_NAME;

------------------------------------------------------------

#Pull days of the week from datetime data
#Determine the day of the week each date falls on

SELECT
  CASE CAST (strftime('%w', COLUMN_NAME) AS integer)
  #Assigns a number from 0-6 which corresponds to a day of week
  WHEN 0 then 'Sunday'
  WHEN 1 then 'Monday'
  WHEN 2 then 'Tuesday'
  WHEN 3 then 'Wednesday'
  WHEN 4 then 'Thursday'
  WHEN 5 then 'Friday'
  ELSE 'Saturday' END AS weekday
FROM TABLE_NAME;
