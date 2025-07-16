-- SQL Retail Analyisis

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,	
				sale_time TIME,	
				customer_id	INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs FLOAT,	
				total_sale FLOAT

			);
SELECT * FROM retail_sales LIMIT 10;

--Checking number of rows

SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning
--Checking for Null values

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
--Deleting Null values

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

	-- Data exploration
-- How many sales we have
SELECT COUNT(*) AS sales FROM retail_sales;

-- How many unique customers we have
SELECT COUNT(DISTINCT customer_id ) AS no_of_customers FROM retail_sales;

-- How many categories we have
SELECT DISTINCT category AS categories FROM retail_sales;

-- Data Analysis
-- 1. Write a SQL query that retrieves all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date= '2022-11-05';

-- 2. Write a SQL query to retrieve all the transcations where the category is 'Clothing' and the quantity sold is equal or more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
category ='Clothing'
and
quantiy >= 4
and TO_CHAR(sale_date, 'YYYY-MM')='2022-11';
--sale_date >='2022-11-01' and sale_date<'2022-12-01';

-- 3. Write a SQL query to calculate the (total sale) for each category
SELECT category, SUM(total_sale) AS net_sales FROM retail_sales
GROUP BY 1;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG (age),2) AS avg_age FROM retail_sales
WHERE 
category='Beauty';

-- 5. Write a sql query to find all transcations where the total sales is greater than 1000
SELECT * 
FROM retail_sales
WHERE 
total_sale > 1000;

--6. Write a sql query to find the total number of transcations (transcation_id) by each gender in each category
SELECT category,
		gender, 
		COUNT(*)
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- 7. Write a sql query to calculate the average sale for each month, find the best selling month in each year
SELECT 
year,
month,
avg_sale
FROM
(
	SELECT 
	EXTRACT (YEAR FROM sale_date) AS YEAR,
	EXTRACT (MONTH FROM sale_date) AS MONTH,
	AVG(total_sale) AS avg_sale,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY 1,2
) AS t1
WHERE RANK =1;

-- 8. Write a sql query to find the top 5 customers based on the highest total sales
SELECT customer_id,
SUM(total_sale) AS net_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. Write a sql query to find the number of unique customers who purchased items from each category
SELECT
category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC;

-- 10. Write a sql query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 & 17, Evening>17)
SELECT 
	CASE
		WHEN EXTRACT (HOUR FROM sale_time)< 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift,
COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY 1;
--End of project
