CREATE DATABASE project_db;
USE project_db;
SHOW TABLES;
SELECT COUNT(*) FROM sales_data;

SELECT SUM(Sales) AS Total_Revenue
FROM sales_data;

SELECT SUM(Profit) AS Total_Profit
FROM sales_data;

SELECT 
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin_Percent
FROM sales_data;

SELECT Region,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY Region
ORDER BY Revenue DESC;

SELECT Region,
ROUND(SUM(Profit),2) AS Profit
FROM sales_data
GROUP BY Region
ORDER BY Profit DESC;

DESCRIBE sales_data;

ALTER TABLE sales_data
ADD COLUMN Order_Date DATE;

UPDATE sales_data
SET Order_Date = STR_TO_DATE(`ï»¿Date`, '%d-%m-%Y');

SELECT `ï»¿Date`, Order_Date
FROM sales_data
LIMIT 5;
ALTER TABLE sales_data
DROP COLUMN `ï»¿Date`;

-- Monthly Revenue Trend --
SELECT 
MONTH(Order_Date) AS Month_Number,
ROUND(SUM(Sales),2) AS Monthly_Revenue
FROM sales_data
GROUP BY MONTH(Order_Date)
ORDER BY Month_Number;

-- Month-over-Month Growth (MoM) --
SELECT 
MONTH(Order_Date) AS Month_Number,
ROUND(SUM(Sales),2) AS Monthly_Revenue,
ROUND(
(SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY MONTH(Order_Date))) 
/ LAG(SUM(Sales)) OVER (ORDER BY MONTH(Order_Date)) * 100
,2) AS MoM_Growth_Percent
FROM sales_data
GROUP BY MONTH(Order_Date)
ORDER BY Month_Number;

-- Category-Level Profit Analysis --
SELECT 
Category,
ROUND(SUM(Sales),2) AS Total_Revenue,
ROUND(SUM(Profit),2) AS Total_Profit,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin_Percent
FROM sales_data
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC;

SELECT 
Category,
ROUND(SUM(Sales),2) AS Revenue,
ROUND(SUM(Profit),2) AS Profit,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Margin_Percent
FROM sales_data
GROUP BY Category
ORDER BY Revenue DESC;

-- Product-Level Profitability --
SELECT 
Product,
ROUND(SUM(Sales),2) AS Revenue,
ROUND(SUM(Profit),2) AS Profit
FROM sales_data
GROUP BY Product
HAVING SUM(Profit) < 0
ORDER BY Profit ASC;

-- Check Low-Margin Products --
SELECT 
Product,
ROUND(SUM(Sales),2) AS Revenue,
ROUND(SUM(Profit),2) AS Profit,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Margin_Percent
FROM sales_data
GROUP BY Product
HAVING Margin_Percent < 20
ORDER BY Margin_Percent ASC;

-- Regional Margin Analysis --
SELECT 
Region,
ROUND(SUM(Sales),2) AS Revenue,
ROUND(SUM(Profit),2) AS Profit,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Margin_Percent
FROM sales_data
GROUP BY Region
ORDER BY Margin_Percent ASC;

SELECT 
Region,
Category,
ROUND(SUM(Sales),2) AS Revenue,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Margin_Percent
FROM sales_data
GROUP BY Region, Category
ORDER BY Region, Margin_Percent ASC;

SELECT 
Region,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Furniture_Margin
FROM sales_data
WHERE Category = 'Furniture'
GROUP BY Region
ORDER BY Furniture_Margin ASC;

-- Cumulative Revenue --
SELECT 
MONTH(Order_Date) AS Month_Number,
ROUND(SUM(Sales),2) AS Monthly_Revenue,
ROUND(
SUM(SUM(Sales)) OVER (ORDER BY MONTH(Order_Date)),
2) AS Cumulative_Revenue
FROM sales_data
GROUP BY MONTH(Order_Date)
ORDER BY Month_Number;

-- Contribution % by Region --
SELECT 
Region,
ROUND(SUM(Sales),2) AS Revenue,
ROUND(
SUM(Sales) / (SELECT SUM(Sales) FROM sales_data) * 100,
2) AS Contribution_Percent
FROM sales_data
GROUP BY Region
ORDER BY Revenue DESC;

-- Top 5 Products by Profit --
SELECT 
Product,
ROUND(SUM(Profit),2) AS Total_Profit
FROM sales_data
GROUP BY Product
ORDER BY Total_Profit DESC
LIMIT 5;