-- GOLDLAYER

-- CHECKING FOR DUPLICATES
select cst_id, count(*) from (
	SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry

	from silver.crm_cust_info ci 
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	
	LEFT JOIN silver.erp_loc_a101 la
	on ci.cst_key = la.cid
	)t GROUP BY cst_id
	Having count(*) >1;






	SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE (ca.gen, 'n/a')
	END AS new_gen


	from silver.crm_cust_info ci 
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	
	LEFT JOIN silver.erp_loc_a101 la
	on ci.cst_key = la.cid
	order by 1,2











CREATE VIEW gold.dim_customers AS 
	SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) as customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,
	ci.cst_marital_status as marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE (ca.gen, 'n/a')
	END AS gender,
	ca.bdate as birthday,
	ci.cst_create_date as create_date



	from silver.crm_cust_info ci 
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	
	LEFT JOIN silver.erp_loc_a101 la
	on ci.cst_key = la.cid






SELECT prd_key, count(*) from (
SELECT 
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
from silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id

where prd_end_dt is NULL -- FILTER OUT ALL HISTORICAL DATA
)t group by prd_key
having count(*)>1;


CREATE VIEW gold.dim_product AS 
SELECT 
ROW_NUMBER() OVER (ORDER BY pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.cat as category,
pc.subcat as sub_cateogry,

pc.maintenance as maintenace,

pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date

from silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id

where prd_end_dt is NULL -- FILTER OUT ALL HISTORICAL DATA







CREATE VIEW gold.fact_sale AS
SELECT 
sd.sls_ord_num as order_number,

pr.product_key,
cu.customer_id,


sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd 
LEFT JOIN gold.dim_product pr
on sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id

