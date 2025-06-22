/*
===============================================================================
Load staging Layer (Source -> staging)
===============================================================================
Script Purpose:
    These queries load data into staging layers table from LOCAL csv files. 
    It performs the following actions:
    - Truncates the staging tables before loading data.
    - Uses the `LOAD DATA LOCAL INFILE` command to load data from csv Files to staging tables.

Note:
    - MySQL does not support 'LOAD DATA LOCAL INFILE' in stored procedure (security Concern).
    - Use below queries to first load data into staging tables, then use 
	  stored procedure to load into bronze layer. 
===============================================================================
*/


/*
-------------------------------------------------
	Loading CRM tables.
-------------------------------------------------
*/

TRUNCATE TABLE staging.crm_cust_info;
LOAD DATA LOCAL INFILE '/Users/kunalmpawar/Downloads/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE staging.crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(@cst_id,@cst_key,@cst_firstname,@cst_lastname,@cst_marital_status,@cst_gndr,@cst_create_date) 
SET
cst_id = NULLIF(TRIM(@cst_id),''),
cst_key = NULLIF(TRIM(@cst_key),''),
cst_firstname = NULLIF(TRIM(@cst_firstname),''),
cst_lastname = NULLIF(TRIM(@cst_lastname),''),
cst_marital_status = NULLIF(TRIM(@cst_marital_status),''),
cst_gndr = NULLIF(TRIM(@cst_gndr),''),
cst_create_date = STR_TO_DATE(NULLIF(TRIM(@cst_create_date),''), '%Y-%m-%d %H:%i:%s');
		

TRUNCATE TABLE staging.crm_prd_info;
LOAD DATA LOCAL INFILE '/Users/kunalmpawar/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE staging.crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(@prd_id,@prd_key,@prd_nm,@prd_cost,@prd_line,@prd_start_dt,@prd_end_dt)
SET
  prd_id       = NULLIF(TRIM(@prd_id), ''),
  prd_key      = NULLIF(TRIM(@prd_key), ''),
  prd_nm       = NULLIF(TRIM(@prd_nm), ''),
  prd_cost     = NULLIF(TRIM(@prd_cost), ''),
  prd_line     = NULLIF(TRIM(@prd_line), ''),
  prd_start_dt = STR_TO_DATE(NULLIF(TRIM(@prd_start_dt), ''), '%Y-%m-%d %H:%i:%s'),
  prd_end_dt   = STR_TO_DATE(NULLIF(TRIM(@prd_end_dt), ''), '%Y-%m-%d %H:%i:%s');


TRUNCATE TABLE staging.crm_sales_details;
LOAD DATA LOCAL INFILE '/Users/kunalmpawar/Downloads/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE staging.crm_sales_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(@sls_ord_num,@sls_prd_key,@sls_cust_id,@sls_order_dt,@sls_ship_dt,@sls_due_dt,@sls_sales,@sls_quantity,@sls_price)
SET
	sls_ord_num    = NULLIF(TRIM(@sls_ord_num), ''),
	sls_prd_key    = NULLIF(TRIM(@sls_prd_key), ''),
	sls_cust_id    = NULLIF(TRIM(@sls_cust_id), ''),
	sls_order_dt   = NULLIF(TRIM(@sls_order_dt), ''),
	sls_ship_dt    = NULLIF(TRIM(@sls_ship_dt), ''),
	sls_due_dt     = NULLIF(TRIM(@sls_due_dt), ''),
	sls_sales      = NULLIF(TRIM(@sls_sales), ''),
	sls_quantity   = NULLIF(TRIM(@sls_quantity), ''),
	sls_price      = NULLIF(TRIM(@sls_price), '');


/*
-------------------------------------------------
	Loading ERP tables.
-------------------------------------------------
*/

TRUNCATE TABLE staging.erp_cust_az12;
LOAD DATA LOCAL INFILE '/Users/kunalmpawar/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE staging.erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(@CID,@BDATE,@GEN)
SET 
    CID = NULLIF(TRIM(@CID),''),
    BDATE = STR_TO_DATE(NULLIF(TRIM(@BDATE),''), '%Y-%m-%d %H:%i:%s'),
    GEN = NULLIF(TRIM(@GEN),'');


TRUNCATE TABLE staging.erp_loc_a101;
LOAD DATA LOCAL INFILE '/Users/kunalmpawar/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
INTO TABLE staging.erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(@CID,@CNTRY)
SET 
    CID = NULLIF(TRIM(@CID),''),
    CNTRY = NULLIF(TRIM(@CNTRY),'');
    
    

TRUNCATE TABLE staging.erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE '/Users/kunalmpawar/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE staging.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(@ID,@CAT,@SUBCAT,@MAINTENANCE)
SET 
    ID = NULLIF(TRIM(@ID),''),
    CAT = NULLIF(TRIM(@CAT),''),
    SUBCAT = NULLIF(TRIM(@SUBCAT),''),
    MAINTENANCE = NULLIF(TRIM(@MAINTENANCE),'');
