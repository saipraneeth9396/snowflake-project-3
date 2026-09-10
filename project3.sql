-- PROJECT-3:Enterprise Incremental Sales Data Warehouse using Snowflake
-- ----------
-- Problem Statement:
-- -------------------
-- A multinational retail company has already migrated its operational databases to the Snowflake Cloud Data Warehouse. Initially, the company performed a complete data migration and generated analytical reports for business users.

-- As the business expanded, new sales transactions started arriving every hour from multiple regional branches. Reloading the complete historical data every time became inefficient and increased processing time.

-- The data engineering team has been assigned to develop an Incremental Data Warehouse Pipeline capable of loading only newly arrived records while preserving historical data.

-- To improve warehouse reliability, the company also wants to maintain an audit trail, recover accidentally deleted data, create testing environments without duplicating storage, and automate daily data loading.

-- Your task is to implement the required Snowflake objects and generate analytical reports using the newly loaded data.

-- Project Objectives
-- --------------------
-- After completing this project, students will be able to 
-- Perform Incremental Data Loading
-- Use Snowflake Streams
-- Automate loading using Tasks
-- Recover historical data using Time Travel
-- Create Zero Copy Clones
-- Validate newly arrived records
-- Maintain Audit Logs
-- Generate analytical reports.

-- Input Files
-- ------------
-- customers.csv
-- ---------------
-- customer_id,customer_name,city,membership
-- 1,Amit,Hyderabad,Gold
-- 2,Priya,Bangalore,Silver
-- 3,Rahul,Chennai,Gold
-- 4,Neha,Pune,Silver
-- 5,Arjun,Delhi,Platinum


-- products.csv
-- -------------
-- product_id,product_name,category,price
-- 101,Laptop,Electronics,60000
-- 102,Mobile,Electronics,25000
-- 103,Keyboard,Accessories,1500
-- 104,Mouse,Accessories,800
-- 105,Monitor,Electronics,12000

-- branches.csv
-- ------------
-- branch_id,branch_name,state
-- 1,Hyderabad Branch,Telangana
-- 2,Bangalore Branch,Karnataka
-- 3,Delhi Branch,Delhi

-- sales_history.csv
-- ------------------
-- sale_id,customer_id,product_id,branch_id,quantity,sale_date,total_amount
-- 1,1,101,1,1,2026-07-01,60000
-- 2,2,102,2,2,2026-07-02,50000
-- 3,3,103,2,2,2026-07-03,3000
-- 4,4,104,1,5,2026-07-04,4000
-- 5,5,105,3,2,2026-07-05,24000


-- new_sales.csv
-- ---------------
-- sale_id,customer_id,product_id,branch_id,quantity,sale_date,total_amount
-- 6,1,102,1,1,2026-07-06,25000
-- 7,2,105,2,1,2026-07-07,12000
-- 8,3,101,3,1,2026-07-08,60000
-- 9,4,103,1,2,2026-07-09,3000
-- 10,5,102,3,1,2026-07-10,25000

-- your Tasks:
-- --------------
-- Phase-1 : Snowflake Environment
-- -------------------------------
-- 1.Create Warehouse ENTERPRISE_WH
-- 2.Create Database ENTERPRISE_DB
-- 3.Create Schema SALES_SCHEMA
-- 4.Create CSV File Format
-- 5.Create Internal Stage

-- Phase-2 : Data Loading
-- -------------------------
-- 6.Upload all CSV files.
-- 7.Create all required tables.
-- 8.Load sales_history.csv into SALES table.
-- 9.Verify the loaded records.

-- Phase-3 : Incremental Loading
-- --------------------------------
-- 10.Create a Stream on the SALES table.
-- 11.Load new_sales.csv.
-- 12.Display only newly inserted records using the Stream.
-- 13.Merge newly arrived records into the SALES table.


-- Phase-4 : Data Validation
-- -------------------------
-- 14.Identify duplicate Sale IDs.
-- 15.Identify missing Customer IDs.
-- 16.Display invalid Product IDs.
-- 17.Count total newly inserted records.

-- Phase-5 : Time Travel
-- ---------------------
-- 18.Delete one sales record.
-- 19.Recover the deleted record using Time Travel.
-- 20.Verify recovery.


