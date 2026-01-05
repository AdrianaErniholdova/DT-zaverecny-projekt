-- 1. vizualizácia
SELECT
    ds.store_name,
    dl.city,
    dl.state,
    SUM(fs.net_sales_units) AS total_sales_units
FROM fact_sales fs
JOIN dim_store ds ON fs.id_dim_store = ds.id_dim_store
JOIN dim_location dl ON fs.id_dim_location = dl.id_dim_location
WHERE dl.city != 'OTHER'
GROUP BY ds.store_name, dl.city, dl.state
ORDER BY total_sales_units DESC;

-- 2. vizualizácia
SELECT 
    dd.date,
    dr.retailer_name,
    SUM(fs.net_sales_retail) AS weekly_revenue,
    SUM(SUM(fs.net_sales_retail)) OVER ( 
        PARTITION BY dr.retailer_name 
        ORDER BY dd.date
    ) AS cumulative_revenue_by_retailer
FROM fact_sales fs
JOIN dim_date dd ON fs.id_dim_date = dd.id_dim_date
JOIN dim_retailer dr ON fs.id_dim_retailer = dr.id_dim_retailer
GROUP BY dd.date, dr.retailer_name
ORDER BY dr.retailer_name, dd.date;

-- 3. vizualizácia 
SELECT 
    dr.retailer_name,
    ROUND(SUM((retail_price - corporate_cost) * net_sales_units) 
    / NULLIF(SUM(net_sales_units), 0),2) 
    AS weighted_avg_margin
FROM fact_sales fs
JOIN dim_retailer dr ON fs.id_dim_retailer = dr.id_dim_retailer
GROUP BY dr.retailer_name
ORDER BY weighted_avg_margin DESC
LIMIT 10;

-- 4. vizualizácia
SELECT 
    di.id_dim_item AS product_id,
    di.category_name,
    di.product_group_name,
    di.gender,
    SUM(fs.net_sales_retail) AS total_revenue,
    SUM(fs.net_sales_units) AS total_units_sold,
    ROW_NUMBER() OVER (ORDER BY SUM(fs.net_sales_retail) DESC) AS revenue_rank
FROM fact_sales fs
JOIN dim_item di ON fs.id_dim_item = di.id_dim_item
GROUP BY di.id_dim_item, di.category_name, di.product_group_name, di.gender
ORDER BY total_revenue DESC
LIMIT 10;

-- 5. vizualizácia
SELECT 
    di.category_name, 
    SUM(fs.net_sales_units) AS total_units_sold,
    SUM(fs.net_sales_retail) AS total_sales_retail
FROM fact_sales fs
JOIN dim_item di ON fs.id_dim_item = di.id_dim_item
GROUP BY di.category_name;

-- 6. vizualizácia
SELECT 
    ds.store_name,
    dl.country,
    dl.city,
    CASE 
        WHEN dl.state = 'FL' THEN 'Florida' 
        WHEN dl.state = 'IN' THEN 'Indiana' 
        WHEN dl.state = 'NY' THEN 'New York' 
        WHEN dl.state = 'OH' THEN 'Ohio' 
        ELSE 'Unknown' 
    END AS state_name,
    ROUND(SUM(fs.net_sales_retail),2) AS total_revenue
FROM fact_sales fs
JOIN dim_location dl ON fs.id_dim_location = dl.id_dim_location
JOIN dim_store ds ON fs.id_dim_store = ds.id_dim_store
WHERE dl.city != 'OTHER' AND dl.state != 'OTHER' AND net_sales_retail > 0
GROUP BY dl.country, dl.state, dl.city, ds.store_name
ORDER BY total_revenue DESC;