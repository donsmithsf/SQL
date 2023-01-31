#SQLite
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
FROM TABLE_NAME


#Bckground
##SQlite is pretty different than other RDBMS : It doesn't have a date/time type. You can only store dates as numbers or text.
##The function strftime() is able to extract date/time info from a date stored in a text column, but it only works if you respect the ISO8601 notation: YYYY-MM-DD HH:MM:SS.SSS , which is not the case with your date.
##Source: https://stackoverflow.com/questions/63691498/how-to-use-strftime-function-in-sqlite-for-extracting-year-where-datetime-is-i