-- Phase-6 : Zero Copy Clone
-- -------------------------
-- 21.Create a clone named: SALES_TEST
-- 22.Display cloned records.
-- 23.Insert one new record into the clone.
-- 24.Verify that the original SALES table remains unchanged.

-- Phase-7 : Task Automation
-- -------------------------
-- 25.Create a Task that automatically performs incremental loading every day.
-- 26.Resume the Task.
-- 27.Verify Task execution.


-- Phase-8 : Business Analytics
-- -----------------------------
-- Generate
-- 28.Customer Revenue Report
-- 29.Branch Revenue Report
-- 30.Product Revenue Report
-- 31.Monthly Revenue Report
-- 32.Highest Revenue Customer
-- 33.Highest Revenue Branch
-- 34.Top Five Products
-- 35.Customer Purchase Frequency
-- 36.Running Revenue
-- 37.Customer Ranking

-- Phase-9 : Views
-- ----------------
-- 38.Create View: CUSTOMER_REVENUE
-- 39.Create Materialized View: BRANCH_REVENUE
-- 40.Display data from both Views.


-- Expected Outputs
-- --------------------

-- Output-1:Customers Loaded Successfully

-- Output-2:Products Loaded Successfully

-- Output-3:Historical Sales Loaded

-- Output-4:New Sales Captured by Stream

-- Output-5:Incremental Load Completed

-- Output-6:Duplicate Record Report

-- Output-7:Missing Customer Report

-- Output-8:Recovered Records using Time Travel

-- Output-9:Clone Created Successfully

-- Output-10:Original Table Unchanged After Clone Modification

-- Output-11:Customer Revenue Report

-- Output-12:Branch Revenue Report

-- Output-13:Monthly Revenue Report

-- Output-14:Top Five Customers

-- Output-15:Top Five Products

-- Output-16:Customer Ranking

-- Output-17:Running Revenue

-- Output-18:Materialized View Output


-- Snowflake Concepts Covered:
-- ----------------------------
-- Snowflake Administration:
-- -------------------------
-- Warehouse
-- Database
-- Schema
-- Stage
-- File Format

-- Data Engineering
-- ----------------
-- COPY INTO
-- MERGE
-- Streams
-- Tasks
-- Time Travel
-- Zero Copy Clone

-- SQL Analytics:
-- -------------
-- JOIN
-- GROUP BY
-- HAVING
-- ORDER BY
-- CTE
-- Window Functions
-- Ranking

-- Snowflake Objects
-- -----------------
-- Views
-- Materialized Views

-- =======================================================================================================================================================
-- ANSWER
-- =======================================================================================================================================================

-- Phase-1 : Snowflake Environment
-- -------------------------------
-- 1.Create Warehouse ENTERPRISE_WH

CREATE WAREHOUSE ENTERPRISE_WH
WAREHOUSE_SIZE = 'XSMALL';

USE WAREHOUSE ENTERPRISE_WH;

-- 2.Create Database ENTERPRISE_DB

CREATE DATABASE ENTERPRISE_DB;

USE DATABASE ENTERPRISE_DB;

-- 3.Create Schema SALES_SCHEMA

CREATE SCHEMA ENTERPRISE_DB.SALES_SCHEMA;

USE SCHEMA SALES_SCHEMA;

SHOW SCHEMAS IN DATABASE ENTERPRISE_DB;

-- 4.Create CSV File Format

CREATE FILE FORMAT CSV_FILE_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

SHOW FILE FORMATS;

-- 5.Create Internal Stage

CREATE STAGE ENTERPRISE_STAGE
FILE_FORMAT = CSV_FILE_FORMAT;

SHOW STAGES;

LIST @ENTERPRISE_STAGE;

-- Phase-2 : Data Loading
-- -------------------------

-- 6.Upload all CSV files.

-- uploaded in stage

-- 7.Create all required tables.
CREATE TABLE CUSTOMERS (
    customer_id INTEGER,
    customer_name VARCHAR,
    city VARCHAR,
    membership VARCHAR
);

CREATE TABLE PRODUCTS (
    product_id INTEGER,
    product_name VARCHAR,
    category VARCHAR,
    price NUMBER(10,2)
);

CREATE TABLE BRANCHES (
    branch_id INTEGER,
    branch_name VARCHAR,
    state VARCHAR
);

