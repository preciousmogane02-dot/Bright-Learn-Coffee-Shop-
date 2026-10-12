-- DATA INSPECTION
-- Checking my data, just to make sure I have the right data
SELECT * 
from `brightlearn`.`kpm`.`shopsales`
limit 100;

-- How many stores do we have?
SELECT DISTINCT store_location
FROM brightlearn.kpm.shopsales;

-- what is the period of this data?
SELECT min(transaction_date) AS start_date,
       MAX(transaction_date) AS last_date
FROM `brightlearn`.`kpm`.`shopsales`;

-- What are the business hours of the stores?
SELECT MIN(transaction_time) AS opening_time,
       MAX(transaction_time) AS closing_time
FROM `brightlearn`.`kpm`.`shopsales`;

-- I want to know how many transactions were made per day
SELECT
  transaction_date,
  count(*) as total_transactions
FROM `brightlearn`.`kpm`.`shopsales`
GROUP BY transaction_date
ORDER BY transaction_date;

--How many products are we selling per store?
SELECT store_location,
        COUNT(DISTINCT product_id) AS number_of_products
FROM brightlearn.kpm.shopsales
GROUP BY store_location;

-- Calculating a different product category we have
SELECT DISTINCT product_category,
               product_type,
               product_detail
FROM brightlearn.kpm.shopsales
WHERE product_category IN ('Coffee')
ORDER BY product_type;

-- I want to know how many transactions were made per day, per store, per product
SELECT  
  transaction_date,
  store_id,
  product_id,
  count(*) as total_transactions
from `brightlearn`.`kpm`.`shopsales`
group by transaction_date, store_id, product_id
order by transaction_date, store_id, product_id;

-- DATA PROCESSING
--Checking my data, just to make sure I have the right data
SELECT*
FROM brightlearn.kpm.shopsales
LIMIT 100;

-- What are the business hours of the stores?
SELECT MIN(transaction_time) AS opening_time,
       MAX(transaction_time) AS closing_time
FROM `brightlearn`.`kpm`.`shopsales`;


SELECT min(transaction_date) AS start_date,
       MAX(transaction_date) AS last_date
FROM `brightlearn`.`kpm`.`shopsales`;


-- The Big Code

SELECT
  transaction_date,--- from the original 
   DAYNAME(transaction_date) AS Day_name,-- extracting the name of the day
    MONTHNAME(transaction_date) AS Month_name,-- extracting the name of the month--new row

     COUNT(transaction_id) AS number_of_sales,-- counting the rows- new row
     SUM(transaction_qty) AS units_sold,-- adding all the units-- new row 
     COUNT(DISTINCT product_id) AS unique_products,-- counting the unique products-- new row 
     COUNT(store_id) AS number_of_stores,-- counting the number of stores-- new row
     SUM(transaction_qty * double(replace(unit_price, ',', '.'))) AS revenue,-- calculating revenue by transaction_qty* unit_price-- new row
 CASE 
        WHEN DAYNAME(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
        WHEN DAYNAME(transaction_date) IN ('Mon','Tue','Wed','Thu','Fri') THEN 'Weekday'
        END AS day_classification,
    CASE 
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN '01.Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '17:59:59' THEN '02.Afternoon'
        WHEN transaction_time BETWEEN '18:00:00' AND '20:59:59' THEN '03.Evening'
    END AS time_classification,

    store_location,
    product_category,
    product_type,
    product_detail

    FROM brightlearn.kpm.shopsales

GROUP BY 
    transaction_date,
    transaction_time,
    month_name,
    store_location,
    product_category,
    product_type,
    product_detail;

    -- I am grouping by 30 mins time intervals
   
-- Checking 
SELECT 
        transaction_time
FROM brightlearn.kpm.shopsales
ORDER BY transaction_time DESC
LIMIT 20;



SELECT
    transaction_time,

    -- Create a 30-minute time bucket
    CONCAT(-- putting pieces of text together 

        LPAD(HOUR(transaction_time), 2, '0'),-- making the hours have two digits

        CASE
            -- If minutes are 00–29, put it in the :00 bucket
            WHEN MINUTE(transaction_time) < 30 THEN '00'

            -- If minutes are 30–59, put it in the :30 bucket
            ELSE '30'
        END

    ) AS transaction_time_bucket

FROM brightlearn.kpm.shopsales;
