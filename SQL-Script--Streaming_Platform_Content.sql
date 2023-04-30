USE tv_shows;

SELECT * FROM tv_shows
LIMIT 25;

# creating new unpivoted table
CREATE TABLE platforms AS
SELECT ID, Title, Year, Age, IMDb, Rotten_Tomatoes, 'Hulu' as Platform
FROM tv_shows
where Hulu <>0
UNION ALL
SELECT ID, Title, Year, Age, IMDb, Rotten_Tomatoes, 'Netflix' as Platform
FROM tv_shows
where Netflix <>0
UNION ALL
SELECT ID, Title, Year, Age, IMDb, Rotten_Tomatoes, 'Prime_Video' as Platform
FROM tv_shows
where Prime_Video <>0
UNION ALL
SELECT ID, Title, Year, Age, IMDb, Rotten_Tomatoes, 'Disney' as Platform
FROM tv_shows
where Disney <>0
ORDER BY ID;

# editing Year colum to only show the year
UPDATE platforms SET Year= Year(Year); 

# to update Age with a blank
UPDATE platforms SET Age= 'Other'
WHERE Age= ''; 

# to make capitalization consistent
UPDATE platforms SET Age= 'All'
WHERE Age= 'all'; 

# viewing new table 
SELECT * 
FROM platforms
LIMIT 25;

# Initial Questions
# Q1- Which streaming platform(s) can I find this tv show on?
SELECT Title, Platform
FROM platforms;

# Q2- Target age group tv shows vs the streaming application they can be found on
SELECT Title, Age, Platform
FROM platforms;

# Q3- The year during which a tv show was produced and the streaming platform they can be found on
SELECT Title, Year, Platform
FROM platforms;

# number of total shows
SELECT COUNT(DISTINCT ID)
FROM platforms;

# number of shows on each platform
SELECT Platform, COUNT(*)
FROM platforms
GROUP BY Platform;

# percentage of shows on each platform- by Age rating
SELECT Platform, 
	Age, 
	ROUND(count(*)/ sum(count(*)) OVER(PARTITION BY Platform) * 100, 2) AS Percentage
FROM platforms
GROUP BY Platform, Age
ORDER BY Platform;

# average rating by age on all platforms 
SELECT Platform, 
	Age,
	ROUND(AVG(CAST(SUBSTR(IMDb, 1, LOCATE("/", IMDb)-1) AS DECIMAL(4,2))), 2) AS avg_imdb,
	ROUND(AVG(CAST(SUBSTR(Rotten_Tomatoes, 1, LOCATE("/", Rotten_Tomatoes)-1) AS DECIMAL(5,2))), 2) AS avg_rt
FROM platforms
GROUP BY Platform, Age
ORDER BY Platform;

# highest rated years imdb
SELECT
	Year,
	ROUND(AVG(CAST(SUBSTR(IMDb, 1, LOCATE("/", IMDb)-1) AS DECIMAL(4,2))), 2) AS avg_imdb
FROM(
	SELECT DISTINCT ID, Year, IMDb
	FROM platforms) AS platforms
GROUP BY Year
ORDER BY avg_imdb DESC
LIMIT 5;

# highest rated years rotten tomatoes
SELECT
	Year,
	ROUND(AVG(CAST(SUBSTR(Rotten_Tomatoes, 1, LOCATE("/", Rotten_Tomatoes)-1) AS DECIMAL(5,2))), 2) AS avg_rt
FROM (
	SELECT DISTINCT ID, Year, Rotten_Tomatoes
	FROM platforms) AS platforms
GROUP BY Year
ORDER BY avg_rt DESC
LIMIT 5;
