--CREATE DATABASE KMS_DB

--CASE SCENERIO ONE

--1. Which product category had the highest sales?
--SELECT TOP 1
--    Product_Category,
--    SUM(Unit_Price * (1 - Discount)) AS Total_Sales
--FROM dbo.KMS_PROJECT
--GROUP BY Product_Category
--ORDER BY Total_Sales DESC;

--2. What are the Top 3 and Bottom 3 regions in terms of sales?
-- Top 3 regions
--SELECT TOP 3
--    Region,
--    SUM(Unit_Price * (1 - Discount)) AS Total_Sales
--FROM dbo.KMS_PROJECT
--GROUP BY Region
--ORDER BY Total_Sales DESC;

-- Bottom 3 regions
--SELECT TOP 3
--    Region,
--    SUM(Unit_Price * (1 - Discount)) AS Total_Sales
--FROM dbo.KMS_PROJECT
--GROUP BY Region
--ORDER BY Total_Sales ASC;

--3. What were the total sales of appliances in Ontario?
--SELECT 
--    SUM(Unit_Price * (1 - Discount)) AS Total_Appliance_Sales_Ontario
--FROM dbo.KMS_PROJECT
--WHERE Product_Category = 'Appliances' 
--AND Province = 'Ontario';

--To find sales by actual categories in Ontario:
--SELECT 
--    Product_Category,
--    SUM(Unit_Price * (1 - Discount)) AS Total_Sales
--FROM dbo.KMS_PROJECT
--WHERE Province = 'Ontario'
--GROUP BY Product_Category
--ORDER BY Total_Sales DESC;

--4. Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers
-- Bottom 10 customers analysis
--SELECT TOP 10
--    Customer_Name,
--    SUM(Unit_Price * (1 - Discount)) AS Total_Spend
--FROM dbo.KMS_PROJECT
--GROUP BY Customer_Name
--ORDER BY Total_Spend ASC;

--Analyzing their purchase patterns
--SELECT 
--    Customer_Segment,
--    Product_Category,
--    COUNT(*) AS Purchase_Count
--FROM dbo.KMS_PROJECT
--WHERE Customer_Name IN (
--    SELECT TOP 10 Customer_Name
--    FROM dbo.KMS_PROJECT
--    GROUP BY Customer_Name
--    ORDER BY SUM(Unit_Price * (1 - Discount)) ASC
--)
--GROUP BY Customer_Segment, Product_Category;

-- POTENTIAL RECOMMENDATIONS:
-- 1. Targeted promotions for these customers' preferred categories
-- 2. Bundle offers combining their frequent purchases
-- 3. Loyalty programs to increase purchase frequency
-- 4. Customer surveys to understand their needs better

--5. KMS incurred the most shipping cost using which shipping method?
--Shipping method with highest cost
--SELECT TOP 1
--    Ship_Mode,
--    SUM(Shipping_Cost) AS Total_Shipping_Cost
--FROM dbo.KMS_PROJECT
--GROUP BY Ship_Mode
--ORDER BY Total_Shipping_Cost DESC;

--CASE SCENERIO II

--6. Who are the most valuable customers, and what products or services do they typically purchase?
-- Top 10 valuable customers by spend
--SELECT TOP 10
--    Customer_Name,
--    SUM(Unit_Price * (1 - Discount)) AS Total_Spend,
--    SUM(Profit) AS Total_Profit
--FROM dbo.KMS_PROJECT
--GROUP BY Customer_Name
--ORDER BY Total_Spend DESC;

-- Their typical purchases
--SELECT 
--    Product_Category,
--    Product_Sub_Category,
--    COUNT(*) AS Purchase_Count
--FROM dbo.KMS_PROJECT
--WHERE Customer_Name IN (
--    SELECT TOP 10 Customer_Name
--    FROM dbo.KMS_PROJECT
--    GROUP BY Customer_Name
--    ORDER BY SUM(Unit_Price * (1 - Discount)) DESC
--)
--GROUP BY Product_Category, Product_Sub_Category
--ORDER BY Purchase_Count DESC;

--7. Which small business customer had the highest sales? 
--SELECT TOP 1
--    Customer_Name,
--    SUM(Unit_Price * (1 - Discount)) AS Total_Sales
--FROM dbo.KMS_PROJECT
--WHERE Customer_Segment = 'Small Business'
--GROUP BY Customer_Name
--ORDER BY Total_Sales DESC;

--8. Which Corporate Customer placed the most number of orders in 2009 – 2012? 
--SELECT TOP 1
--    Customer_Name,
--    COUNT(DISTINCT Order_ID) AS Order_Count
--FROM dbo.KMS_PROJECT
--WHERE Customer_Segment = 'Corporate'
--AND YEAR(Order_Date) BETWEEN 2009 AND 2012
--GROUP BY Customer_Name
--ORDER BY Order_Count DESC;

--9. Which consumer customer was the most profitable one? 
--SELECT TOP 1
--    Customer_Name,
--    SUM(Profit) AS Total_Profit
--FROM dbo.KMS_PROJECT
--WHERE Customer_Segment = 'Consumer'
--GROUP BY Customer_Name
--ORDER BY Total_Profit DESC;

--10. Which customer returned items, and what segment do they belong to?
--SELECT 
--    k.Customer_Name,
--    k.Customer_Segment,
--    o.Status,
--    COUNT(o.Order_ID) AS Returned_Orders_Count
--FROM 
--    dbo.KMS_PROJECT k
--JOIN 
--    dbo.Order_Status_PROJECT o ON k.Order_ID = o.Order_ID
--WHERE 
--    o.Status = 'Returned'
--GROUP BY 
--    k.Customer_Name, 
--    k.Customer_Segment,
--    o.Status
--ORDER BY 
--    Returned_Orders_Count DESC;

--11. If the delivery truck is the most economical but the slowest shipping method and 
--Express Air is the fastest but the most expensive one, do you think the company 
--appropriately spent shipping costs based on the Order Priority? Explain your answer 

--SELECT 
--    Order_Priority,
--    Ship_Mode,
--    AVG(Shipping_Cost) AS Avg_Shipping_Cost,
--    COUNT(*) AS Order_Count
--FROM dbo.KMS_PROJECT
--GROUP BY Order_Priority, Ship_Mode
--ORDER BY Order_Priority, Avg_Shipping_Cost DESC;

-- Analysis:
--Key Factors to Consider
--1) Shipping Methods:
--Express Air: Fastest but most expensive
--Delivery Truck: Slowest but most economical

--2)Order Priorities:
--Critical: Highest urgency
--High: Important but not emergency
--Medium/Low: Standard orders

--What We Should Expect
--An efficient shipping strategy would:
--Use Express Air for Critical orders (speed justifies cost)
--Use Regular Air for High priority orders
--Use Delivery Truck for Medium/Low priority orders (cost efficiency is key)

--Interpreting the Results
--Good Alignment would show:

--Critical orders mostly using Express Air
--High priority using Regular Air
--Low/Medium using Delivery Truck

--Misalignment Indicators:

--Critical orders using Delivery Truck (too slow)
--Low priority using Express Air (unnecessary expense)
--No clear pattern between priority and shipping method

--RECOMMENDATION
--Create clear shipping rules based on order priority

--Implement system checks to prevent low-priority orders using premium shipping

--Calculate potential savings from better alignment