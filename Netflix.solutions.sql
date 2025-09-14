drop table if exists netflix;
Create table netflix(
  show_id varchar(10),
  typess varchar(10),
  title varchar(150),
  director varchar(250),
  casts varchar(1000),
  country varchar(150),
  date_added varchar(50),
  release_year int,
  rating varchar(10),
  duration varchar(20),
  listed_in varchar(100),
  description varchar(300)
);
select * from netflix;

select distinct typess
from netflix;

--- Gives us Total number of Movies and TV shows
select 
  typess,
  count(*) as total_content
from netflix
group by typess;

--- Most common rating to Movies and TV shows

select
   typess,
   rating,
   count(*)as rating_count
from netflix
group by typess,rating
order by typess,rating_count desc

--- Movies released in a specific year

Select title, release_year from netflix where release_year = 2019;

--- Countries with most Movies and TV shows 

Select 
  unnest((STRING_TO_ARRAY(country, ','))) as countries,
  count(show_id) as total_content
from netflix
group by 1 
order by total_content desc
Limit 5

select 
   unnest((STRING_TO_ARRAY(country, ','))) as countries
from netflix;


--- Finding out the longest Movies

select * from netflix
where
   typess = 'Movie'
   and
   duration = (select max(duration) from netflix)


--- Content type released in last 5 years

select * from netflix
where 
   To_Date(date_added, 'Month DD, YYYY') >= current_date - Interval '5 years'

   
select current_date - Interval '5 years'


--- Movies directed by Mark Waters 

Select title,director from netflix ---- there can be more than one directors, so we are using 'LIKE' function, we can use 
where director = 'Mark Waters'     -----'ILIKE' function which do not considers case sensitivity

Select title, director from netflix
where director like '%Rajiv Chilaka%'


--- TV shows with more than 5 seasons 

Select title, duration from netflix
WHERE 
     typess = 'TV Show' 
	 ANd
	 SPLIT_PART(duration, ' ', 1) :: numeric > 5 


--- Number of Content in each Genre

Select  
   UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
   count(show_id) as shows
from netflix
group by 1


--- Average number of content released per year by India on netflix
select  
   Extract(Year from To_Date(date_added, 'Month DD, YYYY')) as Year,
   count('titles') as Content_added,
   Round(count('titles'):: numeric/(Select count('titles') from netflix where country = 'India') * 100, 2) as Average_content
from netflix
where country = 'India'
Group by Year  



--- List all the movies that are documentaries

Select title,listed_in from netflix
where listed_in like '%Documentaries%' and typess = 'Movie'


--- Find all the content in which director is not mentioned

Select title, show_id, director from netflix
where director is Null


--- Find how many movies Salman Khan appeared in last 10 years

Select * from netflix
where 
    casts ILIKE '%Salman Khan%'
	and
	release_year > Extract(Year from Current_Date)- 10


--- Top 10 Actors who have appeared in highest number of movies produced in India

Select 
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
count(*) as total
from netflix
where country ILIKE '%India%'
group by 1 
order by total  desc
LIMIT 10


--- Categorize content on the basis of words such as 'Kill' and 'violence' as PG-13 and Normal


With New_table
As
(
Select 
 *, 
    Case 
    When
        description ILIKE '%KILL%' or
		description ILIKE '%Violence%' Then 'PG-13'
		Else 'Normal'
	End Category
from netflix	
)
Select 
       Category,
       count(*) as total_content
from New_table	   

group by Category
