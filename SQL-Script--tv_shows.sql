USE tv_shows;

SELECT * FROM tv_shows;

# Initial Questions
# Q1- Which streaming platform(s) can I find this tv show on?
SELECT
	Title,
    CASE
		WHEN Netflix = 1 AND Hulu = 1 AND Prime_Video = 0 AND Disney = 0 THEN "On Netflix and Hulu"
        WHEN Netflix = 1 AND Prime_Video = 1 AND Hulu = 0 AND Disney = 0 THEN "On Netflix and Prime Video"
        WHEN Netflix = 1 AND Hulu = 1 AND Prime_Video = 1 AND Disney = 0 THEN "On Netflix, Hulu, and Prime Video"
        WHEN Hulu = 1 AND Prime_Video = 1 AND Netflix = 0 AND Disney = 0 THEN "On Hulu and Prime Video"
		WHEN Netflix = 1 AND Hulu = 0 AND Prime_Video = 0 AND Disney = 0 THEN "On Netflix"
        WHEN Hulu = 1 AND Netflix = 0 AND Prime_Video = 0 AND Disney = 0 THEN "On Hulu"
        WHEN Prime_video = 1 AND Netflix = 0 AND Hulu = 0 AND Disney = 0 THEN "On Prime Video"
        WHEN Disney = 1 AND Netflix = 0 AND Hulu = 0 AND Prime_Video = 0 THEN "On Disney"
        WHEN Disney = 1 AND Netflix = 1 AND Hulu = 1 AND Prime_Video = 1 THEN "On Disney, Netflix, Hulu, and Prime Video"
        WHEN Disney = 1 AND Netflix = 1 AND Hulu = 1 AND Prime_Video = 0 THEN "On Disney, Netflix, and Hulu"
        WHEN Disney = 1 AND Netflix = 1 AND Hulu = 0 AND Prime_Video = 0 THEN "On Disney and Netflix"
        WHEN Disney = 1 AND Netflix = 0 AND Hulu = 1 AND Prime_Video = 0 THEN "On Disney and Hulu"
        WHEN Disney = 1 AND Netflix = 0 AND Hulu = 0 AND Prime_Video = 1 THEN "On Disney and Prime Video"
        ELSE "On no platform"
	END AS "Platform"
FROM tv_shows;

# Q2- Target age group tv shows vs the streaming application they can be found on
# percentage of shows by age on all platforms- rounded to 2 decimal places- pie charts
# exported
WITH nrat AS (
	SELECT
		Age,
        ROUND(COUNT(*) / SUM(COUNT(*)) OVER() * 100, 2) AS perc_ageN
	FROM tv_shows
    WHERE Netflix = 1
    GROUP BY Age)
    , hrat AS (
	SELECT
		Age,
		ROUND(COUNT(*)/ SUM(COUNT(*)) OVER() * 100, 2) AS perc_ageH
	FROM tv_shows
	WHERE Hulu = 1
	GROUP BY Age)
    , pvrat AS (
    SELECT
		Age,
        ROUND(COUNT(*)/ SUM(COUNT(*)) OVER() * 100, 2) AS perc_agePV
	FROM tv_shows
    WHERE Prime_Video = 1
    GROUP BY age)

SELECT 
	nrat.Age,
    nrat.perc_ageN,
    hrat.perc_ageH,
    pvrat.perc_agePV
FROM nrat
LEFT JOIN hrat
ON nrat.Age = hrat.Age
LEFT JOIN pvrat
ON nrat.Age = pvrat.Age;

# Q3- The year during which a tv show was produced and the streaming platform they can be found on
SELECT
	Title,
    YEAR(Year),
    CASE
		WHEN Netflix = 1 AND Hulu = 1 AND Prime_Video = 0 AND Disney = 0 THEN "On Netflix and Hulu"
        WHEN Netflix = 1 AND Prime_Video = 1 AND Hulu = 0 AND Disney = 0 THEN "On Netflix and Prime Video"
        WHEN Netflix = 1 AND Hulu = 1 AND Prime_Video = 1 AND Disney = 0 THEN "On Netflix, Hulu, and Prime Video"
        WHEN Hulu = 1 AND Prime_Video = 1 AND Netflix = 0 AND Disney = 0 THEN "On Hulu and Prime Video"
		WHEN Netflix = 1 AND Hulu = 0 AND Prime_Video = 0 AND Disney = 0 THEN "On Netflix"
        WHEN Hulu = 1 AND Netflix = 0 AND Prime_Video = 0 AND Disney = 0 THEN "On Hulu"
        WHEN Prime_video = 1 AND Netflix = 0 AND Hulu = 0 AND Disney = 0 THEN "On Prime Video"
        WHEN Disney = 1 AND Netflix = 0 AND Hulu = 0 AND Prime_Video = 0 THEN "On Disney"
        WHEN Disney = 1 AND Netflix = 1 AND Hulu = 1 AND Prime_Video = 1 THEN "On Disney, Netflix, Hulu, and Prime Video"
        WHEN Disney = 1 AND Netflix = 1 AND Hulu = 1 AND Prime_Video = 0 THEN "On Disney, Netflix, and Hulu"
        WHEN Disney = 1 AND Netflix = 1 AND Hulu = 0 AND Prime_Video = 0 THEN "On Disney and Netflix"
        WHEN Disney = 1 AND Netflix = 0 AND Hulu = 1 AND Prime_Video = 0 THEN "On Disney and Hulu"
        WHEN Disney = 1 AND Netflix = 0 AND Hulu = 0 AND Prime_Video = 1 THEN "On Disney and Prime Video"
        ELSE "On no platform"
	END AS "Platform"
