-- Data Query Language

-- Query to fetch all the columns from the account table
SELECT id, name, website, lat, long, primary_Poc, sales_rep_id
FROM accounts;

-- Does something similar to the above but this time uses a wildcard
SELECT * 
FROM accounts;

-- fetch specific columns in the account table
SELECT name, website
FROM accounts;

-- fetch 20 rows for all the columns in the account table
SELECT * 
FROM accounts
LIMIT 20;

-- fetch the account_id, occurred_at and total columns from the orders table
SELECT account_id, occurred_at, total
FROM orders;

-- fetch the top 20 orders based on the total - account_id, occurred_at, total
SELECT account_id, occurred_at, total
FROM orders
ORDER BY total DESC
LIMIT 20;

-- filering : Fetch all the records where the total is greater than 10,000
-- Comparison operators : >, >=, <, <=, =, !=
SELECT * 
FROM orders
WHERE total > 10000;

-- Exercise
-- Pull the first 10 rows and all the columns from the orders table that have a total_amt_usd of less than 500.

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

--  Fetch the name, website and primary_Poc for the row where the account name is exxon mobil

SELECT name, website, primary_poc 
FROM accounts
WHERE name = 'Exxon Mobil';

-- Fetch all the records in the acccounts table that starts with e
SELECT name, website, primary_poc
FROM accounts
WHERE name LIKE 'e%';

-- Convert the rows in name column to lowercase before the filtering
SELECT name, website, primary_poc
FROM accounts
WHERE LOWER(name) LIKE 'e%';

-- Fetch all the records in the acccounts table that ends with a
SELECT name, website, primary_poc
FROM accounts
WHERE name LIKE '%s';

-- Fetch all the records in the accounts that has a character 'o' in between
SELECT name, website, primary_poc
FROM accounts
WHERE name LIKE '%o%'

-- Fetch all the records where the name of the account is either Exxon Mobil or Ford Motor
SELECT * FROM accounts
WHERE name IN ('Exxon Mobil', 'Ford Motor');

-- Neither Exxon Mobil nor Ford Motor
SELECT * FROM accounts
WHERE name NOT IN ('Exxon Mobil', 'Ford Motor');

-- Exercise
-- Use the web events table to find all the information about individuals who were contacted via the channel of organic or adwords.

SELECT * FROM web_events
WHERE channel in ('organic', 'adwords');

-- Logical Operators : (and, or, Between) : Filtering across multiple columns

-- 	Filter the orders table to fetch all the records where total_amt_usd > 500 and total > 300
SELECT * FROM orders
WHERE total_amt_usd > 500 AND total > 300;

-- 	Filter the orders table to fetch all the records where total_amt_usd > 500 OR total > 300
SELECT * FROM orders
WHERE (total_amt_usd > 500) OR (total > 300);


-- Filter the orders table where total_amt_usd is between 2000 and 5000
SELECT * FROM orders
WHERE total_amt_usd BETWEEN 2000 AND 5000;

-- Aggregation : SUM, COUNT, MIN, MAX, AVG


-- (i) count of number of orders
SELECT COUNT(*) AS Count_of_Orders 
FROM orders; 

-- (ii) Total quantity ordered
SELECT SUM(total) AS Total_quantity_ordered
FROM orders;

SELECT 
COUNT(*) AS Count_of_orders, 
SUM(total) AS Total_quantity_ordered, 
ROUND(AVG(total), 2) AS Average_quantity, 
MIN(total), 
MAX(total)
FROM orders;

-- For each account. what is the total orders made in terms of quantity ordered.
SELECT account_id , SUM(total) AS Total_quantity_per_account
FROM orders
GROUP BY account_id
ORDER BY Total_quantity_per_account DESC
LIMIT 20;


-- JOIN

--  Fetch all the rows in the orders table and the corresponding row in the account table
SELECT orders.* , accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Fetch the total quantity (total) from the orders table and the account name tied to the order
SELECT orders.total AS Quantity_of_order_placed, accounts.name AS Account_name
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Types of Join : (i) Inner Join (ii) Left Join (iii) Right Join (iv) Full Outer Join

SELECT accounts.name AS Account_name, SUM(orders.total) AS Quantity_of_order_placed_per_account
FROM accounts
JOIN orders
ON orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY Quantity_of_order_placed_per_account DESC;

-- Exercise
SELECT 
     a.name AS Account_name, 
	 sr.name AS Sales_reps,
	 r.name AS region
