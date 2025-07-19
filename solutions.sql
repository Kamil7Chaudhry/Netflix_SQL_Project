-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(	
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

SELECT* FROM netflix;


SELECT
	COUNT(*) AS total_content
FROM netflix;


SELECT
	DISTINCT type
FROM netflix;

-- Business Problems and Solutions

-- 1. Count the Number of Movies vs TV Shows
select
	type,
	COUNT(*) AS total_content
from netflix
group by type;

-- 2. Find the Most Common Rating for Movies and TV Shows
select
	type,
	rating
from
(
	SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	from netflix
	Group by 1,2
) as t1
where 
ranking=1;
)

-- 3. List All Movies Released in a Specific Year (e.g., 2020)

select title, release_year, type
from netflix
where 
	type='Movie'
	AND
	release_year=2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
Group by 1
order by 2 DESC
LIMIT 5;

-- 5. Identify the Longest Movie

SELECT*
FROM netflix
	where
	type='Movie'
	AND
	duration = (select MAX(duration) from netflix)

-- 6. Find Content Added in the Last 5 Years

SELECT
	*
FROM netflix
where 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
	

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT 
	type, director
FROM netflix
where director ILIKE '%Rajiv Chilaka%';

-- 8. List All TV Shows with More Than 5 Seasons

SELECT
	*
from netflix
where
	 type= 'TV Show'
	 AND
	 SPLIT_PART(duration, ' ', 1)::numeric> 5

-- 9. Count the Number of Content Items in Each Genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
from netflix
group by 1;


-- 10.Find each year and the average numbers of content release in United States on netflix.
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'United States')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'United States'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


-- 11. List All Movies that are Documentaries

select*
from netflix
where 
	listed_in ILIKE '%Documentaries%'
	

-- 12. Find All Content Without a Director

select*
from netflix
where 
	director is NULL;
	

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

	SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

  

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in United States

SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
from netflix
where country ILIKE '%United States%'
group by 1
order by 2 desc
Limit 10


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;