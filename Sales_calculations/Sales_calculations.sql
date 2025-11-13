- Query to re-calculate Total Due as Subtotal in SalesOrderHeader does not match Line Total in SalesOrderDetail.	
SELECT	
productcategory.ProductCategoryID,	
productcategory.Name AS Category,	
productsub.Name AS ProductSubCategory,	
SalesOrderID,	
StandardCost,	
ListPrice,	
salesorderdetail.LineTotal,	
salesorderdetail.LineTotal * 0.08 AS TaxAmt,	
salesorderdetail.LineTotal * 0.025 AS Freight,	
salesorderdetail.LineTotal + salesorderdetail.LineTotal * 0.08 + salesorderdetail.LineTotal * 0.025 AS TotalDue,	
FROM `adwentureworks_db.salesorderdetail` AS salesorderdetail	
LEFT JOIN `adwentureworks_db.product` AS product	
ON product.ProductID = salesorderdetail.ProductID	
LEFT JOIN `adwentureworks_db.productsubcategory` AS productsub	
ON productsub.ProductSubcategoryID = product.ProductSubcategoryID	
LEFT JOIN `adwentureworks_db.productcategory` AS productcategory	
ON productcategory.ProductCategoryID = productsub.ProductCategoryID	
	
	
	
-Formula used to calculate Tax and Freight percentages.	
WITH percentage AS(	
SELECT	
SalesOrderID,	
ROUND((TaxAmt/SubTotal*100),2)/100 AS perc_of_tax,	
ROUND((Freight/SubTotal*100),2)/100 AS perc_of_freight,	
FROM adwentureworks_db.salesorderheader	
),	
null_check AS (SELECT	
SUM(CASE WHEN TaxAmt IS NULL THEN 1 ELSE 0 END) AS null_check_tax,	
SUM(CASE WHEN Freight IS NULL THEN 1 ELSE 0 END) AS null_check_freight	
FROM adwentureworks_db.salesorderheader	
	
SELECT	
MIN(percentage.perc_of_tax) AS MIN_tax,	
MAX(percentage.perc_of_tax) AS MAX_tax,	
MIN(percentage.perc_of_freight) AS MIN_freight,	
MAX(percentage.perc_of_freight) AS MAX_freight,	
FROM percentage	