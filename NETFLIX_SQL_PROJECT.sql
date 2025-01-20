--- Netflix Project 
-- DROP TABLE IF EXISTS Netflix ;
CREATE TABLE Netflix
(show_id VARCHAR(6),
 type VARCHAR(10),
 title VARCHAR(150),
 director VARCHAR(210),
 casts VARCHAR(1000),
 country VARCHAR(150),
 date_added VARCHAR(50),
 release_year INT,
 rating VARCHAR(10),
 duration VARCHAR(15),
 listed_in VARCHAR(100),
 description VARCHAR(260)
);

SELECT * FROM NETFLIX ;

SELECT COUNT(*) AS total_count
FROM Netflix ;

SELECT DISTINCT type
FROM Netflix ;

--- Analyzing my own business questions for the dataset

--- 1. Count the number of movies vs tv shows

SELECT type, COUNT(*) as total_content
FROM Netflix
GROUP BY type;

--- 2. Find the most common rating for movies and TV shows

SELECT 
    TYPE,
	RATING
FROM
(SELECT 
     TYPE,
	 RATING,
	 COUNT(*),
	 RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM NETFLIX
GROUP BY TYPE,RATING) AS T1

WHERE RANKING = 1 ;

--- 3.List all movies released in a specific year (e.g., 2020)

SELECT *
FROM NETFLIX
WHERE TYPE = 'Movie' and RELEASE_YEAR = '2020';


--- 4. Find the top 5 countries with the most content on netflix

SELECT UNNEST(STRING_TO_ARRAY(COUNTRY,', ')) AS NEW_COUNTRTY,
       COUNT(SHOW_ID) AS COUNT
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 ;


---5.Identify the longest movie 

SELECT *
FROM NETFLIX
WHERE TYPE = 'Movie' AND duration = (SELECT MAX(duration)
                                     FROM netflix);


----6.Find content added in the last 5 years

SELECT * 
FROM NETFLIX
WHERE TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS' ;

---7. Find all the movies/TV shows by director 'Rajiv Chilaka'


SELECT *
FROM NETFLIX
WHERE DIRECTOR ILIKE '%Rajiv Chilaka%' ;

--ILIKE REMOVES CASE SENSITIVITY


---8. List all TV shows with more than 5 seasons

SELECT *
       --SPLIT_PART(DURATION, ' ', 1) AS SEASON
FROM NETFLIX
WHERE TYPE = 'TV Show' AND
      SPLIT_PART(DURATION, ' ', 1):: numeric  > 5 ;


--- 9. Count the number of content items in each genre

SELECT UNNEST(STRING_TO_ARRAY(LISTED_IN,', ')) AS GENRE,
       COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY 1;

---- 10. Find each year and the average numbers of content relase by India on Netflix
--------- return the top 5 year with highest average content relase

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


---- 11. List all movies that are documentaries

SELECT * 
FROM NETFLIX
WHERE listed_in ILIKE '%documentaries%' ;

---- 12. Find all content without a director

SELECT *
FROM NETFLIX
WHERE director ISNULL

--- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT *
FROM NETFLIX
WHERE CASTS ILIKE '%SALMAN KHAN%'
      AND
	  release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
 
--- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT UNNEST(STRING_TO_ARRAY(casts, ',')),
       COUNT(*)
FROM NETFLIX
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


--- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
---- Label content containing these keywords as 'Bad' and all other content as 'Good'
---- Count how many items fall into each category

WITH new_table
AS
(
SELECT *,
       CASE 
	   WHEN
	       description ILIKE '%kill%' OR
		   description ILIKE '%violence%' THEN 'Bad_content'
		   ELSE 'Good_content'
		   END category
FROM NETFLIX
)
SELECT 
      category,
	  COUNT(*) AS total_count
FROM new_table
GROUP BY 1;











