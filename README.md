# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix logo](https://github.com/Kamil7Chaudhry/Netflix_SQL_Project/blob/main/Netflix%20Cover)

## Overview

This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

Dataset Link: [Netflix Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

# Business Problems and Solutions

1. Count the Number of Movies vs TV Shows

   ```sql
   select
	type,
	COUNT(*) AS total_content
	from netflix
	group by type
	;
	```

Objective: Determine the distribution of content types on Netflix.

2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

Objective: Identify the most frequently occurring rating for each type of content.

 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select title, release_year, type
from netflix
where 
	type='Movie'
	AND
	release_year=2020;
```
Objective: Retrieve all movies released in a specific year.

 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
Group by 1
order by 2 DESC
LIMIT 5;
```
Objective: Identify the top 5 countries with the highest number of content items.



 5. Identify the Longest Movie

```sql
SELECT*
FROM netflix
	where
	type='Movie'
	AND
	duration = (select MAX(duration) from netflix)
```
Objective: Find the movie with the longest duration.

 6. Find Content Added in the Last 5 Years

```sql
SELECT
	*
FROM netflix
where 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
Objective: Retrieve content added to Netflix in the last 5 years.
	

 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT 
	type, director
FROM netflix
where director ILIKE '%Rajiv Chilaka%';
```
Objective: List all content directed by 'Rajiv Chilaka'.

 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT
	*
from netflix
where
	 type= 'TV Show'
	 AND
	 SPLIT_PART(duration, ' ', 1)::numeric> 5
```
Objective: Identify TV shows with more than 5 seasons.

 9. Count the Number of Content Items in Each Genre

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
from netflix
group by 1;
```
Objective: Count the number of content items in each genre.


 10.Find each year and the average numbers of content release in United States on netflix.

```sql
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
```
Objective: Calculate and rank years by the average number of content releases by United States.


 11. List All Movies that are Documentaries

```sql
select*
from netflix
where 
	listed_in ILIKE '%Documentaries%'
```
Objective: Retrieve all movies classified as documentaries.
	

 12. Find All Content Without a Director

```sql
select*
from netflix
where 
	director is NULL;
```
Objective: List content that does not have a director.
	

 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
 	SELECT * 
	FROM netflix
	WHERE casts LIKE '%Salman Khan%'
  	AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.
  

 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in United States

```sql
SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
from netflix
where country ILIKE '%United States%'
group by 1
order by 2 desc
Limit 10;
```
Objective: Identify the top 10 actors with the most appearances in United States-produced movies.


 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

# Findings and Conclusion
- Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
- Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

# Author - Kamil Munir Chaudhry

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- LinkedIn: [Feel free to Connect!](https://www.linkedin.com/in/kamil-munir-chaudhry-015621219/)
