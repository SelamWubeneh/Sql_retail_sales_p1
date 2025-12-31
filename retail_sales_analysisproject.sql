--Create  a table(ARRANGE THE TABLE FIRST SO THAT IT WILL BE EASIR FOR DEBUGGING),then add the data type like int,date,time.
--VARCHAR(15) REFERING TO THE TEXT OR CHARACTER LENGTH.
DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales
(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantiy	INT,
		price_per_unit FLOAT,
		cogs FLOAT,	
		total_sale FLOAT
);

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO QUANTITY;

Select * 
FROM retail_sales
LIMIT 10

Select COUNT(*) 
FROM retail_sales

--Data Cleaning
Select * 
FROM retail_sales
WHERE  
	transactions_id is null
	or
	Sale_date is null
	or 
	sale_time is null
	or
	gender is null
	or 
	quantity is null
	or
	cogs is null
	or 
	total_sale is null
	
DELETE FROM retail_sales
WHERE  
	transactions_id is null
	or
	Sale_date is null
	or 
	sale_time is null
	or
	gender is null
	or
	age is null
	or 
	quantity is null
	or
	cogs is null
	or 
	total_sale is null
	
--Data exploration

-- How many sales we have(business question)?

SELECT COUNT(*) as total_sale 
FROM  retail_sales

--How many customers we have? 

SELECT COUNT(customer_id) as customer_id
FROM retail_sales

--HOW MANY UNIQUE CUSTOMERS DO WE HAVE?

SELECT COUNT(DISTINCT customer_id) as customer_id
FROM retail_sales

----HOW MANY UNIQUE Category DO WE HAVE?
SELECT COUNT(DISTINCT Category) as customer_id
FROM retail_sales


---- ****Data Analysis & Business Key Problems & Answers***

-- My Analysis & Findings
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in
--the month of Nov-2022
-- Write a SQL query to calculate the total sales (total_sale) for each category.
-- Write a SOL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Write a SQL query to find the top 5 customers based on the highest total sales
-- Write a SQL query to find the number of unique customers who purchased items from each category.

-- Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)|

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
Where sale_date = '2022-11-05';

--2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in
--the month of Nov-2022
--note:postgres does not support month() directly, so we use extract
SELECT *
FROM retail_sales
WHERE Category = 'Clothing' 
	AND quantity >= 4 
	AND EXTRACT(MONTH FROM sale_date) = 11
	AND EXTRACT(YEAR FROM sale_date)=2022;
--3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT Category, SUM(total_sale) as net_sales
FROM retail_sales
GROUP BY category
-- if we want to add a condition that counts total_order.. 
SELECT Category, SUM(total_sale) as net_sales, count(*) as total_orders
FROM retail_sales
GROUP BY category
--4  Write a SOL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT Round(AVG(age), 2) as avg_customers_age
FROM retail_sales
WHERE category = 'Beauty'

--5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000 

--6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT Category, gender, COUNT(transactions_id) as total_transactions
FROM retail_sales
GROUP BY Category,gender
ORDER BY 1

--7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
  EXTRACT(YEAR FROM sale_date) AS year,
  EXTRACT(MONTH FROM sale_date) AS month,
  AVG(total_sale) AS avg_sale,
  RANK() OVER(
    PARTITION BY EXTRACT(YEAR FROM sale_date)
    ORDER BY AVG(total_sale) DESC
  ) AS rnk
FROM retail_sales
GROUP BY 1, 2;
--8 Write a SQL query to find the top 5 customers based on the highest total sales
 
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
--9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, Count(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
--10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)|
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT (HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
--END of project
SELECT 
	shift,
		COUNT (*) as total_orders
FROM hourly_sale
GROUP BY shift