-- CHALLENGE: Subqueries

USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS num_copies
FROM film
JOIN inventory USING (film_id)
WHERE title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length 
FROM film
WHERE length > (
  SELECT AVG(length) FROM film
);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
    SELECT actor_id
    FROM sakila.film_actor
    WHERE film_id = (
        SELECT film_id
        FROM sakila.film
        WHERE title = 'Alone Trip'
    )
);

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT title 
FROM
	(SELECT f.title, c.name AS category
    FROM film as f
	JOIN film_category AS fc ON f.film_id = fc.film_id
	JOIN category AS c ON fc.category_id = c.category_id) AS s
WHERE category = "Family"; 

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database.
SELECT actor_id 
FROM (
  SELECT actor_id, count(film_id) AS films 
  FROM film_actor
  GROUP BY actor_id
  ORDER BY films DESC
  LIMIT 1) AS s;
  
SELECT fi.title 
FROM film_actor AS fa 
JOIN film AS fi ON fa.film_id = fi.film_id
WHERE actor_id = (
    SELECT actor_id 
	FROM (
	  SELECT actor_id, count(film_id) AS films 
	  FROM film_actor
	  GROUP BY actor_id
	  ORDER BY films DESC
	  LIMIT 1) AS s1);