FROM tv_shows;

# total number of shows
SELECT DISTINCT COUNT(id) FROM tv_shows;

# number of shows on each platform - bar chart 
# exported
SELECT
	SUM(IF(Netflix = 1, 1, 0)) AS Net_shows,
    SUM(IF(Hulu = 1, 1, 0)) AS Hulu_shows,
    SUM(IF(Prime_Video = 1, 1, 0)) AS PV_shows
FROM tv_shows;

# year range
SELECT 
	COUNT(DISTINCT Year),
    MAX(Year),
    MIN(Year)
FROM tv_shows; 

# max, min AND avg ratings
WITH ratings AS (
	SELECT 
		Title,
		IMDb, 
		CAST(SUBSTR(IMDb, 1, LOCATE('/', IMDb)-1) AS DECIMAL(4,2)) AS new_imdb,
		CAST(SUBSTR(Rotten_Tomatoes, 1, LOCATE('/', Rotten_Tomatoes)-1) AS DECIMAL(5,2)) AS new_rt
	FROM tv_shows
)

SELECT 
    MAX(new_rt) AS max_rt,
    MIN(new_rt) AS min_rt,
    AVG(new_rt) AS avg_rt,
    MAX(new_imdb) AS max_imdb,
    MIN(new_imdb) AS min_imdb,
    AVG(new_imdb) AS avg_imdb
FROM ratings;

# average rating BY age on all platforms - bar chart 
# exported
WITH nrat AS (
	SELECT
		Age,
        ROUND(AVG(CAST(SUBSTR(IMDb, 1, LOCATE("/", IMDb)-1) AS DECIMAL(4,2))), 2) AS avg_imdbN,
        ROUND(AVG(cASt(SUBSTR(Rotten_Tomatoes, 1, LOCATE("/", Rotten_Tomatoes)-1) AS DECIMAL(5,2))), 2) AS avg_rtN
	FROM
		tv_shows
	WHERE Netflix = 1
    GROUP BY Age)
    , hrat AS (
    SELECT
		Age, 
        ROUND(AVG(CAST(SUBSTR(IMDb, 1, LOCATE("/", IMDb)-1) AS DECIMAL(4,2))), 2) AS avg_imdbH,
        ROUND(AVG(CAST(SUBSTR(Rotten_Tomatoes, 1, LOCATE("/", Rotten_Tomatoes)-1) AS DECIMAL(5,2))), 2) AS avg_rtH
	FROM
		tv_shows
	WHERE Hulu = 1
    GROUP BY Age)
    , pvrat AS(
    SELECT
		Age,
        ROUND(AVG(CAST(SUBSTR(IMDb, 1, LOCATE("/", IMDb)-1) AS DECIMAL(4,2))), 2) AS avg_imdbPV,
        ROUND(AVG(CAST(SUBSTR(Rotten_Tomatoes, 1, LOCATE("/", Rotten_Tomatoes)-1) AS DECIMAL(5,2))), 2) AS avg_rtPV
	FROM
		tv_shows
	WHERE Prime_Video = 1
    GROUP BY Age)

SELECT 
	nrat.Age,
    nrat.avg_imdbN, nrat.avg_rtN,
    hrat.avg_imdbH, hrat.avg_rtH,
    pvrat.avg_imdbPV, pvrat.avg_rtPV
FROM nrat
LEFT JOIN hrat
ON nrat.Age = hrat.Age
LEFT JOIN pvrat
ON nrat.Age = pvrat.Age;

# highest rated years - overall - imdb
# exported
SELECT
	Year(Year),
    ROUND(avg(CAST(SUBSTR(IMDb, 1, LOCATE("/", IMDb)-1) AS DECIMAL(4,2))), 2) AS avg_imdb
FROM tv_shows
GROUP BY year
order BY avg_imdb desc
limit 5;

# highest rated years - overall - rotten tomatoes
#exported
SELECT
	Year(Year),
    ROUND(avg(CAST(SUBSTR(Rotten_Tomatoes, 1, LOCATE("/", Rotten_Tomatoes)-1) AS DECIMAL(5,2))), 2) AS avg_rt
FROM tv_shows
GROUP BY year
order BY avg_rt desc
limit 5;
