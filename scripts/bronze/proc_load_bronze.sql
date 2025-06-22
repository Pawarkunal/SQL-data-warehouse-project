/*
===============================================================================
Stored Procedure: Load Bronze Layer (staging -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure insert data into the 'bronze' tables from staging database tables. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Insert raw data from staging to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/


DELIMITER // 

CREATE PROCEDURE bronze.load_bronze() 

BEGIN 
	TRUNCATE TABLE bronze.crm_cust_info;
	INSERT INTO bronze.crm_cust_info
    SELECT * FROM staging.crm_cust_info;

	TRUNCATE TABLE bronze.crm_prd_info;
	INSERT INTO bronze.crm_prd_info
    SELECT * FROM staging.crm_prd_info;

	TRUNCATE TABLE bronze.crm_sales_details;
	INSERT INTO bronze.crm_sales_details
    SELECT * FROM staging.crm_sales_details;

	TRUNCATE TABLE bronze.erp_cust_az12;
	INSERT INTO bronze.erp_cust_az12
    SELECT * FROM staging.erp_cust_az12;

	TRUNCATE TABLE bronze.erp_loc_a101;
	INSERT INTO bronze.erp_loc_a101
    SELECT * FROM staging.erp_loc_a101;

	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	INSERT INTO bronze.erp_px_cat_g1v2
    SELECT * FROM staging.erp_px_cat_g1v2;
END //

DELIMITER ;
