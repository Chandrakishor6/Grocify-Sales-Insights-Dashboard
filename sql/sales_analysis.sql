--Analyzing Different Metrics
/**
1. Total Sales
2. Average Sales
3. Average rating
4. Total Item sold
5. Total Sales, Avg sales and avg rating by fat content, item type and outlet location
6. Pivot Table to get sales value based on outlet location type and item fat content
7. Sales by outlet establishment year
8. Percentage of sales by outlet size
9. Sales by outlet location type
10.Sales by outlet type 
**/

-- 1. Total Sales

SELECT CONCAT(CAST(SUM(SALES)/1000000 AS DECIMAL(10,2)), ' MILLION') AS TOTAL_SALES FROM Grocify_DATA


-- 2. Average Sales

select cast(avg(sales) as decimal(10,2)) as average_sales from Grocify_DATA

-- 3. Average Rating

select cast(avg(rating) as decimal(10,2)) as average_ratings from Grocify_DATA

-- Total item sold

select count(*) as total_item from Grocify_DATA;


--4. Total Sales, Avg sales and avg rating by fat content, item type and outlet location

SELECT CONCAT(CAST(SUM(SALES)/1000000 AS DECIMAL(10,2)), ' MILLION') AS TOTAL_SALES FROM Grocify_DATA
where Item_Fat_Content = 'Low Fat'

select Item_Fat_Content, 
CAST(SUM(SALES)/1000000 AS DECIMAL(10,2)) AS Total_Sales,
cast(avg(sales) as decimal(10,2)) as average_sales,
cast(avg(rating) as decimal(10,2)) as average_ratings
from Grocify_DATA 
where Outlet_Establishment_Year = 2022
group by Item_Fat_Content
order by Total_Sales desc

select top 5 Item_Type, 
CAST(SUM(SALES) AS DECIMAL(10,2)) AS Total_Sales,
cast(avg(sales) as decimal(10,2)) as average_sales,
cast(avg(rating) as decimal(10,2)) as average_ratings
from Grocify_DATA
group by Item_Type
order by Total_Sales desc

select Outlet_Location_Type, Item_Fat_Content, 
CAST(SUM(SALES) AS DECIMAL(10,2)) AS Total_Sales,
cast(avg(sales) as decimal(10,2)) as average_sales,
cast(avg(rating) as decimal(10,2)) as average_ratings
from Grocify_DATA
group by Outlet_Location_Type, Item_Fat_Content
order by Total_Sales desc

-- 5. Pivot Table to get Total sales, Avg Sales and no. item sold based on outlet location type and item fat content

select outlet_location_type,
ISNULL([Low Fat], 0) as Low_Fat,
ISNULL([Regular], 0) as regular_Fat
from (
select outlet_location_type, item_fat_content,
CAST(sum(sales) as decimal(10,2)) as total_sales
from Grocify_DATA
group by Outlet_Location_Type, Item_Fat_Content
) as sourceTable
pivot(
sum(total_sales) for item_fat_content in ([Low Fat], [Regular])
) as pivotTable
order by Outlet_Location_Type

-- 6. Sales by outlet establishment year

select Outlet_Establishment_Year,
cast(sum(Sales) as decimal(10,2)) as total_sales,
cast(avg(sales) as decimal(10, 2)) as avg_sales,
round(avg(Rating),0) as avg_rating
from Grocify_DATA
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc

-- 7. Percentage of sales by outlet size

select outlet_size,
cast(sum(sales) as decimal(10,2)) as totalSales,
CAST((sum(sales)*100.0/sum(sum(sales)) over()) as decimal(10, 2)) as salesPercentage
from Grocify_DATA
group by Outlet_Size
order by totalSales desc;

-- 8. Sales by outlet location type

select Outlet_Location_Type,
cast(sum(Sales) as decimal(10,2)) as total_sales,
cast(avg(sales) as decimal(10, 2)) as avg_sales,
count(*) as totalSalesQuantity,
round(avg(Rating),0) as avg_rating
from Grocify_DATA
group by Outlet_Location_Type
order by total_sales

-- 9. Sales by outlet type

select Outlet_Type,
cast(sum(Sales) as decimal(10,2)) as total_sales,
cast(avg(sales) as decimal(10, 2)) as avg_sales,
count(*) as totalSalesQuantity,
round(avg(Rating),0) as avg_rating
from Grocify_DATA
group by Outlet_Type
order by total_sales
