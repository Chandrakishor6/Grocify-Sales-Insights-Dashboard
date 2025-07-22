--Identifying inconsistency in datas
/** 
1. Typos in item fat content column (like LF, low fat) insted of Low Fat and reg instead of Regular.
2. Missing values in outlet type column(<5% thus removing records with null values)
3. Outliers in rating column such as <0 and >5 (Updating with grouped mean values)
**/

--Correcting Typos

UPDATE Grocify_DATA 
SET Item_Fat_Content =
CASE 
WHEN Item_Fat_Content IN ('LF', 'low fat') then 'Low_Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end;

--Deleting Records with NULL values

delete from Grocify_DATA
where Outlet_Type is null;

--Removing Outliers (Updating with grouped mean values)

with Grouped_mean as (
select Item_Identifier, Outlet_Identifier, avg(Rating) as groupedMean from Grocify_DATA
where Rating between 0 and 5
group by Item_Identifier, Outlet_Identifier
)

update gd
set gd.Rating = gm.groupedMean from Grocify_DATA as gd
join Grouped_mean as gm on
gm.Item_Identifier=gd.Item_Identifier and gm.Outlet_Identifier =  gd.Outlet_Identifier
where Rating<0 or Rating>5;