CREATE TABLE SALES (
    sale_id INTEGER,
    customer_id INTEGER,
    product_id INTEGER,
    branch_id INTEGER,
    quantity INTEGER,
    sale_date DATE,
    total_amount NUMBER(10,2)
);

-- 8.Load sales_history.csv into SALES table.
COPY INTO SALES
FROM @enterprise_stage/sales_history.csv
FILE_FORMAT = (FORMAT_NAME = CSV_FILE_FORMAT);

-- 9.Verify the loaded records.
SELECT * FROM SALES
ORDER BY SALE_ID;

SELECT COUNT(*) AS TOTAL_RECORDS FROM SALES;

-- Phase-3 : Incremental Loading
-- --------------------------------

-- 10.Create a Stream on the SALES table.
CREATE STREAM SALES_STREAM
ON TABLE SALES;

SHOW STREAMS;

-- 11.Load new_sales.csv.
COPY INTO SALES
FROM @enterprise_stage/new_sales.csv
FILE_FORMAT = (FORMAT_NAME = CSV_FILE_FORMAT);

SELECT * FROM SALES
ORDER BY SALE_ID;

SELECT COUNT(*) AS TOTAL_RECORDS FROM SALES;

-- 12.Display only newly inserted records using the Stream.
SELECT *
FROM SALES_STREAM
WHERE METADATA$ACTION = 'INSERT';

SELECT COUNT(*) AS NEW_RECORDS
FROM SALES_STREAM
WHERE METADATA$ACTION = 'INSERT';

-- 13.Merge newly arrived records into the SALES table.

MERGE INTO SALES AS TARGET
USING SALES_STREAM AS SOURCE
ON TARGET.SALE_ID = SOURCE.SALE_ID

WHEN NOT MATCHED
    AND METADATA$ACTION = 'INSERT'
THEN INSERT(
    sale_id,
    customer_id,
    product_id,
    branch_id,
    quantity,
    sale_date,
    total_amount
)
VALUES(
    source.sale_id,
    source.customer_id,
    source.product_id,
    source.branch_id,
    source.quantity,
    source.sale_date,
    source.total_amount
);

-- Phase-4 : Data Validation
-- -------------------------

-- 14.Identify duplicate Sale IDs.
select sale_id, count(*) as record_count
from sales
group by sale_id
having count(*) > 1
order by sale_id;

-- 15.Identify missing Customer IDs.
-- checking if any customer is present in sales table but not in customer table i.e. finding missing customer
select distinct s.customer_id,
from sales s
left join customers c on s.customer_id = c.customer_id
where c.customer_id is null
order by s.customer_id;

-- 16.Display invalid Product IDs.
select distinct s.product_id
from sales s
left join products p on s.product_id = p.product_id
where p.product_id is null
order by s.product_id;

-- 17.Count total newly inserted records.
select count(*) as new_record_count
from sales_stream
where METADATA$ACTION = 'INSERT';
-- the above query returns 0 rows because the stream has been already consumed by merge(dml operation).

-- instead use this
select count(*) as new_record_count
from sales
where sale_id between 6 and 10;

-- Phase-5 : Time Travel
-- ---------------------

-- 18.Delete one sales record.
select * from sales where sale_id = 10;

delete from sales where sale_id = 10;

select * from sales where sale_id = 10;
-- successfully deleted

-- 19.Recover the deleted record using Time Travel.
//finding the deleted data using 'before(statement => 'query_id')'
select *
from sales
before(statement => '01c6f893-0002-1116-000f-7292000c447a')
where sale_id = 10;

//recovery
insert into sales
select sale_id,
    customer_id,
    product_id,
    branch_id,
    quantity,
    sale_date,
    total_amount
from sales
before(statement => '01c6f893-0002-1116-000f-7292000c447a')
where sale_id = 10;

-- 20.Verify recovery.
select * from sales where sale_id = 10;

-- Phase-6 : Zero Copy Clone
-- -------------------------

-- 21.Create a clone named: SALES_TEST
create table sales_test
clone sales;

show tables;

-- 22.Display cloned records.
SELECT *
FROM SALES_TEST
ORDER BY SALE_ID;

