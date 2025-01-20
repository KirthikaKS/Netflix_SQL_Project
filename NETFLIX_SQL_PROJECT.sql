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

---- 10. 

