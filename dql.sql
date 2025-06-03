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

-- Fetch all the records in the acccounts table that ends with s
SELECT name, website, primary_poc
FROM accounts
WHERE name LIKE '%s';