FROM accounts a
JOIN sales_reps sr ON sr.id = a.sales_rep_id
JOIN region r ON r.id = sr.region_id
ORDER BY Account_name;

-- 
SELECT accounts.name AS Account_name, SUM(orders.total) AS Quantity_of_order_placed_per_account
FROM accounts
JOIN orders
ON orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY Quantity_of_order_placed_per_account DESC;

-- Fetch all the sales reps and the number of accounts they manage
SELECT 
      sales_reps.name AS Sales_rep, 
	  COUNT(accounts.name) AS number_accounts
FROM accounts
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
GROUP BY Sales_rep;

--Exercise (Gives all the records that match on accounts tables and sales_rep table)
SELECT 
	accounts.name AS Account_name, 
	sales_reps.name AS Sales_reps,
	region.name AS region
FROM accounts
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
JOIN region ON region.id = sales_reps.region_id
ORDER BY Account_name;


SELECT 
    accounts.name AS Account_name,
    SUM(orders.total) AS Total_order_amount_per_account
FROM 
    accounts
JOIN 
    orders ON orders.account_id = accounts.id
GROUP BY 
    accounts.name
ORDER BY 
    Total_order_amount_per_account DESC;

-- Fetch all the sales reps and the number of accounts they engage

SELECT 
    sales_reps.name AS Sales_rep, 
    COUNT(accounts.name) AS number_accounts
FROM 
    accounts
JOIN 
    sales_reps ON accounts.sales_rep_id = sales_reps.id
GROUP BY 
    sales_reps.name
HAVING 
    COUNT(accounts.name) > 5
ORDER BY 
    number_accounts DESC
LIMIT 10;


-- DATE TRUNC : Truncate dates to a particular part
-- In which month of the year did Walmart order the most?
SELECT 
	DATE_TRUNC('month', orders.occurred_at) order_month,
	SUM(orders.total) Total_quantity_ordered
FROM orders
JOIN accounts ON orders.accounts_id = accounts.id
WHERE accounts.name = 'Walmart'
GROUP BY order_month;--wrong synthax, corrected in the one below

SELECT 
    DATE_TRUNC('month', orders.occurred_at) AS order_month,
    SUM(orders.total) AS Total_quantity_ordered
FROM 
    orders
JOIN 
    accounts ON orders.account_id = accounts.id
WHERE 
    accounts.name = 'Walmart'
GROUP BY 
    order_month
ORDER BY Total_quantity_ordered DESC;

SELECT 
    EXTRACT(MONTH FROM DATE_TRUNC('month', orders.occurred_at)) order_month,
    SUM(orders.total) Total_quantity_ordered
FROM orders
JOIN accounts ON orders.account_id = accounts.id
WHERE accounts.name = 'Walmart'
GROUP BY order_month
ORDER BY Total_quantity_ordered DESC;

SELECT 
    DATE_TRUNC('month', orders.occurred_at) AS order_month,
    SUM(orders.total) AS Total_quantity_ordered
FROM 
    orders
JOIN 
    accounts ON orders.account_id = accounts.id
WHERE 
    accounts.name = 'Walmart'
AND EXTRACT (YEAR FROM orders.occurred_at) = '2016'
GROUP BY 
    order_month
ORDER BY Total_quantity_ordered DESC;


-- In which month of the year did Walmart order the most?

SELECT DATE_TRUNC('month', orders.occurred_at) month_date, SUM(orders.total) total_ordered
FROM orders
JOIN accounts ON orders.account_id = accounts.id
WHERE accounts.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- DATE PART: 
-- What month did Parch and Porsey have the greatest number of order
SELECT DATE_PART('month', occurred_at) month_of_order, COUNT(*) No_of_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;


-- Categorize the month of order into name of the month
SELECT DATE_PART('month', occurred_at) month_of_order, COUNT(*) No_of_orders,
       CASE 
	       WHEN DATE_PART('month', occurred_at) = 12 THEN 'December'
	       WHEN DATE_PART('month', occurred_at) = 11 THEN 'November'
		   ELSE 'October'
		END AS month_name
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Show for each order in the orders table if the order is high value or low value
-- Threshold : 500. In the result, show the account_id, total and category

SELECT account_id, total, 
       CASE 
	       WHEN total > 500 THEN 'High Value'
	       ELSE 'Low Value'
	   END AS category
FROM orders;






