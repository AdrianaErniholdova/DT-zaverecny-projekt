//dimenzie
CREATE OR REPLACE TABLE dim_item AS (
SELECT DISTINCT
    i.SPS_ITEM_MAPPING_KEY AS id_dim_item,
    CAST(i.CATEGORY_NAME AS VARCHAR(15)) AS category_name,
    CAST(i.PRODUCT_GROUP_NAME AS VARCHAR(25)) AS product_group_name,
    CAST(i.GENDER AS VARCHAR(11)) AS gender,
    CAST(i.COLOR_NAME AS VARCHAR(20)) AS color_name,
    CAST(i.SIZE_NAME AS VARCHAR(4)) AS size_name,
    CAST(i.COST AS NUMBER(8,4)) AS cost
FROM item_staging i    
);

SELECT * FROM dim_item LIMIT 10;

CREATE OR REPLACE TABLE dim_location AS (
SELECT DISTINCT
    l.SPS_CUSTOMER_LOCATION_KEY AS id_dim_location,
    CAST(l.CITY AS VARCHAR(30)) AS city,
    CAST(l.STATE AS VARCHAR(5)) AS state,
    CAST(l.POSTAL_CODE AS VARCHAR(9)) AS postal_code,
    CAST(l.SPS_COUNTRY AS VARCHAR(5)) AS country
FROM location_staging l    
);

SELECT * FROM dim_location LIMIT 10;

CREATE OR REPLACE TABLE dim_retailer AS (
SELECT DISTINCT
    r.SPS_RETAILER_NAME_KEY AS id_dim_retailer,
    CAST(r.SPS_RETAILER_NAME_KEY AS VARCHAR(30)) AS retailer_name
FROM retailer_staging r    
);

SELECT * FROM dim_retailer LIMIT 10;

CREATE OR REPLACE TABLE dim_store AS (
SELECT DISTINCT
  l.SPS_CUSTOMER_LOCATION_KEY AS id_dim_store,
  CAST(l.STORE_NAME AS VARCHAR(50)) AS store_name,
  CAST(l.STORE_NUMBER AS VARCHAR(10)) AS store_number,
  CAST(l.SPS_LOCATION_TYPE AS VARCHAR(8)) AS store_type,
  CAST(l.MALL AS VARCHAR(30)) AS mall_type
FROM location_staging l    
);

SELECT * FROM dim_store LIMIT 10;

CREATE OR REPLACE TABLE dim_date AS (
SELECT DISTINCT
    a.PERIOD_ENDING_DATE AS id_dim_date,
    TO_DATE(TO_VARCHAR(a.PERIOD_ENDING_DATE), 'YYYYMMDD') AS date,
    DAY(TO_DATE(TO_VARCHAR(a.PERIOD_ENDING_DATE), 'YYYYMMDD')) AS day,
    DAYOFWEEK(TO_DATE(TO_VARCHAR(a.PERIOD_ENDING_DATE), 'YYYYMMDD')) AS weekday,
    WEEK(TO_DATE(TO_VARCHAR(a.PERIOD_ENDING_DATE), 'YYYYMMDD')) AS week,
    MONTH(TO_DATE(TO_VARCHAR(a.PERIOD_ENDING_DATE), 'YYYYMMDD')) AS month,
    QUARTER(TO_DATE(TO_VARCHAR(a.PERIOD_ENDING_DATE), 'YYYYMMDD')) AS quarter,
    YEAR(TO_DATE(TO_VARCHAR(a.PERIOD_ENDING_DATE), 'YYYYMMDD')) AS year
FROM activity_staging a
);

SELECT * FROM dim_date LIMIT 10;

CREATE OR REPLACE TABLE fact_sales AS (
SELECT
   UUID_STRING() AS id_fact_sales,
   dr.id_dim_retailer,
   di.id_dim_item,
   dl.id_dim_location,
   dd.id_dim_date,
   ds.id_dim_store,
   a.NET_SALES_UNITS AS net_sales_units,
   CAST(a.NET_SALES_RETAIL AS NUMBER(8,4)) AS net_sales_retail,
   a.INVENTORY_UNITS AS inventory_units,
   a.CORPORATE_UNIT_OWNED_RETAIL_PRICE AS retail_price,
   a.CORPORATE_UNIT_ADJUSTED_COST AS corporate_cost,
   SUM(a.net_sales_units) OVER (PARTITION BY a.sps_item_mapping_key , a.sps_customer_location_key ORDER BY a.period_ending_date) AS cumulative_sales,
   LAG(a.net_sales_units) OVER (PARTITION BY a.sps_item_mapping_key , a.sps_customer_location_key ORDER BY a.period_ending_date) AS prev_weekly_sales 
FROM activity_staging a 
JOIN dim_retailer dr ON a.SPS_RETAILER_NAME_KEY = dr.id_dim_retailer
JOIN dim_item di ON a.SPS_ITEM_MAPPING_KEY = di.id_dim_item
JOIN dim_location dl ON a.SPS_CUSTOMER_LOCATION_KEY = dl.id_dim_location
JOIN dim_date dd ON a.period_ending_date = dd.id_dim_date
JOIN dim_store ds ON a.SPS_CUSTOMER_LOCATION_KEY = ds.id_dim_store
);

SELECT * FROM fact_sales LIMIT 10;