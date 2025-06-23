TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    ELSE 'n/a'
END AS cst_marital_status, -- Normalize cst_marital_status values to readable format
CASE
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    ELSE 'n/a'
END AS cst_gndr, -- Normalize cst_gndr values to readable format
cst_create_date
from (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS last_flag
	FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)t WHERE last_flag = 1; -- select the most recent record per customer

--------------------------

TRUNCATE TABLE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- Extract Category ID
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key, -- Extract product key
prd_nm,
IFNULL(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line, -- Normalize of product line into readable format
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(DATE_SUB(
		LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt),
		INTERVAL 1 DAY
	)AS DATE) AS prd_end_dt -- Calculate end date as one day before next start date
FROM bronze.crm_prd_info

------------------------

TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details (
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price)
    
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
    CASE 
		WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d')
	END  AS sls_order_dt,
    CASE 
		WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d')
	END  AS sls_ship_dt,
    CASE 
		WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d')
	END  AS sls_due_dt,
    CASE 
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
	END as sls_sales, -- Derived sales if original is invalid
    sls_quantity,
    CAST(
		CASE 
			WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price 
		END
    AS SIGNED) AS sls_price -- Derive price if original value is invalid
FROM bronze.crm_sales_details