-- 23.Insert one new record into the clone.
INSERT INTO SALES_TEST (
    sale_id,
    customer_id,
    product_id,
    branch_id,
    quantity,
    sale_date,
    total_amount
)
VALUES (
    11,1,101,1,1,'2026-07-11',60000
);

SELECT COUNT(*) AS CLONE_RECORDS
FROM SALES_TEST;

-- 24.Verify that the original SALES table remains unchanged.
SELECT COUNT(*) AS ORIGINAL_COUNT
FROM SALES;
-- sales table unchanged

-- Phase-7 : Task Automation
-- -------------------------
-- 25.Create a Task that automatically performs incremental loading every day.
CREATE OR REPLACE TASK DAILY_SALES_INCREMENT
WAREHOUSE = ENTERPRISE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC'
WHEN SYSTEM$STREAM_HAS_DATA('SALES_STREAM')
AS
MERGE INTO SALES AS target
USING SALES_STREAM AS source
ON target.sale_id = source.sale_id

when not matched
and METADATA$ACTION = 'INSERT'
THEN INSERT(
    sale_id,
    customer_id,
    product_id,
    branch_id,
    quantity,
    sale_date,
    total_amount
)
VALUES (
    source.sale_id,
    source.customer_id,
    source.product_id,
    source.branch_id,
    source.quantity,
    source.sale_date,
    source.total_amount
);

SHOW TASKS;

-- 26.Resume the Task.

-- state = suspended
ALTER TASK DAILY_SALES_INCREMENT RESUME;
-- state = started
SHOW TASKS;

-- 27.Verify Task execution.
SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.TASK_HISTORY(
        TASK_NAME => 'DAILY_SALES_INCREMENT',
        RESULT_LIMIT => 10
    )
);
-- state = scheduled i.e. task not completed, it is waiting for scheduled time to get executed.

-- manually executing the task irrespective of scheduled time.
EXECUTE TASK DAILY_SALES_INCREMENT;

SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.TASK_HISTORY(
        TASK_NAME => 'DAILY_SALES_INCREMENT',
        RESULT_LIMIT => 10
    )
);
-- state = succeeded

-- Phase-8 : Business Analytics
-- -----------------------------

-- Generate
-- 28.Customer Revenue Report
select customer_id, sum(total_amount) as total_revenue
from sales
group by customer_id
order by total_revenue desc;

-- 29.Branch Revenue Report
select branch_id, sum(total_amount) as total_revenue
from sales
group by branch_id;

-- 30.Product Revenue Report
select product_id, sum(total_amount) as total_revenue
from sales
group by product_id;

-- 31.Monthly Revenue Report
select DATE_TRUNC('MONTH', sale_date) AS MONTHLY_SALES,
    sum(total_amount) as total_revenue
from sales
group by DATE_TRUNC('MONTH', sale_date)
order by MONTHLY_SALES;

-- 32.Highest Revenue Customer
select customer_id, sum(total_amount) as total_revenue
from sales
group by customer_id
order by total_revenue desc
limit 1;

-- 33.Highest Revenue Branch
select branch_id, sum(total_amount) as total_revenue
from sales
group by branch_id
order by total_revenue desc
limit 1;

-- 34.Top Five Products
select product_id, sum(total_amount) as total_revenue
from sales
group by product_id
order by total_revenue desc
limit 5;

-- 35.Customer Purchase Frequency
select customer_id, count(*) as purchase_frequency
from sales
group by customer_id;

-- 36.Running Revenue
-- select * from sales limit 1;
select sale_date, total_amount, sum(total_amount) over(
    order by sale_date
) as running_revenue
from sales
order by sale_date;

-- 37.Customer Ranking
select customer_id, SUM(total_amount) AS total_revenue,
    rank() over(
        order by sum(total_amount) desc
    ) as rnk
from sales
group by customer_id;

-- Phase-9 : Views
-- ----------------

-- 38.Create View: CUSTOMER_REVENUE
create or replace view customer_revenue as
select customer_id, sum(total_amount) as total_revenue
from sales
group by customer_id
order by total_revenue desc;

-- 39.Create Materialized View: BRANCH_REVENUE
create or replace materialized view branch_revenue as
select branch_id, sum(total_amount) as total_revenue
from sales
group by branch_id;

-- 40.Display data from both Views.
select * from customer_revenue;

select * from branch_revenue order by total_revenue desc;

