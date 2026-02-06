/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/


CREATE or ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 

	BEGIN TRY
		SET @batch_start_time =GETDATE()
	
		PRINT '===================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '===================================================';


		PRINT '---------------------------------------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '---------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT 'TRUNCATING TABLE BRONZE.CRM_CUST_INFO'
		PRINT '---------------------------------------------------';
		TRUNCATE TABLE bronze.crm_cust_info; 
		PRINT 'INSERTING TABLE BRONZE.CRM_CUST_INFO'
		PRINT '---------------------------------------------------';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\khatt\Desktop\SQLDATABASEWAREHOUSE\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time=GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'SECONDS';


		set @start_time =GETDATE()
		PRINT 'TRUNCATING TABLE BRONZE.CRM_PRD_INFO'
		PRINT '---------------------------------------------------';
		TRUNCATE TABLE bronze.crm_prd_info; 
		PRINT 'INSERTING TABLE BRONZE.CRM_PRD_INFO'
		PRINT '---------------------------------------------------';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\khatt\Desktop\SQLDATABASEWAREHOUSE\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'SECONDS';

		set @start_time =GETDATE()

		PRINT 'TRUNCATING TABLE BRONZE.CRM_SALES_DETAILS'
		PRINT '---------------------------------------------------';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT 'INSERTING TABLE BRONZE.CRM_SALES_DETAILS'
		PRINT '---------------------------------------------------';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\khatt\Desktop\SQLDATABASEWAREHOUSE\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE()

		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'SECONDS';
	

		PRINT '---------------------------------------------------';
		PRINT 'LOADING ERP TABLES';
		PRINT '---------------------------------------------------';
		PRINT 'TRUNCATING TABLE BRONZE.ERP_CUST_AZ12'
		PRINT '---------------------------------------------------';


		set @start_time =GETDATE()

		TRUNCATE TABLE bronze.erp_cust_az12; 
		PRINT 'INSERTING TABLE BRONZE.ERP_CUST_AZ12'
		PRINT '---------------------------------------------------';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\khatt\Desktop\SQLDATABASEWAREHOUSE\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE()

		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'SECONDS';


		PRINT 'TRUNCATING TABLE BRONZE.ERP_LOC_A101'
		PRINT '---------------------------------------------------';
		TRUNCATE TABLE bronze.erp_loc_a101; 
		PRINT 'INSERTING TABLE BRONZE.ERP_LOC_A101'
		PRINT '---------------------------------------------------';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\khatt\Desktop\SQLDATABASEWAREHOUSE\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE()

		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'SECONDS';


		PRINT 'TRUNCATING TABLE BRONZE.ERP_PX_CAT_G1V2'
		PRINT '---------------------------------------------------';
		PRINT 'INSERTING TABLE BRONZE.ERP_PX_CAT_G1V2'
		PRINT '---------------------------------------------------';
		set @start_time =GETDATE()

		TRUNCATE TABLE bronze.erp_px_cat_g1v2; 
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\khatt\Desktop\SQLDATABASEWAREHOUSE\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE()

		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'SECONDS';

		set @batch_end_time = GETDATE()
		PRINT 'ENTIRE BATCH DURATION' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR ) + 'seconds';
	END TRY
	BEGIN CATCH
		PRINT '====================================';
		PRINT 'ERROR OCCURED';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + cast(ERROR_NUMBER() as NVARCHAR);
		PRINT 'Error Message' + cast(ERROR_STATE() AS NVARCHAR);

		PRINT '====================================';

	END CATCH
END