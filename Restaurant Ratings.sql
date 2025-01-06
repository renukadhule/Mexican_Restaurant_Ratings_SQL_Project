CREATE DATABASE restaurant_rating;
Use restaurant_rating

ALTER TABLE restaurants
RENAME COLUMN Restaurant_ID TO Restaurant_ID;

-- List all restaurants that serve alcohol and allow smoking. --
SELECT 
    name AS res_name
FROM
    restaurants
WHERE
    Alcohol_Service <> 'None'
        AND Smoking_Allowed = 'Yes';
        

-- Total Smokers by Occupation --
SELECT 
    Occupation, COUNT(Consumer_ID) AS smokers
FROM
    consumers
WHERE
    Smoker = 'Yes'
GROUP BY Occupation;


-- List the top 3 cities with the most restaurants. --
SELECT 
    COUNT(Restaurant_ID) AS total_res, City
FROM
    restaurants
GROUP BY City
ORDER BY total_res DESC
LIMIT 3;


-- Total restaurants in each state. --
SELECT 
    COUNT(Restaurant_ID), State
FROM
    restaurants
GROUP BY State;


-- List the top 5 highest-rated restaurants based on overall rating. --
SELECT 
    name AS restaurant_name, AVG(Overall_Rating) AS avg_rating
FROM
    restaurants
        JOIN
    ratings ON restaurants.Restaurant_ID = ratings.Restaurant_ID
GROUP BY restaurant_name
ORDER BY avg_rating DESC
LIMIT 5;


-- Retrieve all the details of customers who are smokers and prefer 'Italian' cuisine. --
SELECT 
    *
FROM
    consumers
        JOIN
    consumer_preferences ON consumer_preferences.Consumer_ID = consumers.Consumer_ID
WHERE
    Smoker = 'Yes'
        AND Preferred_Cuisine = 'Italian';
 
 
-- Find all restaurants located in the same city and state as 'Customer_ID = C123'. --
SELECT 
    name,
    restaurants.city,
    restaurants.state,
    consumers.Consumer_ID
FROM
    ratings
        JOIN
    consumers ON ratings.Consumer_ID = consumers.Consumer_ID
        JOIN
    restaurants ON ratings.Restaurant_ID = restaurants.Restaurant_ID
WHERE
    consumers.Consumer_ID = 'U1015'
        AND restaurants.city = consumers.city
        AND restaurants.state = consumers.state;
        

-- Find the restaurant with the highest average food rating. --
SELECT 
    name, AVG(Food_Rating)
FROM
    restaurants
        JOIN
    ratings ON ratings.Restaurant_ID = restaurants.Restaurant_ID
GROUP BY name
ORDER BY AVG(Food_Rating) DESC
LIMIT 1;


-- List all restaurants that do not serve alcohol and have parking available. --
SELECT 
    name
FROM
    restaurants
WHERE
    Alcohol_Service = 'None'
        AND Parking = 'Yes';
        

-- Find customers who have rated restaurants but do not have any preferences listed. --
SELECT 
    Consumer_ID
FROM
    ratings
WHERE
    Consumer_ID IN (SELECT 
            Consumer_ID
        FROM
            consumer_preferences
        WHERE
            Preferred_Cuisine IS NULL);
            

-- Transportation methods of customers --
SELECT 
    Transportation_Method, COUNT(Consumer_ID) AS total_customers
FROM
    consumers
WHERE
    Transportation_Method IS NOT NULL
GROUP BY Transportation_Method;


-- Total restaurants in each city --
SELECT 
    COUNT(Restaurant_ID), City
FROM
    restaurants
GROUP BY City;


-- Restaurants COUNT by alcohol service --
SELECT 
    COUNT(Restaurant_ID), Alcohol_Service
FROM
    restaurants
GROUP BY Alcohol_Service;


-- Restaurants Count by Smoking Allowed --
SELECT 
    COUNT(Restaurant_ID), Smoking_Allowed
FROM
    restaurants
GROUP BY Smoking_Allowed;


-- Alcohol & Smoking analysis --
SELECT 
    COUNT(Restaurant_ID), Smoking_Allowed, Alcohol_Service
FROM
    restaurants
GROUP BY Smoking_Allowed , Alcohol_Service;


-- Restaurants COUNT by Price --
SELECT 
    COUNT(Restaurant_ID), Price
FROM
    restaurants
GROUP BY Price;

/* Write a query to segment customers into three groups based on their average Overall_Rating: "High Raters" (average rating > 4),
"Medium Raters" (average rating between 3 and 4), and "Low Raters" (average rating < 3). */
SELECT 
    Consumer_ID,
    AVG(Overall_rating) AS rating,
    CASE
        WHEN AVG(Overall_rating) > 4 THEN 'High Raters'
        WHEN AVG(Overall_rating) BETWEEN 3 AND 4 THEN 'Medium Raters'
        ELSE 'Low Raters'
    END
FROM
    ratings
GROUP BY Consumer_ID;


-- Restaurants COUNT by packing --
SELECT 
    COUNT(Restaurant_ID), Parking
FROM
    restaurants
GROUP BY Parking;


-- Count of Restaurants by cuisines --
SELECT 
    COUNT(Restaurant_ID), Cuisine
FROM
    restaurant_cuisines
GROUP BY Cuisine;


-- Preferred cuisines of each customer --
SELECT 
    Consumer_ID, Preferred_Cuisine
FROM
    consumer_preferences;
    

-- Write a query to find customers whose Occupation is not null but starts with the letter 'A'. --
SELECT 
    COUNT(Consumer_ID)
FROM
    consumers
WHERE
    Occupation IS NOT NULL
        AND Occupation LIKE '%A';
        

/* Write a query to rank restaurants based on the number of ratings they've received,but only include restaurants that have received
at least one Overall_Rating.Use a window function to rank these restaurants, even if they have NULL ratings in other categories */
select Restaurant_ID,count(Overall_Rating) as rating,
rank() Over(order by count(Overall_Rating) desc) as res_rank
from ratings where Overall_Rating is not null
group by Restaurant_ID;

/* Classify restaurants into three categories: "Fully Rated" (no nulls in any ratings), 
"Partially Rated" (some but not all ratings are null), and "Unrated" (all ratings are null). */
SELECT 
    Restaurant_ID,
    CASE
        WHEN
            Overall_Rating IS NOT NULL
                AND Food_Rating IS NOT NULL
                AND Service_Rating IS NOT NULL
        THEN
            'Fully Rated'
        WHEN
            Overall_Rating IS NULL
                AND Food_Rating IS NULL
                AND Service_Rating IS NULL
        THEN
            'Unrated'
        ELSE 'Partially Rated'
    END
FROM
    ratings;
    









